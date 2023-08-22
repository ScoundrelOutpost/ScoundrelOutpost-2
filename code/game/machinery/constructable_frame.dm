/obj/structure/frame
	name = "frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	max_integrity = 250
	var/obj/item/circuitboard/machine/circuit = null
	var/state = 1

/obj/structure/frame/examine(user)
	. = ..()
	if(circuit)
		. += "It has \a [circuit] installed."


/obj/structure/frame/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron(loc, 5)
		if(circuit)
			circuit.forceMove(loc)
			circuit = null
	qdel(src)


/obj/structure/frame/machine
	name = "machine frame"
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null // user-friendly names of components

/obj/structure/frame/machine/examine(user)
	. = ..()
	if(state != 3)
		return

	if(!length(req_components))
		. += span_info("It requires no components.")
		return .

	if(!req_component_names)
		stack_trace("[src]'s req_components list has items but its req_component_names list is null!")
		return

	var/list/nice_list = list()
	for(var/atom/component as anything in req_components)
		if(!ispath(component))
			stack_trace("An item in [src]'s req_components list is not a path!")
			continue
		if(!req_components[component])
			continue

		nice_list += list("[req_components[component]] [req_component_names[component]]\s")
	. += span_info("It requires [english_list(nice_list, "no more components")].")

/**
 * Collates the displayed names of the machine's components
 *
 * Arguments:
 * * specific_parts - If true, the component should not use base name, but a specific tier
 */
/obj/structure/frame/machine/proc/update_namelist(specific_parts)
	if(!req_components)
		return

	req_component_names = list()
	for(var/atom/component_path as anything in req_components)
		if(!ispath(component_path))
			continue

		req_component_names[component_path] = initial(component_path.name)

		if(ispath(component_path, /obj/item/stack))
			var/obj/item/stack/stack_path = component_path
			if(initial(stack_path.singular_name))
				req_component_names[component_path] = initial(stack_path.singular_name)
				continue

		if(ispath(component_path, /obj/item/stock_parts))
			var/obj/item/stock_parts/stock_part = component_path
			if(!specific_parts && initial(stock_part.base_name))
				req_component_names[component_path] = initial(stock_part.base_name)
			else
				req_component_names[component_path] = initial(stock_part.name)

/obj/structure/frame/machine/proc/get_req_components_amt()
	var/amt = 0
	for(var/path in req_components)
		amt += req_components[path]
	return amt

/obj/structure/frame/machine/attackby(obj/item/P, mob/living/user, params)
	switch(state)
		if(1)
			if(istype(P, /obj/item/circuitboard/machine))
				to_chat(user, span_warning("The frame needs wiring first!"))
				return
			else if(istype(P, /obj/item/circuitboard))
				to_chat(user, span_warning("This frame does not accept circuit boards of this type!"))
				return
			if(istype(P, /obj/item/stack/cable_coil))
				if(!P.tool_start_check(user, amount=5))
					return

				to_chat(user, span_notice("You start to add cables to the frame..."))
				if(P.use_tool(src, user, 20, volume=50, amount=5))
					to_chat(user, span_notice("You add cables to the frame."))
					state = 2
					icon_state = "box_1"

				return
			if(P.tool_behaviour == TOOL_SCREWDRIVER && !anchored)
				user.visible_message(span_warning("[user] disassembles the frame."), \
									span_notice("You start to disassemble the frame..."), span_hear("You hear banging and clanking."))
				if(P.use_tool(src, user, 40, volume=50))
					if(state == 1)
						to_chat(user, span_notice("You disassemble the frame."))
						var/obj/item/stack/sheet/iron/M = new (loc, 5)
						if (!QDELETED(M))
							M.add_fingerprint(user)
						qdel(src)
				return
			if(P.tool_behaviour == TOOL_WRENCH)
				var/turf/ground = get_turf(src)
				if(!anchored && ground.is_blocked_turf(exclude_mobs = TRUE, source_atom = src))
					to_chat(user, span_notice("You fail to secure [src]."))
					return
				to_chat(user, span_notice("You start [anchored ? "un" : ""]securing [src]..."))
				if(P.use_tool(src, user, 40, volume=75))
					if(state == 1)
						to_chat(user, span_notice("You [anchored ? "un" : ""]secure [src]."))
						set_anchored(!anchored)
				return

		if(2)
			if(P.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("You start [anchored ? "un" : ""]securing [src]..."))
				if(P.use_tool(src, user, 40, volume=75))
					to_chat(user, span_notice("You [anchored ? "un" : ""]secure [src]."))
					set_anchored(!anchored)
				return

			if(istype(P, /obj/item/circuitboard/machine))
				var/obj/item/circuitboard/machine/board = P
				if(!board.build_path)
					to_chat(user, span_warning("This circuitboard seems to be broken."))
					return
				if(!anchored && board.needs_anchored)
					to_chat(user, span_warning("The frame needs to be secured first!"))
					return
				if(!user.transferItemToLoc(board, src))
					return
				playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
				to_chat(user, span_notice("You add the circuit board to the frame."))
				circuit = board
				icon_state = "box_2"
				state = 3
				components = list()
				req_components = board.req_components.Copy()
				update_namelist(board.specific_parts)
				return

			else if(istype(P, /obj/item/circuitboard))
				to_chat(user, span_warning("This frame does not accept circuit boards of this type!"))
				return

			if(P.tool_behaviour == TOOL_WIRECUTTER)
				P.play_tool_sound(src)
				to_chat(user, span_notice("You remove the cables."))
				state = 1
				icon_state = "box_0"
				new /obj/item/stack/cable_coil(drop_location(), 5)
				return

		if(3)
			if(P.tool_behaviour == TOOL_CROWBAR)
				P.play_tool_sound(src)
				state = 2
				circuit.forceMove(drop_location())
				components.Remove(circuit)
				circuit = null
				if(components.len == 0)
					to_chat(user, span_notice("You remove the circuit board."))
				else
					to_chat(user, span_notice("You remove the circuit board and other components."))
					for(var/atom/movable/AM in components)
						AM.forceMove(drop_location())
				desc = initial(desc)
				req_components = null
				components = null
				icon_state = "box_1"
				return

			if(P.tool_behaviour == TOOL_WRENCH && !circuit.needs_anchored)
				to_chat(user, span_notice("You start [anchored ? "un" : ""]securing [src]..."))
				if(P.use_tool(src, user, 40, volume=75))
					to_chat(user, span_notice("You [anchored ? "un" : ""]secure [src]."))
					set_anchored(!anchored)
				return

			if(P.tool_behaviour == TOOL_SCREWDRIVER)
				var/component_check = TRUE
				for(var/R in req_components)
					if(req_components[R] > 0)
						component_check = FALSE
						break
				if(component_check)
					P.play_tool_sound(src)
					var/obj/machinery/new_machine = new circuit.build_path(loc)
					if(istype(new_machine))
						// Machines will init with a set of default components. Move to nullspace so we don't trigger handle_atom_del, then qdel.
						// Finally, replace with this frame's parts.
						if(new_machine.circuit)
							// Move to nullspace and delete.
							new_machine.circuit.moveToNullspace()
							QDEL_NULL(new_machine.circuit)
						for(var/obj/old_part in new_machine.component_parts)
							// Move to nullspace and delete.
							old_part.moveToNullspace()
							qdel(old_part)

						// Set anchor state and move the frame's parts over to the new machine.
						// Then refresh parts and call on_construction().

						new_machine.set_anchored(anchored)
						new_machine.component_parts = list()

						circuit.forceMove(new_machine)
						new_machine.component_parts += circuit
						new_machine.circuit = circuit

						for(var/obj/new_part in src)
							new_part.forceMove(new_machine)
							new_machine.component_parts += new_part
						new_machine.RefreshParts()

						new_machine.on_construction()
					qdel(src)
				return

			if(istype(P, /obj/item/storage/part_replacer) && P.contents.len && get_req_components_amt())
				var/obj/item/storage/part_replacer/replacer = P
				var/list/added_components = list()
				var/list/part_list = list()

				//Assemble a list of current parts, then sort them by their rating!
				for(var/obj/item/co in replacer)
					part_list += co
				//Sort the parts. This ensures that higher tier items are applied first.
				part_list = sortTim(part_list, GLOBAL_PROC_REF(cmp_rped_sort))

				for(var/path in req_components)
					while(req_components[path] > 0 && (locate(path) in part_list))
						var/obj/item/part = (locate(path) in part_list)
						part_list -= part
						if(istype(part,/obj/item/stack))
							var/obj/item/stack/S = part
							var/used_amt = min(round(S.get_amount()), req_components[path])
							if(!used_amt || !S.use(used_amt))
								continue
							var/NS = new S.merge_type(src, used_amt)
							added_components[NS] = path
							req_components[path] -= used_amt
						else
							added_components[part] = path
							if(replacer.atom_storage.attempt_remove(part, src))
								req_components[path]--

				for(var/obj/item/part in added_components)
					if(istype(part,/obj/item/stack))
						var/obj/item/stack/incoming_stack = part
						for(var/obj/item/stack/merge_stack in components)
							if(incoming_stack.can_merge(merge_stack))
								incoming_stack.merge(merge_stack)
								if(QDELETED(incoming_stack))
									break
					if(!QDELETED(part)) //If we're a stack and we merged we might not exist anymore
						components += part
						part.forceMove(src)
					to_chat(user, span_notice("You add [part] to [src]."))
				if(added_components.len)
					replacer.play_rped_sound()
				return

			if(isitem(P) && get_req_components_amt())
				for(var/I in req_components)
					if(istype(P, I) && (req_components[I] > 0))
						if(isstack(P))
							var/obj/item/stack/S = P
							var/used_amt = min(round(S.get_amount()), req_components[I])

							if(used_amt && S.use(used_amt))
								var/obj/item/stack/NS = locate(S.merge_type) in components

								if(!NS)
									NS = new S.merge_type(src, used_amt)
									components += NS
								else
									NS.add(used_amt)

								req_components[I] -= used_amt
								to_chat(user, span_notice("You add [P] to [src]."))
							return
						if(!user.transferItemToLoc(P, src))
							break
						to_chat(user, span_notice("You add [P] to [src]."))
						components += P
						req_components[I]--
						return TRUE
				to_chat(user, span_warning("You cannot add that to the machine!"))
				return FALSE
	if(user.combat_mode)
		return ..()

/obj/structure/frame/machine/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(state >= 2)
			new /obj/item/stack/cable_coil(loc , 5)
		for(var/X in components)
			var/obj/item/I = X
			I.forceMove(loc)
	..()