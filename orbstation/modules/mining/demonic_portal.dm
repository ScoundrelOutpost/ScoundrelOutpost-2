// Remove the bullshit entries which just spawn soft drinks or things which kill you
// Did you know the demonic portal couldn't drop the powerminer??? awful
/obj/effect/collapsing_demonic_portal/drop_loot()
	visible_message(span_warning("Something slips out of [src]!"))
	var/loot = rand(1, 28)
	switch(loot)
		if(1)
			new /obj/item/clothing/suit/hooded/cultrobes/hardened(loc)
		if(2)
			new /obj/item/clothing/glasses/godeye(loc)
		if(3)
			new /obj/item/reagent_containers/cup/bottle/potion/flight(loc)
		if(4)
			new /obj/item/organ/internal/heart/cursed/wizard(loc)
		if(5)
			new /obj/item/jacobs_ladder(loc)
		if(6)
			new /obj/item/rod_of_asclepius(loc)
		if(7)
			new /obj/item/warp_cube/red(loc)
		if(8)
			new /obj/item/wisp_lantern(loc)
		if(9)
			new /obj/item/immortality_talisman(loc)
		if(10)
			new /obj/item/book/granter/action/spell/summonitem(loc)
		if(11)
			new /obj/item/clothing/neck/necklace/memento_mori(loc)
		if(12)
			new /obj/item/borg/upgrade/modkit/lifesteal(loc)
			new /obj/item/bedsheet/cult(loc)
		if(13)
			new /obj/item/disk/design_disk/modkit_disc/mob_and_turf_aoe(loc)
		if(14)
			new /obj/item/disk/design_disk/modkit_disc/bounty(loc)
		if(15)
			new /obj/item/slimepotion/slime/sentience(loc)
		if(16)
			new /obj/item/shared_storage/red(loc)
		if(17)
			new /obj/item/organ/internal/cyberimp/arm/katana(loc)
		if(18)
			new /obj/item/soulstone/anybody(loc)
		if(19)
			new /obj/item/disk/design_disk/modkit_disc/resonator_blast(loc)
		if(20)
			new /obj/item/disk/design_disk/modkit_disc/rapid_repeater(loc)
		if(21)
			new /obj/item/slimepotion/transference(loc)
		if(22)
			new /obj/item/slime_extract/adamantine(loc)
		if(23)
			new /obj/item/weldingtool/abductor(loc)
		if(24)
			new /obj/item/book_of_babel(loc)
		if(25)
			new /obj/item/guardiancreator/miner(loc)
		if(26)
			new /obj/item/clothing/shoes/winterboots/ice_boots(loc)
		if(27)
			new /obj/item/book/granter/action/spell/sacredflame(loc)
		if(28)
			var/static/list/funny_wands = list(
				/obj/item/gun/magic/wand/teleport,
				/obj/item/gun/magic/wand/zap,
				/obj/item/gun/magic/wand/freeze,
				/obj/item/gun/magic/wand/prank,
				/obj/item/gun/magic/wand/hallucination,
				/obj/item/gun/magic/wand/pax,
				/obj/item/gun/magic/wand/repulse,
				/obj/item/gun/magic/wand/teleport_rune,
				/obj/item/gun/magic/wand/swap,
				/obj/item/gun/magic/wand/pizza,
				/obj/item/gun/magic/wand/babel,)
			var/picked_type = pick(funny_wands)
			new picked_type(loc)