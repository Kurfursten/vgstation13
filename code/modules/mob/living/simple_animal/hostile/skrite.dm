//Skrites: This code is very shittily stolen from bear code. Please don't crucify me
/mob/living/simple_animal/hostile/skrite
	name = "skrite"
	desc = "A highly predatory being with two dripping claws."
	icon_state = "skrite"
	icon_living = "skrite"
	icon_dead = "skrite_dead"
	icon_gib = "skrite_dead"
	speak = list("SKREEEEEEEE!","SKRAAAAAAAAW!","KREEEEEEEEE!")
	speak_emote = list("screams", "shrieks")
	emote_hear = list("snarls")
	emote_see = list("lets out a scream", "rubs its claws together")
	speak_chance = 20
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	stop_automated_movement_when_pulled = 0
	maxHealth = 200
	health = 200
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_sound = 'sound/effects/lingstabs.ogg'
	attacktext = "uses its blades to stab"

	//Skrites aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/stance_step = 0

	faction = "russian"


/mob/living/simple_animal/hostile/skrite/Move()
	..()
	if(stat != DEAD)
		if(loc && istype(loc,/turf/space))
			icon_state = "skrite"
		else
			icon_state = "skritefloor"

/mob/living/simple_animal/hostile/skrite/Life()
	. =..()
	if(!.)
		return

	switch(stance)

		if(HOSTILE_STANCE_TIRED)
			stop_automated_movement = 1
			stance_step++
			if(stance_step >= 10) //rests for 10 ticks
				if(target && target in ListTargets())
					stance = HOSTILE_STANCE_ATTACK //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					stance = HOSTILE_STANCE_IDLE

		if(HOSTILE_STANCE_ALERT)
			stop_automated_movement = 1
			var/found_mob = 0
			if(target && target in ListTargets())
				if(CanAttack(target))
					stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
					stance_step++
					found_mob = 1
					src.dir = get_dir(src,target)	//Keep staring at the mob

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "screams at [target]", "sharpens its claws while staring at [target]" ) )
						if(action)
							emote(action)
			if(!found_mob)
				stance_step--

			if(stance_step <= -20) //If we have not found a mob for 20-ish ticks, revert to idle mode
				stance = HOSTILE_STANCE_IDLE
			if(stance_step >= 7)   //If we have been staring at a mob for 7 ticks,
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACKING)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and needs to rest
				emote( "is worn out and needs to rest" )
				stance = HOSTILE_STANCE_TIRED
				stance_step = 0
				walk(src, 0) //This stops the skrite's walking
				return



/mob/living/simple_animal/hostile/skrite/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target = user
	..()

/mob/living/simple_animal/hostile/skrite/attack_hand(mob/living/carbon/human/M as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target = M
	..()

/mob/living/simple_animal/hostile/skrite/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for skrites!

/mob/living/simple_animal/hostile/skrite/FindTarget()
	. = ..()
	if(.)
		emote("stares alertly at [.]")
		stance = HOSTILE_STANCE_ALERT

/mob/living/simple_animal/hostile/skrite/LoseTarget()
	..(5)


/mob/living/simple_animal/hostile/skrite/AttackingTarget()
	..()
	emote( pick( list("SKREEEEEEEEEEEEE!", "SCRAAAAAAAAW!") ) )

	var/damage = rand(20,30)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/datum/organ/external/affecting = H.get_organ(ran_zone(dam_zone))
		H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"))
		return H
	else if(isliving(target))
		var/mob/living/L = target
		L.adjustBruteLoss(damage)
		return L
	else if(istype(target,/obj/mecha))
		var/obj/mecha/M = target
		M.attack_animal(src)
		return M
