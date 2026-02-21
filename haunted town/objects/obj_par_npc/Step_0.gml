// while not spooked
if (!spooked) {
	// periodic routine check
	if (check_timer-- <= 0) {
	    check_timer = check_interval;
	    event_user(0); // trigger routine logic
	}

	// animation & sprite flipping logic
	if (path_index != -1) {
	    // if moving/on a path, face the direction of movement
	    image_xscale = (direction > 90 and direction < 270) ? -scale_init : scale_init;
		// progress through animcurve at ac_speed affected by move_speed
		if (ac_time_bob < 1) {
			ac_time_bob += (ac_speed_bob * move_speed);
		} else {
			ac_time_bob = 0;
		}
		// apply animcurve value to yscale
		image_yscale = animcurve_channel_evaluate(ac_channel_bob, ac_time_bob);
	} else {
		// if not moving/not on a path, make yscale constant and reset animcurve to start pos
		if (image_yscale != 1) image_yscale = 1;
		if (ac_time_bob != 0) ac_time_bob = 0;
	}
	
	// make path_speed affected by current time_speed
	if (instance_exists(obj_manager_time)) {
		path_speed = move_speed_init * obj_manager_time.time_speed_actual;
	}
}

if (spooked) {
	// store current path speed
	prev_path_speed = path_speed;
	// stop moving
	path_speed = 0;
	// change sprite to spooked
	//...
	// play through animcurve once
	if (ac_time_spook < 1) {
		ac_time_spook += ac_speed_spook;
	}
	// apply animcurve value to yscale
	image_yscale = animcurve_channel_evaluate(ac_channel_spook, ac_time_spook);
}

switch (current_state) {
	case "CIRCUIT": {
		// tie path speed to time speed like everyone else
		path_speed = move_speed_init * obj_manager_time.time_speed_actual;
	} break;
	case "PLAY_PARK": {
		// do nothing (this is actually useful)
		// could change to 'play sprite' or smthn
	} break;
	case "INSIDE": {
		// when arrived at destination,
		// make invisible if visible
		if (x == target_x) and (y == target_y) {
			if (visible) visible = false;
		}
		// when arrived at home,
		// make invisible if visible
		if (x == home_id.x) and (y == home_id.y) {
			if (visible) visible = false;
		}
	} break;
	default: {
		// when arrived at destination,
		// make invisible if visible
		if (x == target_x) and (y == target_y) {
			if (visible) visible = false;
		}
	} break;
}