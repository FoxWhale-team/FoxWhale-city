/mob/living/silicon/robot/BiologicalLife(delta_time, times_fired)
	if(!(. = ..()))
		return
	handle_robot_hud_updates()
	handle_robot_cell()

/mob/living/silicon/robot/proc/handle_robot_cell()
	if(stat != DEAD)
		if(low_power_mode)
			if(cell?.charge)
				low_power_mode = FALSE
		else if(stat == CONSCIOUS)
			use_power()

/mob/living/silicon/robot/proc/use_power()
	if(cell?.charge)
		if(cell.charge <= 100)
			uneq_all()
		var/amt = clamp((lamp_enabled * lamp_intensity),1,cell.charge) //Lamp will use a max of 5 charge, depending on brightness of lamp. If lamp is off, borg systems consume 1 point of charge, or the rest of the cell if it's lower than that.
		cell.use(amt) //Usage table: 1/tick if off/lowest setting, 4 = 4/tick, 6 = 8/tick, 8 = 12/tick, 10 = 16/tick
	else
		uneq_all()
		low_power_mode = TRUE
		toggle_headlamp(TRUE)
	diag_hud_set_borgcell()

/mob/living/silicon/robot/proc/handle_robot_hud_updates()
	if(!client)
		return

	update_cell_hud_icon()

/mob/living/silicon/robot/proc/update_cell_hud_icon()
	if(cell)
		var/cellcharge = cell.charge/cell.maxcharge
		switch(cellcharge)
			if(0.75 to INFINITY)
				clear_alert("charge")
			if(0.5 to 0.75)
				throw_alert("charge", /atom/movable/screen/alert/lowcell, 1)
			if(0.25 to 0.5)
				throw_alert("charge", /atom/movable/screen/alert/lowcell, 2)
			if(0.01 to 0.25)
				throw_alert("charge", /atom/movable/screen/alert/lowcell, 3)
			else
				throw_alert("charge", /atom/movable/screen/alert/emptycell)
	else
		throw_alert("charge", /atom/movable/screen/alert/nocell)

//Robots on fire
/mob/living/silicon/robot/handle_fire()
	if(..())
		return
	if(fire_stacks > 0)
		fire_stacks--
		fire_stacks = max(0, fire_stacks)
	else
		ExtinguishMob()

	//adjustFireLoss(3)
	return

/mob/living/silicon/robot/update_fire()
	var/mutable_appearance/fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', "Generic_mob_burning")
	if(on_fire)
		add_overlay(fire_overlay)
	else
		cut_overlay(fire_overlay)
