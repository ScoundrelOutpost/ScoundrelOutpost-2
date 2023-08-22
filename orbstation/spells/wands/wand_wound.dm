/**
 * Medbay enrichment, directly applies wounds or just damage to wound-proof limbs
 */
/obj/item/gun/magic/wand/wound
	name = "wand of wounding"
	desc = "The dark power of this wand manifests terrible wounds upon the living."
	school = SCHOOL_NECROMANCY
	ammo_type = /obj/item/ammo_casing/magic/wound
	icon_state = "deathwand"
	base_icon_state = "deathwand"
	fire_sound = 'sound/magic/wandodeath.ogg'
	max_charges = 5

/obj/item/gun/magic/wand/wound/zap_self(mob/living/user)
	. = ..()
	to_chat(user, span_boldwarning("You magically rend your own flesh!"))
	var/obj/item/bodypart/head/numbskull = user.get_bodypart(BODY_ZONE_HEAD)
	if (IS_ORGANIC_LIMB(numbskull))
		var/type_wound = pick(list(/datum/wound/blunt/critical, /datum/wound/slash/critical,
			/datum/wound/pierce/critical, /datum/wound/burn/critical,))
		numbskull.force_wound_upwards(type_wound)
	else
		numbskull.receive_damage(brute = 30)
	charges--

/obj/item/ammo_casing/magic/wound
	projectile_type = /obj/projectile/magic/wound

/obj/projectile/magic/wound
	name = "bolt of wounding"
	icon_state = "soulslash"
	damage = 15
	damage_type = BRUTE
	nodamage = FALSE
	/// Weighted list of inflicted wounds
	var/static/list/wound_effects = list(
		/datum/wound/blunt/critical = 1, /datum/wound/blunt/severe = 3,
		/datum/wound/slash/critical = 1, /datum/wound/slash/severe = 3,
		/datum/wound/pierce/critical = 1, /datum/wound/pierce/severe = 3,
		/datum/wound/burn/critical = 1, /datum/wound/burn/severe = 3,
	)

/obj/projectile/magic/wound/on_hit(atom/target)
	var/mob/living/carbon/victim = target
	if (!istype(victim))
		return
	var/obj/item/bodypart/wound_part = pick(victim.bodyparts)
	if (IS_ORGANIC_LIMB(wound_part))
		var/type_wound = pick_weight(wound_effects)
		wound_part.force_wound_upwards(type_wound)
	else
		wound_part.receive_damage(brute = 30)
