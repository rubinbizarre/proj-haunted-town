if (depth != -y) depth = -y;

#region while not spooked or not hit by van, manage animation, path speed
if (!spooked) or (!hit_by_van) {
	#region routine check (old) (commented)
	//// if not enticed, do periodic routine check
	//if (current_state != "ENTICED") {//and (current_state != "INSIDE") {
	//	// periodic routine check
	//	if (check_timer-- <= 0) {
	//	    check_timer = check_interval;
	//	    event_user(0); // trigger routine logic
	//	}
	//}
	#endregion
	
	#region animation & sprite flipping logic
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
	#endregion
	
	// make path_speed affected by current time_speed
	if (instance_exists(obj_manager_time)) {
		path_speed = move_speed_init * obj_manager_time.time_speed_actual;
	}
	
	#region extra behaviours per state (commented)
	//switch (current_state) {
	//	case "CIRCUIT": {
	//		// tie path speed to time speed like everyone else
	//		// (actually needed for some reason to make walk anim work)
	//		path_speed = move_speed_init * obj_manager_time.time_speed_actual;
	//	} break;
	//	case "PLAY_PARK": { // nothing
	//	} break;
	//	case "INSIDE": { // commented
	//		//// when arrived at destination,
	//		//// make invisible if visible
	//		//if (point_distance(x, y, target_x, target_y) < 2) {
	//		//	if (visible) visible = false;
	//		//}
	//		//// when arrived at home,
	//		//// make invisible if visible
	//		//if (x == home_obj.x) and (y == home_obj.y) {
	//		//	if (visible) visible = false;
	//		//}
	//	} break;
	//	default: {
	//		//if (point_distance(x, y, target_x, target_y) < 2) {
	//		//	target_x = 0;
	//		//	target_y = 0;
	//		//	target_obj = noone;
	//		//	enter_building();	
	//		//	show_debug_message("obj_par_npc STEP: "+string(id)+": "+string(current_state)+": now entering building");
	//		//}
	//	} break;
	//}
	#endregion
}
#endregion

// routine timer set in user event 0 when hour changes and assigned state differs from current state 
if (routine_timer > 0) {
    routine_timer--;    
    // once the timer hits zero, finally execute the routine change
    if (routine_timer == 0) {
        event_user(1);
    }
}

#region handle outcome of reaching target for various states
//switch (current_state) {
//	case "WANDER_TOWN" or "WANDER_TOWN_AGAIN": {
//		if (point_distance(x, y, target_x, target_y) < 2) {
//			enter_building();
//			//show_debug_message("obj_par_npc STEP: "+string(id)+": "+routine_type+": "+current_state+": now entering building");
//		}
//	} break;
//}
if (current_state == "WANDER_TOWN") or
	(current_state == "WANDER_TOWN_AGAIN") or 
	(current_state == "RETURN_HOME") or 
	(current_state == "ENTICED")
{
	if (point_distance(x, y, target_x, target_y) < 2) {
		enter_building();
		//show_debug_message("obj_par_npc STEP: "+string(id)+": "+routine_type+": "+current_state+": now entering building");
	}
}
#endregion

#region handle being spooked and recovering
if (spooked) {
	if (image_index != 1) {
		// if npc is not "scared_stiff",
		// change sprite to spooked
		if (current_state != "SCARED_STIFF") {
			image_index = 1;
		}
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
#endregion

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

#region handle movement while inside WIP (commented)
//if (is_inside) and (can_move_inside) and (x > 20000) {
//	if (move_timer-- <= 0) or (!move_inside) {
//		move_timer = choose(60, 120, 180, 240);
        
//		var _tx = x + irandom_range(-inside_range_min, inside_range_max);
//        var _ty = y + irandom_range(-inside_range_min, inside_range_max);
		
//		var _interior = current_building.interior_obj;
		
//		_tx = clamp(_tx, _interior.bbox_left, _interior.bbox_right);
//		_ty = clamp(_ty, _interior.bbox_top, _interior.bbox_bottom);
		
//		inside_x = _tx;
//		inside_y = _ty;
		
//		move_inside = true;
//	}
//	// move toward target if in moving state
//	if (move_inside) {
//		move_towards_point(inside_x, inside_y, move_speed);
//		if (point_distance(x, y, inside_x, inside_y) < 2) {
//			x = inside_x;
//			y = inside_y;
//			move_inside = false;
//			if (wait_timer-- <= 0) {
//				wait_timer = choose(180, 240);
//			}
//		}
//	}
//}
#endregion

#region handle SHAKING while fear > 0 and not scared_stiff, also create/destroy possess/kill npc buttons
if (fear > 0) {//and (current_state != "SCARED_STIFF") {
	// store the npc's initial position before shaking
	if (!shake_init_pos_stored) {
		shake_init_x = x;
	    shake_init_y = y;
	    shake_init_pos_stored = true;
	}
	
	// shake in both axes when not scared_stiff
	// when scared_stiff, shake only in x-axis
	if (current_state != "SCARED_STIFF") and (!dying) {
		// constant shake logic
		var _shake_x = random_range(-shake_intensity, shake_intensity);
		var _shake_y = random_range(-shake_intensity, shake_intensity);
		x = shake_init_x + _shake_x;
		y = shake_init_y + _shake_y;
		
		// destroy possess/kill buttons if they exist
		if (instance_exists(soul_flame)) instance_destroy(soul_flame); soul_flame = noone;
		if (instance_exists(btn_possess)) instance_destroy(btn_possess); btn_possess = noone;
		if (instance_exists(btn_kill)) instance_destroy(btn_kill); btn_kill = noone;
		
	} else { // if current_state == SCARED_STIFF
		var _intensity = shake_intensity * 0.6;
		var _shake_x = random_range(-_intensity, _intensity);
		x = shake_init_x + _shake_x;
	}
} else {
	//if (x != shake_init_x) x = shake_init_x;
	//if (y != shake_init_y) y = shake_init_y;
	if (shake_init_pos_stored) shake_init_pos_stored = false;
}
#endregion

#region create possess/kill npc buttons if conditions met
if (current_state == "SCARED_STIFF") and (fear >= 0.8) {
	if (btn_possess == noone) or (btn_kill == noone) {
	//if (!instance_exists(btn_possess)) or (!instance_exists(btn_kill)) {
		var _x1 = x - sprite_get_width(spr_npc_elderly);
		var _x2 = x + sprite_get_width(spr_npc_elderly);
		var _y = y - sprite_get_height(sprite_index)/2;
		btn_possess = instance_create_layer(_x1, _y, "Master", obj_btn_npc_options);
		btn_kill = instance_create_layer(_x2, _y, "Master", obj_btn_npc_options);
		btn_possess.btn_kill = btn_kill;
		btn_possess.npc = id;
		btn_possess.sprite_index = spr_btn_npc_possess;
		btn_possess.depth = depth - 1;
		btn_kill.btn_possess = btn_possess;
		btn_kill.npc = id;
		btn_kill.sprite_index = spr_btn_npc_kill;
		btn_kill.depth = depth - 1;
	}
}
#endregion

#region handle decreasing fear with repeating timer whilst fear_drain is active
if (fear_drain) and (!dying) {
	if (fear_drain_timer-- <= 0) {
		fear_drain_timer = fear_drain_interval;
		decrease_fear();
	}
}
#endregion

#region handle dying process
if (dying) {
	y -= dying_ascent_speed;
	image_alpha -= dying_fade_speed;
	if (image_alpha <= 0) {
		// remove self from the building's occupants array
	    for (var i = 0; i < array_length(current_building.occupants); i++) {
	        if (current_building.occupants[i] == id) {
	            array_delete(current_building.occupants, i, 1);
	            break;
	        }
	    }
		// increase total kills
		global.total_kills++;
		// destroy this npc inst
		instance_destroy();
	}
}
#endregion

#region handle possession transition
if (possess_transition) {
		
	possess_timer--;
	
	var _possess_progression = (possess_timer_init - possess_timer) / possess_timer_init;
	
	// shake starts at 0 and becomes more violent towards end of 'transition'
	var _shake_intensity = possess_shake_intensity * _possess_progression;
	
	// constant shake logic
	var _shake_x = random_range(-_shake_intensity, _shake_intensity);
	var _shake_y = random_range(-_shake_intensity, _shake_intensity);
	x = shake_init_x + _shake_x;
	y = shake_init_y + _shake_y;
	
	// end of possess transition
	if (possess_timer <= 0) {
		// place inst back in correct spot
		x = shake_init_x;
		y = shake_init_y;
		// set to possessed frame
		image_index = 3;
		
		current_state = "INSIDE";
		
		// clean up
		fear_drain = false;
		fear_drain_timer = fear_drain_interval;
		possess_timer = possess_timer_init;
		shake_init_pos_stored = false;
		possess_transition = false;
		
		// mark as possessed (enables remote-enticing and drawing the possessed_radius)
		possessed = true;
		
		// trigger do normal routine after short delay
		alarm[6] = game_get_speed(gamespeed_fps) * 1.5;
	}
}
#endregion

#region handle while possessed check for other npcs 
// periodic check for collisions whilst haunted
if (possessed) {
	if (check_timer-- <= 0) {
	    check_timer = check_interval;
	    check_for_npcs();
	}
}
#endregion