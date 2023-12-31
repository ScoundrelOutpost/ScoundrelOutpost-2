// .50 (Sniper)

/obj/item/ammo_casing/p50
	name = ".50 bullet casing"
	desc = "A .50 bullet casing."
	caliber = CALIBER_50
	projectile_type = /obj/projectile/bullet/p50
	icon_state = ".50"

/obj/item/ammo_casing/p50/soporific
	name = ".50 soporific bullet casing"
	desc = "A .50 bullet casing, specialised in sending the target to sleep, instead of hell."
	projectile_type = /obj/projectile/bullet/p50/soporific
	icon_state = "sleeper"
	harmful = FALSE

/obj/item/ammo_casing/p50/penetrator
	name = ".50 penetrator round bullet casing"
	desc = "A .50 caliber penetrator round casing."
	projectile_type = /obj/projectile/bullet/p50/penetrator

/obj/item/ammo_casing/p50/marksman
	name = ".50 marksman round bullet casing"
	desc = "A .50 caliber marksman round casing."
	projectile_type = /obj/projectile/bullet/p50/marksman

// scoundrel content
/obj/item/ammo_casing/p50/surplus
	name = "surplus .50 bullet casing"
	desc = "A surplus .50 bullet casing."
	projectile_type = /obj/projectile/bullet/p50/surplus
