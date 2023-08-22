/**
 * Swaps you with something you hit.
 */
/obj/item/gun/magic/wand/swap
	name = "switching rod"
	desc = "Exchanges the position of the wielder and an unanchored object they point at."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/swap
	icon_state = "telewand"
	base_icon_state = "telewand"
	fire_sound = 'sound/magic/swap.ogg'
	max_charges = 20

/obj/item/gun/magic/wand/swap/zap_self(mob/living/user)
	. = ..()
	to_chat(user, span_notice("You swap places with yourself! Amazing!"))
	var/obj/effect/particle_effect/fluid/smoke/poof_in = new (get_turf(user))
	poof_in.lifetime = 3
	charges--

/obj/item/ammo_casing/magic/swap
	projectile_type = /obj/projectile/magic/swap
	harmful = FALSE

/obj/projectile/magic/swap
	name = "bolt of switching"
	icon_state = "magicm"
	projectile_phasing = PASSTABLE | PASSGLASS | PASSGRILLE

/obj/projectile/magic/swap/on_hit(atom/target)
	var/atom/movable/hit_target = target
	if (!istype(hit_target))
		return
	if (hit_target.anchored)
		return
	if (!firer)
		return
	var/turf/my_turf = get_turf(firer)
	var/turf/your_turf = get_turf(hit_target)

	do_teleport(firer, your_turf, asoundin = 'sound/magic/swap.ogg', channel = TELEPORT_CHANNEL_MAGIC)
	do_teleport(hit_target, my_turf, asoundin = 'sound/magic/swap.ogg', channel = TELEPORT_CHANNEL_MAGIC)
	var/obj/effect/particle_effect/fluid/smoke/poof_in = new (my_turf)
	poof_in.lifetime = 3
	var/obj/effect/particle_effect/fluid/smoke/poof_out = new (your_turf)
	poof_out.lifetime = 3
