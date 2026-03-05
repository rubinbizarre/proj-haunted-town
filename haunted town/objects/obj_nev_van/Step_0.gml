if (depth != -(y + 25)) depth = -(y + 25); // set correct depth based on ypos and sprite origin offset. i think its closer to 22 but whatever

// periodic routine check but only in certain conditions
if (current_state == "RETURN_HOME") {
	if (check_timer-- <= 0) {
		check_timer = check_interval;
		event_user(0); // trigger routine logic
	}
} else {
	// periodic check for haunted POIs whilst nev is 'inside' the van
	if (!instance_exists(obj_nev)) and (check_timer-- <= 0) {
		check_timer = check_interval;
		var _temp_list = ds_list_create();
		var _num = collision_circle_list(x, y, global.nev_detect_radius, obj_par_world_objects, false, true, _temp_list, false);
		for (var i = 0; i < _num; i++) {
		    var _inst = _temp_list[| i];
		    // if it's haunted, not already queued, not our current focus, and not locked: push it
		    if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (!_inst.locked) {
		        array_push(global.nev_todo_queue, _inst);
				//// edit the existing path to end at the nearest road_node to the discovered POI
				var _nearest_road_node = instance_nearest(_inst.x, _inst.y, obj_node_road);
				
				path_clear_points(my_path);
				path_add_point(my_path, x, y, 100);
				path_add_point(my_path, _nearest_road_node.x, _nearest_road_node.y, 100);
				path_start(my_path, move_speed, path_action_stop, true);
				
				//// remove all points ahead of the next 'stop' so that the van stops asap
				//while (path_get_number(path_index) > 2) {
				//    path_delete_point(path_index, 2); 
				//}
				
				//// redirect to stop
				//current_state = "REDIRECT_AND_STOP";
				//target_stop_node = _nearest_road_node;
				
				show_debug_message("obj_nev_van STEP: "+current_state+": pushed inst to todo_queue ("+string(array_length(global.nev_todo_queue))+" total): "+string(_inst.id));
				//show_debug_message("now stopping at nearest road node: "+string(_nearest_road_node.node_id));
				//show_debug_message("path is now: "+string(_total_points)+" points total.");
				
				show_debug_message("obj_nev_van STEP: "+current_state+": target_stop_node: "+string(_nearest_road_node.node_id));
				
				//// output every path point's coords
				//for (var j = 0; j < _total_points; j++) {
				//	path_get_point_x(my_path, j);
				//	path_get_point_y(my_path, j);
				//	//...
				//}
		    }
		}
		ds_list_destroy(_temp_list);
	}
}

#region animation / sprite flipping logic
if (path_index != -1) {
	//// smoothly rotate the sprite to face the direction of the path
	//// works, nice effect, but not for the current sprite switching configuration?
    //var _target_angle = direction;
    //image_angle = lerp(image_angle, _target_angle, 0.1);
	
	// if moving/on a path, face the direction of movement
	switch (direction) {
		case 0: { // facing right
			if (image_xscale != scale_init) image_xscale = scale_init;
			if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
		} break;
		case 180: { // facing left
			if (image_xscale != -scale_init) image_xscale = -scale_init;
			if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
		} break;
		case 270: { // facing down
			if (image_xscale != scale_init) image_xscale = scale_init;
			if (sprite_index != spr_nev_van_down) sprite_index = spr_nev_van_down;
		} break;
		case 90: { // facing up
			if (image_xscale != scale_init) image_xscale = scale_init;
			if (sprite_index != spr_nev_van_up) sprite_index = spr_nev_van_up;
		} break;
		default: { // if any other value, make a decision
			if (direction > 90 and direction < 270) { // facing left
				if (image_xscale != -scale_init) image_xscale = -scale_init;
				if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
			} else if (direction > 180 and direction < 360) { // facing right
				if (image_xscale != scale_init) image_xscale = scale_init;
				if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
			}
		} break;
	}
}
#endregion
	
// make path_speed affected by current time_speed
if (instance_exists(obj_manager_time)) {
	path_speed = move_speed_init * obj_manager_time.time_speed_actual;
}

switch (current_state) {
	case "LEAVE_HOME": {
		if (point_distance(x, y, target_x, target_y) < 2) {
		//	if (array_length(global.nev_todo_queue) > 0) {
		//		// nev has at least one POI to visit already. stop and deploy him
		//		target_x = 0;
		//		target_y = 0;
		//		current_state = "IDLE";
			
		//		// deploy Nev after short delay
		//		alarm[0] = game_get_speed(gamespeed_fps) * 1.25;
			
		//		show_debug_message("obj_nev_van STEP: changed state from LEAVE_HOME to IDLE - at least one POI inside nev_todo_queue. deploying Nev shortly!");
		//	} else {
				target_x = 0;
				target_y = 0;
				
				//if (array_length(global.nev_todo_queue) <= 0) {
				
					current_state = "DRIVE_AND_STOP";
			
					show_debug_message("obj_nev_van STEP: changed state from LEAVE_HOME to DRIVE_AND_STOP - no POIs inside nev_todo_queue. going to new dest.");
			
					//goto_new_dest();
				//}
			//}
		}
	} break;
	case "DRIVE_AND_STOP": {
		if (path_index == -1) and (current_state != "IDLE") {
			if (array_length(global.nev_todo_queue) > 0) {
				// nev has at least one POI to visit. stop and deploy him
				target_x = 0;
				target_y = 0;
				current_state = "IDLE";
			
				// deploy Nev after short delay
				alarm[0] = game_get_speed(gamespeed_fps) * 1.25;
			
				show_debug_message("obj_nev_van STEP: changed state from DRIVE_AND_STOP to IDLE. at least one POI inside nev_todo_queue. deploying Nev shortly!");
			} else {
				// nev has no POIs to visit. keep driving around
				goto_new_dest();
				
				show_debug_message("obj_nev_van STEP: state unchanged from DRIVE_AND_STOP. no POIs inside nev_todo_queue. driving elsewhere!");
			}
		}
	} break;
	case "REDIRECT_AND_STOP": {
		// wait until van reaches the very next node on its path
		var _path_point_x = path_get_point_x(my_path, 1);
		var _path_point_y = path_get_point_y(my_path, 1);
		var _dist_to_next_point = point_distance(x, y, _path_point_x, _path_point_y);
		
		if (_dist_to_next_point < 5) {
			// van is at the next node
			// use routing script to determine optimal path to the 'target_stop_node'
			var _nearest_road_node = instance_nearest(x, y, obj_node_road);
			var _new_route = scr_find_path_nodes(_nearest_road_node, target_stop_node);
			show_debug_message("obj_nev_van STEP: "+string(current_state)+": van calculated optimal path to target_stop_node");
			
			if (array_length(_new_route) > 0) {
				path_clear_points(my_path);
				show_debug_message("obj_nev_van STEP: "+string(current_state)+": cleared path points");
				// add points from the route to the path
				for (var i = 0; i < array_length(_new_route); i++) {
	                path_add_point(my_path, _new_route[i].x, _new_route[i].y, 100);
	            }
				// start new path ensuring absolute is true
				// the first point is our current pos to prevent jumping
				path_set_closed(my_path, false);
				path_start(my_path, move_speed, path_action_stop, true);
				
				current_state = "DRIVE_AND_STOP";
			} else {
				show_message("_new_route is zero");
			}
		}
	} break;
}