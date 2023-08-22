/*
	Orbstation Department Assistants
*/

/// Abstract datum for holding the rest of the assistant departments
/datum/job/assistant/dept
	title = "Abstract Departmental Assistant"
	job_flags = 0 //should not be used in any capacity in-game
	config_tag = "DEPT_ASSISTANT"

// Override of the proc that determines where these jobs spawn, just to use the normal assistant spawns
/datum/job/assistant/dept/get_default_roundstart_spawn_point()
	for(var/obj/effect/landmark/start/spawn_point as anything in GLOB.start_landmarks_list)
		if(spawn_point.name != JOB_ASSISTANT)
			continue
		. = spawn_point
		if(spawn_point.used) //so we can revert to spawning them on top of eachother if something goes wrong
			continue
		spawn_point.used = TRUE
		break
	if(!.)
		log_world("Couldn't find a round start spawn point for [title]")

/// Abstract datum for assistant departments
/datum/outfit/job/assistant/dept
	name = "Abstract Departmental Assistant"
	var/skirt = null

/datum/outfit/job/assistant/dept/give_jumpsuit(mob/living/carbon/human/target)
	// gives you a jumpskirt based on your preferences if possible
	if(target.jumpsuit_style == PREF_SKIRT && skirt != null)
		uniform = skirt

/// Lab Assistant
/datum/job/assistant/dept/sci
	title = JOB_ASSISTANT_SCI
	description = "Witness the marvels of modern age technology, and be a test subject for them."
	department_head = list(JOB_RESEARCH_DIRECTOR)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_RD

	outfit = /datum/outfit/job/assistant/dept/sci
	plasmaman_outfit = /datum/outfit/plasmaman/science

	paycheck_department = ACCOUNT_SCI
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_SCI

	departments_list = list(
		/datum/job_department/science,
		)

	//job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	config_tag = "LAB_ASSISTANT"

/datum/outfit/job/assistant/dept/sci
	name = JOB_ASSISTANT_SCI
	jobtype = /datum/job/assistant/dept/sci
	id_trim = /datum/id_trim/job/assistant/sci
	uniform = /obj/item/clothing/under/color/lightpurple
	skirt = /obj/item/clothing/under/color/jumpskirt/lightpurple
	belt = /obj/item/modular_computer/tablet/pda/science
	ears = /obj/item/radio/headset/headset_sci

/datum/id_trim/job/assistant/sci
	assignment = "Lab Assistant"
	subdepartment_color = COLOR_SCIENCE_PINK
	minimal_access = list(
		ACCESS_SCIENCE,
	)
	extra_access = list(
		ACCESS_RESEARCH,
		ACCESS_XENOBIOLOGY,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_RD,
		)
	job = /datum/job/assistant/dept/sci

/// Medical Assistant
/datum/job/assistant/dept/med
	title = JOB_ASSISTANT_MED
	description = "Handle patients coming in and out of medbay, lack a medical license."
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_CMO

	outfit = /datum/outfit/job/assistant/dept/med
	plasmaman_outfit = /datum/outfit/plasmaman/medical

	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_MED

	departments_list = list(
		/datum/job_department/medical,
		)

	//job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	config_tag = "MEDICAL_ASSISTANT"

/datum/outfit/job/assistant/dept/med
	name = JOB_ASSISTANT_MED
	jobtype = /datum/job/assistant/dept/med
	id_trim = /datum/id_trim/job/assistant/med
	uniform = /obj/item/clothing/under/color/blue
	skirt = /obj/item/clothing/under/color/jumpskirt/blue
	belt = /obj/item/modular_computer/tablet/pda/medical
	ears = /obj/item/radio/headset/headset_med

/datum/id_trim/job/assistant/med
	assignment = "Medical Assistant"
	subdepartment_color = COLOR_MEDICAL_BLUE
	minimal_access = list(
		ACCESS_MEDICAL,
	)
	extra_access = list(
		ACCESS_MORGUE,
		ACCESS_SURGERY,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_CMO,
		)
	job = /datum/job/assistant/dept/med

/// Tech Support
/datum/job/assistant/dept/eng
	title = JOB_ASSISTANT_ENG
	description = "Make your own pet projects, get called away to fix every little thing."
	department_head = list(JOB_CHIEF_ENGINEER)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_CE

	outfit = /datum/outfit/job/assistant/dept/eng
	plasmaman_outfit = /datum/outfit/plasmaman/engineering

	paycheck_department = ACCOUNT_ENG
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_ENG

	departments_list = list(
		/datum/job_department/engineering,
		)

	//job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	config_tag = "TECH_SUPPORT"

/datum/outfit/job/assistant/dept/eng
	name = JOB_ASSISTANT_ENG
	jobtype = /datum/job/assistant/dept/eng
	id_trim = /datum/id_trim/job/assistant/eng
	uniform = /obj/item/clothing/under/color/yellow
	skirt = /obj/item/clothing/under/color/jumpskirt/yellow
	belt = /obj/item/modular_computer/tablet/pda/engineering
	ears = /obj/item/radio/headset/headset_eng

/datum/id_trim/job/assistant/eng
	assignment = "Tech Support"
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_MAINT_TUNNELS,
	)
	extra_access = list(
		ACCESS_CONSTRUCTION,
		ACCESS_ENGINE_EQUIP,
		ACCESS_EXTERNAL_AIRLOCKS,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_CE,
		)
	job = /datum/job/assistant/dept/eng

/// Waitron
/datum/job/assistant/dept/srv
	title = JOB_ASSISTANT_SRV
	description = "Bus tables, work for tips."
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_HOP

	outfit = /datum/outfit/job/assistant/dept/srv

	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_SRV

	departments_list = list(
		/datum/job_department/service,
		)

	//job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	config_tag = "WAITRON"

/datum/outfit/job/assistant/dept/srv
	name = JOB_ASSISTANT_SRV
	jobtype = /datum/job/assistant/dept/srv
	id_trim = /datum/id_trim/job/assistant/srv
	uniform = /obj/item/clothing/under/suit/waiter
	ears = /obj/item/radio/headset/headset_srv

/datum/id_trim/job/assistant/srv
	assignment = "Waitron"
	subdepartment_color = COLOR_SERVICE_LIME
	minimal_access = list(
		ACCESS_SERVICE,
	)
	extra_access = list(
		ACCESS_BAR,
		ACCESS_HYDROPONICS,
		ACCESS_KITCHEN,
		ACCESS_THEATRE,
		)
	job = /datum/job/assistant/dept/srv
