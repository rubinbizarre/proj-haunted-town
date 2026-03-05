if (depth != -y) depth = -y;

#region animation & sprite flipping logic
if (path_index != -1) and (current_state != "SURVEY_POI") {
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
	//if (path_speed != move_speed_rush) {
	//	path_speed = move_speed_init * obj_manager_time.time_speed_actual;
	//} else {
	//	path_speed = move_speed_rush * obj_manager_time.time_speed_actual;
	//}
	path_speed = move_speed_init * obj_manager_time.time_speed_actual;
}

#region old switch (current_state) block (may contain useful comments) (commented)
//switch (current_state) {
//	case "LEAVING_VAN": {
//		if (point_distance(x, y, target_x, target_y) < 2) {
//			// nev reached the nearest path node.
//			// now he should use the same mp_grid as npcs while moving toward his destination
//			// change state
//			current_state = "APPROACH_POI";
//			// temporary destination assignment obj_wo_trashcan - this could be any object
//			// using a do...until in order to prevent target pos being inside a collision obj,
//			// which results in nev not moving
//			do {
//				target_x = obj_wo_trashcan.x + irandom_range(-obj_wo_trashcan.haunt_radius, obj_wo_trashcan.haunt_radius);
//				target_y = obj_wo_trashcan.y + irandom_range(-obj_wo_trashcan.haunt_radius, obj_wo_trashcan.haunt_radius);
//			} until (!place_meeting(target_x, target_y, obj_collision));
//			// add this point to path
//			path_add_point(my_path, target_x, target_y, 100);
//			// start moving along path obeying the mp_grid
//			if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
//				path_start(my_path, move_speed, path_action_stop, true);
//		    }
//			show_debug_message("obj_nev STEP: started path to POI. total points: "+string(path_get_number(my_path)));
//		}
//	} break;
//	case "APPROACH_POI": {
//		if (point_distance(x, y, target_x, target_y) < 2) {
//			// nev reached the POI.
//			// change state
//			current_state = "SURVEY_POI";
//			// make sure nev's sprite faces the POI
//			if (x > obj_wo_trashcan.x) {
//				image_xscale = -1;
//				gear.x = x - 8;
//				gear.image_xscale = -1;
//			} else {
//				image_xscale = 1;
//				gear.x = x + 8;
//				gear.image_xscale = 1;
//			}
			
//			// make gear use/record anim play
//			switch (gear_tier) {
//				case 0: with instance_create_layer(gear.x, gear.y, "Instances", obj_camera_flash) { depth = other.gear.depth - 1; } break;
//			}
			
//			// log internally whether this was a gain or loss event
//			if (obj_wo_trashcan.haunted) {
//				// gain - caught while haunted
//				global.daily_sub_gain_event_counter++;
				
//				// remove all the HP in escrow
//				obj_wo_trashcan.escrow = 0;
//				// WIP: ideally this removal should be visible, like seeing all the points being taken away from you
//				// make the escrow decrement noticeable
//				// make the object call this itself
//				//... .remove_escrow();
//				//... obj_wo_trashcan.escrow_stolen = true; ?
				
//				// play sound (nev caught obj while haunted)
//				//...
//				// visual feedback
//				//...
				
//				// once escrow_display has reached zero - wip
//				// deactivate and lock the POI/object in question
//				obj_wo_trashcan.deactivate();
//				obj_wo_trashcan.locked = true;
//			} else {
//				// loss
//				global.daily_sub_loss_event_counter++;
				
//				// play sound (nev made a mistake ? or does he think he's winning in the moment?)
//				//...
//				// visual feedback
//				//...
//			}
//		}
//	} break;
//	case "SURVEY_POI": {
//		// when gear-use-anim finishes playing (basically)
//		// go back to the closest circuit node to the van, obeying collision
//		if (!instance_exists(obj_camera_flash)) {
//			current_state = "RETURN_TO_VAN";
//			target_x = return_path_x;
//			target_y = return_path_y;
//			path_add_point(my_path, target_x, target_y, 100);
//			// start moving along path obeying the mp_grid
//			if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
//				path_start(my_path, move_speed, path_action_stop, true);
//			}
//		}
//	} break;
//	case "RETURN_TO_VAN": {
//		if (point_distance(x, y, target_x, target_y) < 2) {
//			// nev reached the nearest path node to the van.
//			// now path to the van (return_van_z) ignoring collision
//			current_state = "GET_IN_VAN";
//			target_x = return_van_x;
//			target_y = return_van_y;
//			path_clear_points(my_path);
//			path_add_point(my_path, x, y, 100);
//			path_add_point(my_path, target_x, target_y, 100);
//			path_start(my_path, move_speed, path_action_stop, true);
//		}
//	} break;
//	case "GET_IN_VAN": {
//		if (point_distance(x, y, target_x, target_y) < 2) {
//			// nev reached the van.
//			// signal to van to start moving again after short delay
//			obj_nev_van.alarm[1] = game_get_speed(gamespeed_fps) * 1;
//			// now 'get in'
//			instance_destroy(gear);
//			instance_destroy();
			
//		}
//	} break;
//}
#endregion

// --- SCANNING LOGIC ---
//// only scan if we are out of the van (existing) and don't have too many tasks already
//if (instance_exists(self)) and (array_length(todo_queue) < 5) {
	if (check_timer-- <= 0) { // periodic
		check_timer = check_interval;
	    var _temp_list = ds_list_create();
	    var _num = collision_circle_list(x, y, global.nev_detect_radius, obj_par_world_objects, false, true, _temp_list, false);
    
	    for (var i = 0; i < _num; i++) {
	        var _inst = _temp_list[| i];
	        // if it's haunted, not already queued, and not our current focus, and not locked
	        if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (!_inst.locked) {
	            array_push(global.nev_todo_queue, _inst);
				show_debug_message("obj_nev STEP: "+current_state+": pushed inst to todo_queue ("+string(array_length(global.nev_todo_queue))+" total): "+string(_inst.id));
	        }
	    }
	    ds_list_destroy(_temp_list);
	}
//}

// --- STATE MACHINE ---
switch (current_state) {
    case "LEAVING_VAN": {
		// if nev has reached the nearest path circuit node
		if (point_distance(x, y, target_x, target_y) < 2) {
            if (array_length(global.nev_todo_queue) > 0) {
				// pick the first target from our queue
				//		might make more sense to pick the closest queue item to nev instead
				sort_todo_queue_by_distance();
				show_debug_message("obj_nev STEP: "+current_state+": sorted todo_queue by distance.");
				
                global.nev_current_target = global.nev_todo_queue[0];
				show_debug_message("obj_nev STEP: "+current_state+": selected target "+string(global.nev_current_target)+" from todo_queue to approach.");
				
				// remove this target from the todo_queue
                array_delete(global.nev_todo_queue, 0, 1);
                current_state = "APPROACH_POI";
                
                // calculate random approach point around the GENERIC current_target
                do {
                    target_x = global.nev_current_target.x + irandom_range(-global.nev_current_target.haunt_radius, global.nev_current_target.haunt_radius);
                    target_y = global.nev_current_target.y + irandom_range(-(global.nev_current_target.haunt_radius/2.5), (global.nev_current_target.haunt_radius/2.5));
                } until (!place_meeting(target_x, target_y, obj_collision));

                path_clear_points(my_path);
                if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
                    path_start(my_path, move_speed, path_action_stop, true);
                }
            } else {
				show_debug_message("obj_nev STEP: "+current_state+": todo_queue is empty, returning to van.");
                // if the van dropped us off but the queue is empty, just go back
                current_state = "RETURN_TO_VAN";
            }
        }
    } break;
    case "APPROACH_POI": {
        // small distance threshold instead of exact == for more reliable triggers
        if (point_distance(x, y, target_x, target_y) < 2) {
			show_debug_message("obj_nev STEP: "+current_state+": now switching to surveying the POI.");
            current_state = "SURVEY_POI";
            
            //// face the current generic target
            //image_xscale = (x > current_target.x) ? -1 : 1;
			
			// make sure nev's sprite faces the POI
			if (x > global.nev_current_target.x) {
				image_xscale = -1;
				gear.x = x - 8;
				gear.image_xscale = -1;
			} else {
				image_xscale = 1;
				gear.x = x + 8;
				gear.image_xscale = 1;
			}
			
            //gear.x = x + (8 * image_xscale);
            //gear.image_xscale = image_xscale;
            
            // gear logic
            if (gear_tier == 0) {
                with instance_create_layer(gear.x, gear.y, "Master", obj_camera_flash) { 
                    depth = other.gear.depth - 1; 
                }
				// play sound (camera in use)
				//...
            }
            
            // interaction logic
            if (global.nev_current_target.haunted) {
                global.daily_sub_gain_event_counter++;
                global.nev_current_target.escrow = 0;
                global.nev_current_target.deactivate();
                global.nev_current_target.locked = true;
                // play sound (nev caught obj while haunted)
				//...
				// visual feedback
				//...
				show_debug_message("obj_nev STEP: "+current_state+": sub gain event. total sub gains today: "+string(global.daily_sub_gain_event_counter));
            } else {
                global.daily_sub_loss_event_counter++;
				// play sound (nev made a mistake ? or does he think he's winning in the moment?)
				//...
				// visual feedback
				//...
				show_debug_message("obj_nev STEP: "+current_state+": sub loss event. total sub losses today: "+string(global.daily_sub_loss_event_counter));
            }
        }
    } break;
    case "SURVEY_POI": {
        if (!instance_exists(obj_camera_flash)) {
            // DECISION GATE: check if there's more to do before going back to the van
            if (array_length(global.nev_todo_queue) > 0) {
				show_debug_message("obj_nev STEP: "+current_state+": there's more to do before returning to the van.");
                // go to the next POI in the list 
				//		 might be good to order the list by distance here also !!!
				sort_todo_queue_by_distance();
				show_debug_message("obj_nev STEP: "+current_state+": sorted todo_queue by distance.");
				
                global.nev_current_target = global.nev_todo_queue[0];
				show_debug_message("obj_nev STEP: "+current_state+": new current_target: "+string(global.nev_current_target.id));
				
				show_debug_message("obj_nev STEP: "+current_state+": removed inst from todo_queue: "+string(global.nev_current_target.id));
                array_delete(global.nev_todo_queue, 0, 1);
				
				var _arr_length = array_length(global.nev_todo_queue);
				if (_arr_length > -1) {
					show_debug_message("obj_nev STEP: "+current_state+": todo_queue now contains "+string(_arr_length + 1)+" POIs total");
				}

                current_state = "APPROACH_POI";
                
                do {
                    target_x = global.nev_current_target.x + irandom_range(-global.nev_current_target.haunt_radius, global.nev_current_target.haunt_radius);
                    target_y = global.nev_current_target.y + irandom_range(-(global.nev_current_target.haunt_radius/2.5), (global.nev_current_target.haunt_radius/2.5));
                } until (!place_meeting(target_x, target_y, obj_collision));
				
                path_clear_points(my_path);
                if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
                    path_start(my_path, move_speed, path_action_stop, true);
                }
            } else {
                // no more tasks? finally return to the van
				show_debug_message("obj_nev STEP: "+current_state+": no more tasks. returning to van!");
                
				current_state = "RETURN_TO_VAN";
                target_x = return_path_x;
                target_y = return_path_y;
                
				path_clear_points(my_path);
				
				// reset global.nev_current_target
				global.nev_current_target = noone;
				
                if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
                    path_start(my_path, move_speed, path_action_stop, true);
                }
            }
        }
    } break;
    case "RETURN_TO_VAN": {
        if (point_distance(x, y, target_x, target_y) < 2) {
			show_debug_message("obj_nev STEP: "+current_state+": getting into the van.");
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
        if (point_distance(x, y, target_x, target_y) < 2) {
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