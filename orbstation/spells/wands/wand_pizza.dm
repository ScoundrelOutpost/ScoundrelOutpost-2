/**
 * Turns things you hit into pizza.
 */
/obj/item/gun/magic/wand/pizza
	name = "wand of snacking"
	desc = "The incredible power of this wand transforms certain objects and surfaces into edible pizza."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/pizza
	icon_state = "polywand"
	base_icon_state = "polywand"
	fire_sound = 'sound/magic/staff_change.ogg'
	max_charges = 20

/obj/item/gun/magic/wand/pizza/zap_self(mob/living/user)
	to_chat(user, span_notice("You can't bring yourself to commit to a permanent transformation into pizza right now."))
	return

/obj/item/gun/magic/wand/pizza/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] presses the [src] into their chest! \
		It looks like [user.p_theyre()] trying to turn themselves into pizza!"))
	if (charges == 0)
		user.visible_message(span_suicide("[src] makes a pathetic whizzing noise and nothing else happens."))
		return SHAME

	charges = 0
	var/turf/user_loc = get_turf(user)
	new /obj/effect/particle_effect/fluid/smoke(user_loc)
	new /obj/item/food/pizzaslice/margherita(user_loc)
	qdel(user)
	return MANUAL_SUICIDE

/obj/item/ammo_casing/magic/pizza
	projectile_type = /obj/projectile/magic/pizza
	harmful = FALSE

/obj/projectile/magic/pizza
	name = "bolt of snacking"
	icon = 'icons/obj/food/pizza.dmi'
	icon_state = "pizzamargherita"

/obj/projectile/magic/pizza/on_hit(atom/target)
	var/turf/hit_turf = get_turf(target)
	var/datum/dimension_theme/pizza/converter = new()
	if(!converter.can_convert(hit_turf))
		return
	converter.apply_theme(hit_turf)
