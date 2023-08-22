#define STRONG_PUNCH_COMBO "HH"
#define LAUNCH_KICK_COMBO "HD"
#define DROP_KICK_COMBO "HG"

/datum/martial_art/the_sleeping_carp
	name = "The Sleeping Carp"
	id = MARTIALART_SLEEPINGCARP
	allow_temp_override = FALSE
	help_verb = /mob/living/proc/sleeping_carp_help
	display_combos = TRUE

/datum/martial_art/the_sleeping_carp/teach(mob/living/target, make_temporary = FALSE)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(target, TRAIT_NOGUNS, SLEEPING_CARP_TRAIT)
	ADD_TRAIT(target, TRAIT_HARDLY_WOUNDED, SLEEPING_CARP_TRAIT)
	ADD_TRAIT(target, TRAIT_NODISMEMBER, SLEEPING_CARP_TRAIT)
	RegisterSignal(target, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	target.faction |= "carp" //:D

/datum/martial_art/the_sleeping_carp/on_remove(mob/living/target)
	REMOVE_TRAIT(target, TRAIT_NOGUNS, SLEEPING_CARP_TRAIT)
	REMOVE_TRAIT(target, TRAIT_HARDLY_WOUNDED, SLEEPING_CARP_TRAIT)
	REMOVE_TRAIT(target, TRAIT_NODISMEMBER, SLEEPING_CARP_TRAIT)
	UnregisterSignal(target, COMSIG_PARENT_ATTACKBY)
	target.faction -= "carp" //:(
	. = ..()

/datum/martial_art/the_sleeping_carp/proc/check_streak(mob/living/A, mob/living/D)
	if(findtext(streak,STRONG_PUNCH_COMBO))
		reset_streak()
		strongPunch(A,D)
		return TRUE
	if(findtext(streak,LAUNCH_KICK_COMBO))
		reset_streak()
		launchKick(A,D)
		return TRUE
	if(findtext(streak,DROP_KICK_COMBO))
		reset_streak()
		dropKick(A,D)
		return TRUE
	return FALSE

///Gnashing Teeth: Harm Harm, consistent 20 force punch on every second harm punch
/datum/martial_art/the_sleeping_carp/proc/strongPunch(mob/living/A, mob/living/D)
	///this var is so that the strong punch is always aiming for the body part the user is targeting and not trying to apply to the chest before deviating
	var/obj/item/bodypart/affecting = D.get_bodypart(D.get_random_valid_zone(A.zone_selected))
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("precisely kick", "brutally chop", "cleanly hit", "viciously slam")
	D.visible_message(span_danger("[A] [atk_verb]s [D]!"), \
					span_userdanger("[A] [atk_verb]s you!"), null, null, A)
	to_chat(A, span_danger("You [atk_verb] [D]!"))
	playsound(get_turf(D), 'sound/weapons/bite.ogg', 100, TRUE, -1)
	log_combat(A, D, "strong punched (Sleeping Carp)")
	D.apply_damage(22, A.get_attack_type(), affecting)
	return

///Crashing Wave Kick: Punch Shove combo, throws people seven tiles backwards
/datum/martial_art/the_sleeping_carp/proc/launchKick(mob/living/A, mob/living/D)
	A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	D.visible_message(span_warning("[A] kicks [D] square in the chest, sending them flying!"), \
					span_userdanger("You are kicked square in the chest by [A], sending you flying!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(D, A.dir)
	var/obj/item/stuff_in_hand = null
	stuff_in_hand = D.get_active_held_item()
	if(stuff_in_hand)
		if(D.temporarilyRemoveItemFromInventory(stuff_in_hand))
			A.put_in_hands(stuff_in_hand)
			D.visible_message("<span class='danger'>[A] snatches [stuff_in_hand] out of the air as it leaves [D]'s hand!</span>", \
				"<span class='userdanger'>[A] snatches [stuff_in_hand] out of the air!</span>", "<span class='hear'>You hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, A)
			to_chat(A, "<span class='danger'>You expertly catch [stuff_in_hand] as it leaves [D]'s hand.</span>")
	D.Paralyze(0.2 SECONDS)
	D.throw_at(throw_target, 7, 2, A)
	D.apply_damage(10, A.get_attack_type(), BODY_ZONE_CHEST, wound_bonus = CANT_WOUND)
	log_combat(A, D, "launchkicked (Sleeping Carp)")
	return

///Keelhaul: Harm Grab combo, knocks people down, deals stamina damage while they're on the floor
/datum/martial_art/the_sleeping_carp/proc/dropKick(mob/living/A, mob/living/D)
	A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	if(D.body_position == STANDING_UP)
		D.apply_damage(6, A.get_attack_type(), BODY_ZONE_HEAD, wound_bonus = CANT_WOUND)
		D.apply_damage(12, STAMINA, BODY_ZONE_HEAD)
		D.Knockdown(1)
		D.visible_message(span_warning("[A] kicks [D] in the head, sending them face first into the floor!"), \
					span_userdanger("You are kicked in the head by [A], sending you crashing to the floor!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	else
		D.apply_damage(6, A.get_attack_type(), BODY_ZONE_HEAD, wound_bonus = CANT_WOUND)
		D.apply_damage(12, STAMINA, BODY_ZONE_HEAD)
		D.drop_all_held_items()
		D.visible_message(span_warning("[A] kicks [D] in the head!"), \
					span_userdanger("You are kicked in the head by [A]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	log_combat(A, D, "dropkicked (Sleeping Carp)")
	return

/datum/martial_art/the_sleeping_carp/grab_act(mob/living/A, mob/living/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "grabbed (Sleeping Carp)")
	return ..()

/datum/martial_art/the_sleeping_carp/harm_act(mob/living/A, mob/living/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	var/obj/item/bodypart/affecting = D.get_bodypart(D.get_random_valid_zone(A.zone_selected))
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("kick", "chop", "hit", "slam")
	D.visible_message(span_danger("[A] [atk_verb]s [D]!"), \
					span_userdanger("[A] [atk_verb]s you!"), null, null, A)
	to_chat(A, span_danger("You [atk_verb] [D]!"))
	D.apply_damage(rand(8,12), BRUTE, affecting, wound_bonus = CANT_WOUND)
	playsound(get_turf(D), 'sound/scoundrel/weapons/punch3.ogg', 25, TRUE, -1)
	log_combat(A, D, "punched (Sleeping Carp)")
	return TRUE

/datum/martial_art/the_sleeping_carp/disarm_act(mob/living/A, mob/living/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return TRUE
	// this chunk of code is taken from krav maga
	var/obj/item/gun/stuff_in_hand = null // only looks for guns
	stuff_in_hand = D.get_active_held_item()
	if(stuff_in_hand && istype(stuff_in_hand, /obj/item/gun))
		if(D.temporarilyRemoveItemFromInventory(stuff_in_hand))
			A.put_in_hands(stuff_in_hand)
			D.visible_message("<span class='danger'>[A] disarms [D]!</span>", \
				"<span class='userdanger'>You're disarmed by [A]!</span>", "<span class='hear'>You hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, A)
			to_chat(A, "<span class='danger'>You disarm [D]!</span>")
			playsound(D, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	log_combat(A, D, "disarmed (Sleeping Carp)", "[stuff_in_hand ? " removing \the [stuff_in_hand]" : ""]")
	return ..()

/datum/martial_art/the_sleeping_carp/proc/can_deflect(mob/living/carp_user)
	if(carp_user.incapacitated(IGNORE_GRAB)) //NO STUN
		return FALSE
	if(!(carp_user.mobility_flags & MOBILITY_USE)) //NO UNABLE TO USE
		return FALSE
	var/datum/dna/dna = carp_user.has_dna()
	if(dna?.check_mutation(/datum/mutation/human/hulk)) //NO HULK
		return FALSE
	if(!isturf(carp_user.loc)) //NO MOTHERFLIPPIN MECHS!
		return FALSE
	return TRUE

/datum/martial_art/the_sleeping_carp/on_projectile_hit(mob/living/carp_user, obj/projectile/P, def_zone)
	. = ..()
	if(!can_deflect(carp_user))
		return BULLET_ACT_HIT
	if(carp_user.throw_mode)
		carp_user.visible_message(span_danger("[carp_user] effortlessly swats the projectile aside! They can block bullets with their bare hands!"), span_userdanger("You deflect the projectile!"))
		playsound(get_turf(carp_user), pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, TRUE)
		P.firer = carp_user
		P.set_angle(rand(0, 360))//SHING
		return BULLET_ACT_FORCE_PIERCE
	return BULLET_ACT_HIT

///Signal from getting attacked with an item, for a special interaction with touch spells
/datum/martial_art/the_sleeping_carp/proc/on_attackby(mob/living/carp_user, obj/item/attack_weapon, mob/attacker, params)
	SIGNAL_HANDLER

	if(!istype(attack_weapon, /obj/item/melee/touch_attack))
		return
	if(!can_deflect(carp_user))
		return
	var/obj/item/melee/touch_attack/touch_weapon = attack_weapon
	carp_user.visible_message(
		span_danger("[carp_user] carefully dodges [attacker]'s [touch_weapon]!"),
		span_userdanger("You take great care to remain untouched by [attacker]'s [touch_weapon]!"),
	)
	return COMPONENT_NO_AFTERATTACK

/// Verb added to humans who learn the art of the sleeping carp.
/mob/living/proc/sleeping_carp_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Sleeping Carp clan."
	set category = "Sleeping Carp"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Sleeping Carp...</i></b>\n\
	[span_notice("Gnashing Teeth")]: Punch Punch. Unleash primal fury, dealing critical damage!\n\
	[span_notice("Crashing Wave Kick")]: Punch Shove. Launch your opponent away from you with incredible force, and snatch whatever they were holding!\n\
	[span_notice("Keelhaul")]: Punch Grab. Kick an opponent to the floor, knocking them down!\n\
	While in throw mode, you can deflect projectiles shot from guns! \
	\n\
	Additionally, your body has been hardened against wound statuses. This does not effect the raw damage you take. \
	\n\
	[span_notice("Simply shoving someone while they're holding a firearm will attempt to snatch it out of their hand!")]")


/obj/item/staff/bostaff
	name = "bo staff"
	desc = "A long, tall staff made of polished wood. Traditionally used in ancient old-Earth martial arts. Can be wielded to both kill and incapacitate."
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throwforce = 20
	throw_speed = 2
	attack_verb_continuous = list("smashes", "slams", "whacks", "thwacks")
	attack_verb_simple = list("smash", "slam", "whack", "thwack")
	icon = 'icons/obj/weapons/items_and_weapons.dmi'
	icon_state = "bostaff0"
	base_icon_state = "bostaff"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	block_chance = 50

/obj/item/staff/bostaff/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_unwielded = 10, \
		force_wielded = 24, \
		icon_wielded = "[base_icon_state]1", \
	)

/obj/item/staff/bostaff/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/staff/bostaff/attack(mob/target, mob/living/user, params)
	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, span_warning("You club yourself over the head with [src]."))
		user.Paralyze(60)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		return ..()
	if(!isliving(target))
		return ..()
	var/mob/living/carbon/C = target
	if(C.stat)
		to_chat(user, span_warning("It would be dishonorable to attack a foe while they cannot retaliate."))
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(!HAS_TRAIT(src, TRAIT_WIELDED))
			return ..()
		if(!ishuman(target))
			return ..()
		var/mob/living/carbon/human/H = target
		var/list/fluffmessages = list("club", "smack", "broadside", "beat", "slam")
		H.visible_message(span_warning("[user] [pick(fluffmessages)]s [H] with [src]!"), \
						span_userdanger("[user] [pick(fluffmessages)]s you with [src]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, user)
		to_chat(user, span_danger("You [pick(fluffmessages)] [H] with [src]!"))
		playsound(get_turf(user), 'sound/effects/woodhit.ogg', 75, TRUE, -1)
		H.adjustStaminaLoss(rand(13,20))
		if(prob(10))
			H.visible_message(span_warning("[H] collapses!"), \
							span_userdanger("Your legs give out!"))
			H.Paralyze(80)
		if(H.staminaloss && !H.IsSleeping())
			var/total_health = (H.health - H.staminaloss)
			if(total_health <= HEALTH_THRESHOLD_CRIT && !H.stat)
				H.visible_message(span_warning("[user] delivers a heavy hit to [H]'s head, knocking [H.p_them()] out cold!"), \
								span_userdanger("You're knocked unconscious by [user]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, user)
				to_chat(user, span_danger("You deliver a heavy hit to [H]'s head, knocking [H.p_them()] out cold!"))
				H.SetSleeping(600)
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 150)
	else
		return ..()

/obj/item/staff/bostaff/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		return ..()
	return FALSE