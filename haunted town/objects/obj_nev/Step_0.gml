if (depth != -y) depth = -y;

//#region in regular intervals check for detections of haunted world objects nearby within detect_radius
//if (check_timer-- <= 0) {
//	check_timer = check_interval;
	
//	var _temp_list = ds_list_create();
//    var _num = collision_circle_list(x, y, detect_radius, obj_par_world_objects, false, true, _temp_list, false);
    
//    for (var i = 0; i < _num; i++) {
//        var _inst = _temp_list[| i];
        
//        // CRITERIA:
//		//		is it haunted? 
//        // AND: is it NOT already in our queue? 
//        // AND: is it NOT our current active target?
//        if (_inst.haunted == true) and (!array_contains(todo_queue, _inst)) and (_inst != current_target) {
//            array_push(todo_queue, _inst);
//			show_debug_message("obj_nev STEP: pushed inst to todo_queue ("+string(array_length(todo_queue))+" total): "+string(_inst.id));
//        }
//    }
//    ds_list_destroy(_temp_list);
//}
//#endregion

//#region task management: if nev is idle and has more targets to visit, grab the next task
//if (current_target == noone) and (array_length(todo_queue) > 0) {
//    // pop the first item from the start of the array (queue behaviour)
//    current_target = todo_queue[0];
//	var _inst = array_get(todo_queue, 0);
//    show_debug_message("obj_nev STEP: removed inst from todo_queue: "+string(_inst.id));
//	array_delete(todo_queue, 0, 1);
//	var _arr_length = array_length(todo_queue);
//	if (_arr_length > 0) {
//		show_debug_message("obj_nev STEP: todo_queue now contains "+string(_arr_length)+" total");
//	} else {
//		show_debug_message("obj_nev STEP: todo_queue is empty");
//	}
//    // start movement logic (using your van's pathfinding or a simple move_to)
//    // For example: path_to_instance(current_target); 
//}
//#endregion

//#region visit logic: is nev done visiting somewhere? check if we arrived at the target
//if (current_target != noone) {
//    if (point_distance(x, y, current_target.x, current_target.y) <= 1) {
//        // PERFORM THE ACTION
//        //current_target.haunted = false; // "Cleanse" the object
        
//        // RESET: set target to noone so the task management logic above picks a new task next frame
//        current_target = noone;
//    }
//}
//#endregion

#region animation & sprite flipping logic
if (path_index != -1) {
	// if moving/on a path, face the direction of movement
	image_xscale = (direction > 90 and direction < 270) ? -scale_init : scale_init;
	// sprite flipping and location swapping for Nev's gear
	if (instance_exists(gear)) {
		gear.image_xscale = (direction > 90 and direction < 270) ? -1 : 1;
		gear.x = (direction > 90 and direction < 270) ? x - 8 : x + 8;
		gear.y = y - 26;
		gear.depth = depth - 1;
	}
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

switch (current_state) {
	case "LEAVING_VAN": {
		if (x == target_x) and (y == target_y) {
			// nev reached the nearest path node.
			// now he should use the same mp_grid as npcs while moving toward his destination
			// change state
			current_state = "APPROACH_POI";
			// temporary destination assignment obj_wo_trashcan - this could be any object
			// using a do...until in order to prevent target pos being inside a collision obj,
			// which results in nev not moving
			do {
				target_x = obj_wo_trashcan.x + irandom_range(-obj_wo_trashcan.haunt_radius, obj_wo_trashcan.haunt_radius);
				target_y = obj_wo_trashcan.y + irandom_range(-obj_wo_trashcan.haunt_radius, obj_wo_trashcan.haunt_radius);
			} until (!place_meeting(target_x, target_y, obj_collision));
			// add this point to path
			path_add_point(my_path, target_x, target_y, 100);
			// start moving along path obeying the mp_grid
			if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
				path_start(my_path, move_speed, path_action_stop, true);
		    }
			show_debug_message("obj_nev STEP: started path to POI. total points: "+string(path_get_number(my_path)));
		}
	} break;
	case "APPROACH_POI": {
		if (x == target_x) and (y == target_y) {
			// nev reached the POI.
			// change state
			current_state = "SURVEY_POI";
			// make sure nev's sprite faces the POI
			if (x > obj_wo_trashcan.x) {
				image_xscale = -1;
				gear.x = x - 8;
				gear.image_xscale = -1;
			} else {
				image_xscale = 1;
				gear.x = x + 8;
				gear.image_xscale = 1;
			}
			
			// make gear use/record anim play
			switch (gear_tier) {
				case 0: with instance_create_layer(gear.x, gear.y, "Instances", obj_camera_flash) { depth = other.gear.depth - 1; } break;
			}
			
			// log internally whether this was a gain or loss event
			if (obj_wo_trashcan.haunted) {
				// gain - caught while haunted
				global.daily_sub_gain_event_counter++;
				
				// remove all the HP in escrow
				obj_wo_trashcan.escrow = 0;
				// WIP: ideally this removal should be visible, like seeing all the points being taken away from you
				// make the escrow decrement noticeable
				// make the object call this itself
				//... .remove_escrow();
				//... obj_wo_trashcan.escrow_stolen = true; ?
				
				// play sound (nev caught obj while haunted)
				//...
				// visual feedback
				//...
				
				// once escrow_display has reached zero - wip
				// deactivate and lock the POI/object in question
				obj_wo_trashcan.deactivate();
				obj_wo_trashcan.locked = true;
			} else {
				// loss
				global.daily_sub_loss_event_counter++;
				
				// play sound (nev made a mistake ? or does he think he's winning in the moment?)
				//...
				// visual feedback
				//...
			}
		}
	} break;
	case "SURVEY_POI": {
		// when gear-use-anim finishes playing (basically)
		// go back to the closest circuit node to the van, obeying collision
		if (!instance_exists(obj_camera_flash)) {
			current_state = "RETURN_TO_VAN";
			target_x = return_path_x;
			target_y = return_path_y;
			path_add_point(my_path, target_x, target_y, 100);
			// start moving along path obeying the mp_grid
			if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
				path_start(my_path, move_speed, path_action_stop, true);
			}
		}
	} break;
	case "RETURN_TO_VAN": {
		if (x == target_x) and (y == target_y) {
			// nev reached the nearest path node to the van.
			// now path to the van (return_van_z) ignoring collision
			current_state = "GET_IN_VAN";
			target_x = return_van_x;
			target_y = return_van_y;
			path_clear_points(my_path);
			path_add_point(my_path, x, y, 100);
			path_add_point(my_path, target_x, target_y, 100);
			path_start(my_path, move_speed, path_action_stop, true);
		}
	} break;
	case "GET_IN_VAN": {
		if (x == target_x) and (y == target_y) {
			// nev reached the van.
			// signal to van to start moving again after short delay
			obj_nev_van.alarm[1] = game_get_speed(gamespeed_fps) * 1;
			// now 'get in'
			instance_destroy(gear);
			instance_destroy();
			
		}
	} break;
}

/*
if (record_event) {
	// change sprite (use equipment to record anim)
	// play sound
	// remove any existing path, idle for a moment
	// after say 4 secs, go back to van
}
*/