if (depth != -y) depth = -y;

// while not spooked or not hit by van
if (!spooked) or (!hit_by_van) {
	// if not enticed, do periodic routine check
	if (current_state != "ENTICED") {
		// periodic routine check
		if (check_timer-- <= 0) {
		    check_timer = check_interval;
		    event_user(0); // trigger routine logic
		}
	}
	
	// animation & sprite flipping logic
	if (path_index != -1) and (!spooked) {
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
	
	switch (current_state) {
		case "CIRCUIT": {
			// tie path speed to time speed like everyone else
			path_speed = move_speed_init * obj_manager_time.time_speed_actual;
		} break;
		case "PLAY_PARK": {
			// do nothing (this is actually useful (?))
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
}

if (spooked) {
	if (image_index != 1) {
		// change sprite to spooked
		image_index = 1;
		// play sound (spooked npc)
		//...
		
		//// store current path speed
		//prev_path_speed = path_speed;
		//// stop moving
		//path_speed = 0;
		
		if (path_exists(my_path)) {
			my_path_duplicate = path_duplicate(my_path);
		}
		
		path_end();
		
		//iframes_spook = true;
		
		// delayed recovery to previous behaviour
		alarm[0] = game_get_speed(gamespeed_fps) * 2;
		
		//// delayed disable iframes_spook
		//alarm[3] = game_get_speed(gamespeed_fps) * 6;
		
		//show_debug_message("obj_par_npc STEP: "+string(id)+" was spooked");
	}
	
	// play through animcurve once
	if (ac_time_spook < 1) {
		ac_time_spook += ac_speed_spook;
	}
	
	var _ac_value = animcurve_channel_evaluate(ac_channel_spook, ac_time_spook);
	// apply animcurve value to yscale
	image_yscale = _ac_value;
	//// and affect ypos (wip)
	//var _prev_y = y;
	//y = _prev_y - ;
}

#region handle collision with nev's van: lie on floor for a couple seconds then get back up
if (instance_exists(obj_nev_van)) {
	if (place_meeting(x, y, obj_nev_van)) {
		if (!hit_by_van) and (!iframes) {
			hit_by_van = true;
			var _angle = (obj_nev_van.x < x) ? -90 : 90;
			image_angle = _angle;
			image_xscale = scale_init;
			image_yscale = scale_init;
			// play sound (hit by van)
			//...
		
			//prev_path_speed = path_speed;
			//path_speed = 0;
		
			//prev_move_speed = move_speed;
			//move_speed = 0;
		
			if (path_exists(my_path)) {
				my_path_duplicate = path_duplicate(my_path);
			}
		
			path_end();
		
			iframes = true;
		
			// delayed recovery to previous behaviour
			alarm[1] = game_get_speed(gamespeed_fps) * 2;
		
			// delayed disable iframes
			alarm[2] = game_get_speed(gamespeed_fps) * 6;
		
			//show_debug_message("obj_par_npc ALARM[1]: "+string(id)+" was hit_by_van");
		}
	}
}
#endregion

#region handle enticing via clicking (commented) (now in obj_par_building step)
//if (mouse_check_button_pressed(mb_left)) and
//	(point_in_rectangle(mouse_x, mouse_y,
//		x - (sprite_width/2) - 4,
//		y - sprite_height - 4,
//		x + (sprite_width/2) + 4,
//		y + 4
//	)) {
//	// if npc is within a haunted obj_par_building's entice_radius, target that inst
//	// if npc is within multiple haunted obj_par_buildings' entice_radii, target the closest inst to npc
	
//	// store npc path
//	if (path_exists(my_path)) {
//		my_path_duplicate = path_duplicate(my_path);
//	}
//	// make npc stop
//	path_end();
//	// make npc 'shiver'
//	//...
//	// make npc sprite shocked
//	image_index = 1;

//	// change npc state - block routine checks while in this state
//	current_state = "ENTICED";

//	// delayed trigger to actually move into the nearest hbuilding
//	alarm[0] = game_get_speed(gamespeed_fps) * 2;
//}
#endregion