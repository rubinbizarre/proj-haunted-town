depth = -y;
if (instance_exists(obj_ps_nev_scared)) {
	obj_ps_nev_scared.depth = depth - 100;
	//show_debug_message("assigned depth to ps_nev_scared");
}

#region animation & sprite flipping logic
if (path_index != -1) and (!spooked) {
	// if moving/on a path, face the direction of movement
	image_xscale = (direction > 90 and direction < 270) ? -scale_init : scale_init;
	
	// bob: progress through animcurve at ac_speed affected by move_speed
	if (ac_time_bob < 1) {
		ac_time_bob += (ac_speed_bob * move_speed);
	} else {
		ac_time_bob = 0;
	}
	// apply animcurve value to yscale
	image_yscale = animcurve_channel_evaluate(ac_channel_bob, ac_time_bob);
	
	// shiver: progress through animcurve at ac_speed
	if (ac_time_shiver < 1) {
		ac_time_shiver += ac_speed_shiver;
	} else {
		ac_time_shiver = 0;
	}
	// apply animcurve value to yscale
	image_xscale *= animcurve_channel_evaluate(ac_channel_shiver, ac_time_shiver) * 0.9;
	
} else {
	// if not moving/not on a path, make yscale constant and reset animcurve to start pos
	image_yscale = 1;
	ac_time_bob = 0;
	ac_time_shiver = 0;
}

#endregion
	
// make path_speed affected by current time_speed
if (instance_exists(obj_manager_time)) {
	path_speed = move_speed_init * obj_manager_time.time_speed_actual;
}

// if nev has reached the target circuit node, decide on a new destination and go
if (!spooked) {
	if (point_distance(x, y, target_x, target_y) < 2) {
        //path_clear_points(my_path);
		path_add_point(my_path, x, y, 100);
		// choose random circuit node to travel to
		// ig ideally this would only pick a random node within a certain radius of him
		var _no_nodes = instance_number(obj_node_circuit) - 1;
		var _n = irandom_range(0, _no_nodes);
		var _node = instance_find(obj_node_circuit, _n);
		// add this nearest path circuit node pos to path
		target_x = _node.x;
		target_y = _node.y;
		path_add_point(my_path, target_x, target_y, 100);
		// modify path properties
		path_set_closed(my_path, false);
		path_set_kind(my_path, 0);
		// start moving along the path
		if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
			path_start(my_path, move_speed, path_action_stop, true);
		}
    }
}

#region make nev's particle system inst track with his pos
if (ps_scared != noone) {
	if (instance_exists(ps_scared)) {
		ps_scared.x = x;
		ps_scared.y = y - (sprite_get_height(sprite_index)/2);
		ps_scared.depth = depth - 10;
	}
}
#endregion

#region handle being spooked and recovering
if (spooked) {
	if (sprite_index != sprite_spooked) {
		// change sprite to spooked
		sprite_index = sprite_spooked;
		
		// play sound (spooked nev)
		//...
		
		// increase fear stat
		global.nev_fear += global.nev_fear_gain;
		
		// store path but stop moving right now
		if (path_exists(my_path)) {
			my_path_duplicate = path_duplicate(my_path);
		}
		path_end();
		
		//// delayed recovery to previous behaviour
		//timer_disable_spook_cur = timer_disable_spook_max;
		
		show_debug_message("obj_nev_scared STEP: nev was spooked! fear = "+string(global.nev_fear));
	}
	
	// play through spook animcurve once
	if (ac_time_spook < 1) {
		ac_time_spook += ac_speed_spook;
	}
	// apply animcurve value to yscale
	var _ac_value = animcurve_channel_evaluate(ac_channel_spook, ac_time_spook);
	image_yscale = _ac_value;
	
	// when we reach the end of the spook anim, go back to wandering
	if (image_index >= (image_number - 1)) {
		// reset
		spooked = false;
		ac_time_spook = 0;
		sprite_index = sprite_idle;
		image_xscale = prev_xscale; // face the same way as before spook
		
		// continue on path as before
		my_path = my_path_duplicate;
		if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
			path_start(my_path, move_speed, path_action_stop, true);
		}
	}
}
#endregion

#region TIMERS
#region TEMPLATE (commented)
//if (timer_glance_cur > 0) {
//	timer_glance_cur -= (delta_time / 1000000) * obj_manager_time.time_speed_normalised;

//	if (timer_glance_cur <= 0) {
//	    timer_glance_cur = -1;
//	    #region --- alarm[0] code ---
//		// desc
//		// ------------------------------------------
//		//...
//		#endregion
//	}
//}
#endregion

#region handle decrementing timer_glance (commented)
//if (timer_glance_cur > 0) {
//	timer_glance_cur -= (delta_time / 1000000) * obj_manager_time.time_speed_normalised;

//	if (timer_glance_cur <= 0) {
//	    timer_glance_cur = -1;
//	    #region --- alarm[0] code ---
//		// glance the other way briefly
//		// ---------------------------------
//		image_xscale *= -1;
//		glance_counter++;
//		if (glance_counter >= 2) {
//			timer_glance_end_cur = timer_glance_end_max;
//			exit;
//		}
//		timer_glance_cur = timer_glance_max;
//		#endregion
//	}
//}
#endregion

#region handle decrementing timer_glance_end (commented)
//if (timer_glance_end_cur > 0) {
//	timer_glance_end_cur -= (delta_time / 1000000) * obj_manager_time.time_speed_normalised;

//	if (timer_glance_end_cur <= 0) {
//	    timer_glance_end_cur = -1;
//	    #region --- alarm[1] code ---
//		// path to nearest circuit node from van
//		// --------------------------------------
//		path_add_point(my_path, x, y, 100);
//		// find nearest path circuit node to nev
//		var _node = instance_nearest(x, y, obj_node_circuit);
//		// add this nearest path circuit node pos to path
//		target_x = _node.x;
//		target_y = _node.y;
//		path_add_point(my_path, target_x, target_y, 100);
//		// store this node's x,y pos for later when pathing back to van
//		return_path_x = _node.x;
//		return_path_y = _node.y;
//		// modify path properties
//		path_set_closed(my_path, false);
//		path_set_kind(my_path, 0);
//		// start moving along the path
//		path_start(my_path, move_speed, path_action_stop, true);
//		//show_debug_message("obj_nev ALARM[1]: started path to nearest circuit node. total points: "+string(path_get_number(my_path)));
//		#endregion
//	}
//}
#endregion

#region handle decrementing timer_leave_building
if (timer_leave_building_cur > 0) {
	timer_leave_building_cur -= (delta_time / 1000000) * obj_manager_time.time_speed_normalised;

	if (timer_leave_building_cur <= 0) {
	    timer_leave_building_cur = -1;
	    #region --- alarm[2] code ---
		// leave when nothing inside is haunted
		// ------------------------------------------
		//leave_building();
		current_state = "SURVEY_POI"; // leaves building for us and resumes normal behaviour
		finished_surveying = true;
		#endregion
	}
}
#endregion

#endregion