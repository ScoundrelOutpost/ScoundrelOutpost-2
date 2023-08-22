///Defines for the pressure strength of the fist
#define LOW_PRESSURE 1
#define MID_PRESSURE 2
#define HIGH_PRESSURE 3
///Defines for the tank change action
#define TANK_INSERTING 0
#define TANK_REMOVING 1

/obj/item/melee/powerfist
	name = "power-fist"
	desc = "A metal gauntlet with a piston-powered ram ontop for that extra 'ompfh' in your punch."
	icon_state = "powerfist"
	inhand_icon_state = "powerfist"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	flags_1 = CONDUCT_1
	attack_verb_continuous = list("mauls", "smashes")
	attack_verb_simple = list("maul", "smash")
	force = 12 // 12 + (3 * 3) for max damage
	throwforce = 10
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 100, ACID = 40)
	resistance_flags = FIRE_PROOF
	/// Delay between attacks
	var/click_delay = 0.15 SECONDS
	/// Pressure level on the fist
	var/fist_pressure_setting = LOW_PRESSURE
	/// Amount of moles per punch
	var/gas_per_fist = 3
	/// Tank used for the gauntlet's piston-ram.
	var/obj/item/tank/internals/tank

/obj/item/melee/powerfist/examine(mob/user)
	. = ..()
	if(!in_range(user, src))
		. += span_notice("You'll need to get closer to see any more.")
		return
	if(tank)
		. += span_notice("[icon2html(tank, user)] It has \a [tank] mounted onto it.")
		. += span_notice("Can be removed with a screwdriver.")

	. += span_notice("Use a wrench to change the valve strength. Current strength at [fist_pressure_setting].")

/obj/item/melee/powerfist/wrench_act(mob/living/user, obj/item/tool)
	fist_pressure_setting = fist_pressure_setting >= HIGH_PRESSURE ? LOW_PRESSURE : fist_pressure_setting + 1
	tool.play_tool_sound(src)
	balloon_alert(user, "piston strength set to [fist_pressure_setting]")
	return TRUE

/obj/item/melee/powerfist/screwdriver_act(mob/living/user, obj/item/tool)
	if(!tank)
		balloon_alert(user, "no tank present")
		return
	update_tank(tank, TANK_REMOVING, user)
	return TRUE

/obj/item/melee/powerfist/attackby(obj/item/item_to_insert, mob/user, params)
	if(!istype(item_to_insert, /obj/item/tank/internals))
		return ..()
	if(tank)
		to_chat(user, span_notice("A tank is already present, remove it with a screwdriver first."))
		return
	var/obj/item/tank/internals/tank_to_insert = item_to_insert
	if(tank_to_insert.volume <= 3)
		to_chat(user, span_warning("\The [tank_to_insert] is too small for \the [src]."))
		return
	update_tank(item_to_insert, TANK_INSERTING, user)

/obj/item/melee/powerfist/proc/update_tank(obj/item/tank/internals/the_tank, removing = TANK_INSERTING, mob/living/carbon/human/user)
	if(removing)
		if(!tank)
			to_chat(user, span_notice("\The [src] currently has no tank attached to it."))
			return
		to_chat(user, span_notice("You detach \the [the_tank] from \the [src]."))
		tank.forceMove(get_turf(user))
		user.put_in_hands(tank)
		tank = null
		return

	if(tank)
		to_chat(user, span_warning("\The [src] already has a tank."))
		return
	if(!user.transferItemToLoc(the_tank, src))
		return
	to_chat(user, span_notice("You hook \the [the_tank] up to \the [src]."))
	tank = the_tank

/obj/item/melee/powerfist/attack(mob/living/target, mob/living/user)
	var/hitsound_basic = 'sound/weapons/smash.ogg'
	if(!tank)
		to_chat(user, span_warning("\The [src] can't operate without a source of gas!"))
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to harm other living beings!"))
		return
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return

	user.do_attack_animation(target)
	var/datum/gas_mixture/gas_used = tank.remove_air(gas_per_fist * fist_pressure_setting)
	if(!gas_used)
		to_chat(user, span_warning("\The [src]'s tank is empty!"))
		target.apply_damage((force), BRUTE)
		playsound(loc, hitsound_basic, 50, TRUE)
		target.visible_message(span_danger("[user]'s powerfist lets out a dull thunk as [user.p_they()] punch[user.p_es()] [target.name]!"), \
			span_userdanger("[user] [pick(attack_verb_continuous)] you with [src]!"))
		return

	if(!molar_cmp_equals(gas_used.total_moles(), gas_per_fist * fist_pressure_setting))
		our_turf.assume_air(gas_used)
		to_chat(user, span_warning("\The [src]'s piston-ram lets out a weak hiss, it needs more gas!"))
		playsound(loc, hitsound_basic, 50, TRUE)
		target.apply_damage((force), BRUTE)
		target.visible_message(span_danger("[user]'s powerfist lets out a weak hiss as [user.p_they()] punch[user.p_es()] [target.name]!"), \
			span_userdanger("[user]'s punch strikes with force!"))
		return

	target.visible_message(span_danger("[user]'s powerfist lets out a loud hiss as [user.p_they()] punch[user.p_es()] [target.name]!"), \
		span_userdanger("You cry out in pain as [user]'s punch flings you backwards!"))
	new /obj/effect/temp_visual/kinetic_blast(target.loc)
	target.apply_damage(force + (fist_pressure_setting * 3), BRUTE, wound_bonus = CANT_WOUND)
	playsound(src, 'sound/weapons/resonator_blast.ogg', 50, TRUE)
	playsound(src, hitsound_basic, 50, TRUE)

	if(!QDELETED(target))
		var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))

		target.throw_at(throw_target, 5 * fist_pressure_setting, 0.5 + (fist_pressure_setting / 2))

	log_combat(user, target, "power fisted", src)

	user.changeNext_move(CLICK_CD_MELEE * click_delay)

	our_turf.assume_air(gas_used)

#undef LOW_PRESSURE
#undef MID_PRESSURE
#undef HIGH_PRESSURE
#undef TANK_INSERTING
#undef TANK_REMOVING
