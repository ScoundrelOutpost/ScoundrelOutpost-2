/**
 * Levitation wand applies anti-gravity to target.
 */
/obj/item/gun/magic/wand/levitate
	name = "lifting rod"
	desc = "The power of this rod lifts living creatures off the ground, potentially leaving them unable to move."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/levitate
	icon_state = "telewand"
	base_icon_state = "telewand"
	fire_sound = 'sound/magic/repulse.ogg'
	max_charges = 12

/obj/item/gun/magic/wand/levitate/zap_self(mob/living/user)
	. = ..()
	user.apply_status_effect(/datum/status_effect/levitate)

/obj/item/ammo_casing/magic/levitate
	projectile_type = /obj/projectile/magic/levitate
	harmful = FALSE

/obj/projectile/magic/levitate
	name = "bolt of levitation"
	icon_state = "bluespace"

/obj/projectile/magic/levitate/on_hit(atom/target)
	. = ..()
	var/mob/living/victim = target
	if (!istype(victim))
		return
	victim.apply_status_effect(/datum/status_effect/levitate)

/datum/status_effect/levitate
	id = "levitated"
	status_type = STATUS_EFFECT_REPLACE
	duration = 2 MINUTES
	alert_type = null

/datum/status_effect/levitate/on_apply()
	owner.visible_message(span_warning("[owner] floats into the air!"))
	owner.AddElement(/datum/element/forced_gravity, 0)
	owner.add_filter("antigrav_glow", 2, list("type" = "outline", "color" = "#de3aff48", "size" = 2))
	return ..()

/datum/status_effect/levitate/on_remove()
	owner.visible_message(span_notice("[owner] gently descends to the ground"))
	owner.RemoveElement(/datum/element/forced_gravity, 0)
	owner.remove_filter("antigrav_glow")
	return ..()
