/**
 * Pax wand is a minor heal which applies temporary pacifism, gives you time to talk it out?
 */
/obj/item/gun/magic/wand/pax
	name = "rod of compassion"
	desc = "A wand which supernaturally connects victim and target, which renders both unable to fight and makes them feel a little better."
	school = SCHOOL_RESTORATION
	ammo_type = /obj/item/ammo_casing/magic/pax
	icon_state = "revivewand"
	base_icon_state = "revivewand"
	fire_sound = 'sound/effects/kiss.ogg'
	max_charges = 12

/obj/item/gun/magic/wand/pax/fire_gun(atom/target, mob/living/user, flag, params)
	. = ..()
	if (!.)
		return
	user.apply_status_effect(/datum/status_effect/pacify/visible, 30 SECONDS) // Don't miss!
	user.adjustBruteLoss(-30)

/obj/item/gun/magic/wand/pax/zap_self(mob/living/user)
	playsound(user, fire_sound, 50, TRUE)
	user.log_message("zapped [user.p_them()]self with a <b>[src]</b>", LOG_ATTACK)
	user.visible_message(span_notice("[user] tenderly kisses [user.p_their()] own wand."))
	charges--

/obj/item/ammo_casing/magic/pax
	projectile_type = /obj/projectile/magic/pax
	harmful = FALSE

/obj/projectile/magic/pax
	name = "bolt of compassion"
	icon = 'icons/mob/simple/animal.dmi'
	icon_state = "heart"

/obj/projectile/magic/pax/on_hit(atom/target)
	. = ..()
	var/mob/living/victim = target
	if (!istype(victim))
		return

	victim.apply_status_effect(/datum/status_effect/pacify/visible, 30 SECONDS)
	victim.adjustBruteLoss(-30)

// Default pacify status effect has no screen alert but I think this should have one
/datum/status_effect/pacify/visible
	alert_type = /atom/movable/screen/alert/status_effect/pacified

/datum/status_effect/pacify/visible/on_apply()
	if (!HAS_TRAIT(owner, TRAIT_PACIFISM))
		owner.visible_message(span_notice("[owner] seems to relax."), span_notice("You feel your muscles loosen and your will to fight melt away."))
	return ..()

/datum/status_effect/pacify/visible/on_remove()
	. = ..()
	// Might have it from somewhere else
	if (HAS_TRAIT(owner, TRAIT_PACIFISM))
		return
	owner.visible_message(span_warning("[owner] suddenly tenses up."), span_notice("You suddenly remember that violence is an option."))

/atom/movable/screen/alert/status_effect/pacified
	name = "Pacified"
	desc = "You find yourself temporarily incapable of violence."
	icon_state = "in_love"
