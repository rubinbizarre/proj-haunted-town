if (depth != -y) depth = -y;

#region animation & sprite flipping logic
if (path_index != -1) and (current_state != "SURVEY_POI") {
//if (current_state != "SURVEY_POI") and (current_state != "LEAVING_VAN") {
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
	if (check_timer-- <= 0) { // periodic check for haunted-world-objects
		check_timer = check_interval;
		#region check for haunted world objects only - working (commented)
	    //var _temp_list = ds_list_create();
	    //var _num = collision_circle_list(x, y, global.nev_detect_radius, obj_par_world_objects, false, true, _temp_list, false);
    
	    //for (var i = 0; i < _num; i++) {
	    //    var _inst = _temp_list[| i];
	    //    // if it's haunted, not already queued, and not our current focus, and not locked
	    //    if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (!_inst.locked) {
	    //        array_push(global.nev_todo_queue, _inst);
		//		show_debug_message("obj_nev STEP: "+current_state+": pushed inst to todo_queue ("+string(array_length(global.nev_todo_queue))+" total): "+string(_inst.id));
	    //    }
	    //}
	    //ds_list_destroy(_temp_list);
		#endregion
		
		check_for_paranormal_nev();
		
		if (following) {
			show_debug_message("obj_nev STEP: executing move_along_path_to_target() (nev is following) ...");
			move_along_path_to_target(global.nev_current_target);
		}
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
                
				show_debug_message("obj_nev STEP: executing move_along_path_to_target() ...");
				move_along_path_to_target(global.nev_current_target);
				
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
			
            #region interaction logic per object type
			var _target = global.nev_current_target;
			
			// interact with npc
			if (object_is_ancestor(_target.object_index, obj_par_npc)) {
				
				show_debug_message("obj_nev STEP: "+current_state+": interacting with npc");
				survey_action();
				
				if (global.nev_current_target.possessed) {
					obj_manager_nev.gain_subs(_target.name_str, _target.note_str_credit);
					_target.remove_possession();
					// play sound (nev caught obj while haunted)
					//...
					show_debug_message("obj_nev STEP: "+current_state+": sub gain event. total sub gains today: "+string(global.daily_sub_gain_event_counter));
				} else {
					obj_manager_nev.lose_subs(_target.name_str, _target.note_str_discredit);
					// play sound (nev made a mistake ? or does he think he's winning in the moment?)
					//...
					show_debug_message("obj_nev STEP: "+current_state+": sub loss event. total sub losses today: "+string(global.daily_sub_loss_event_counter));
				}
			// interact with scary-object
			} else if (object_is_ancestor(_target.object_index, obj_par_scary_objects)) {
				
				show_debug_message("obj_nev STEP: "+current_state+": interacting with scary-object");
				survey_action();
				
				if (global.nev_current_target.haunted) {
	                obj_manager_nev.gain_subs(_target.name_str, _target.note_str_credit);
					// if caught mid-deactivate, disable deactivate
					if (_target.deactivate_active) {
						_target.deactivate_active = false;
						_target.deactivate_timer = _target.deactivate_timer_init;
					}
					_target.deactivate();
	                _target.locked = true;
					_target.mouse_hover = false;
					_target.image_index = 0;
					//_target = global.nev_current_target;
					var _b = _target.current_building;
					_b.haunted = false;
					_b.infamy = 0;
					// play sound (nev caught obj while haunted)
					//...
					// visual feedback (some sort of bounce anim)
					//...
				} else {
					obj_manager_nev.lose_subs(_target.name_str, _target.note_str_discredit);
					// play sound (nev made a mistake ? or does he think he's winning in the moment?)
					//...
					// visual feedback
					//...
					show_debug_message("obj_nev STEP: "+current_state+": sub loss event. total sub losses today: "+string(global.daily_sub_loss_event_counter));
				}
			// interact with world-object
			} else if (object_is_ancestor(_target.object_index, obj_par_world_objects)) {
				
				// if we have only just reached the nearest path node,
				// now directly path to a spot beside the world-object
				if (instance_nearest(x, y, obj_node_circuit)) and (!off_path) {
					var _xoffset = _target.haunt_radius/1.5;
					var _yoffset = _target.haunt_radius/3;
					
					target_x = _target.x + irandom_range(-_xoffset, _xoffset);
					target_y = _target.y + irandom_range(-_yoffset, _yoffset);
					
					path_clear_points(my_path);
					path_add_point(my_path, x, y, 100);
					path_add_point(my_path, target_x, target_y, 100);
					path_start(my_path, move_speed, path_action_stop, true);
					
					off_path = true;
					
					show_debug_message("obj_nev STEP: "+current_state+": now pathing directly to spot beside world-object");
				} else {
				
					show_debug_message("obj_nev STEP: "+current_state+": now interacting with world-object");
					survey_action();
				
		            if (_target.haunted) {
		                obj_manager_nev.gain_subs(_target.name_str, _target.note_str_credit);
						// if caught mid-deactivate, disable deactivate
						if (_target.deactivate_active) {
							_target.deactivate_active = false;
							_target.deactivate_timer = _target.deactivate_timer_init;
						}
		                _target.deactivate();
		                _target.locked = true;
						_target.mouse_hover = false;
						_target.nev_taking_escrow = true;
						_target.escrow = 0;
						_target.image_index = 0;
		                // play sound (nev caught obj while haunted)
						//...
						// visual feedback (some sort of bounce anim)
						//...
						show_debug_message("obj_nev STEP: "+current_state+": sub gain event. total sub gains today: "+string(global.daily_sub_gain_event_counter));
		            } else {
		                obj_manager_nev.lose_subs(_target.name_str, _target.note_str_discredit);
						// play sound (nev made a mistake ? or does he think he's winning in the moment?)
						//...
						// visual feedback
						//...
						show_debug_message("obj_nev STEP: "+current_state+": sub loss event. total sub losses today: "+string(global.daily_sub_loss_event_counter));
		            }
				}
			// interact with building
			} else if (object_is_ancestor(_target.object_index, obj_par_building)) {
				//if (global.nev_current_target.haunted) {
					target_x = 0;
					target_y = 0;
					
					enter_building();
					show_debug_message("obj_nev STEP: "+current_state+": entering building");
					
					var _prev_todo_length = array_length(global.nev_todo_queue);
					
					check_for_paranormal_nev();
					
					var _new_todo_length = array_length(global.nev_todo_queue);
					if (_new_todo_length > _prev_todo_length) {
						current_state = "SURVEY_POI";
						finished_surveying = true;
						show_debug_message("obj_nev STEP: "+current_state+": POI detected upon entering.");
					} else {
						show_debug_message("obj_nev STEP: "+current_state+": nothing detected initially when entering...");
					}
				//}
			}
			#endregion
        }
    } break;
    case "SURVEY_POI": {
        if (finished_surveying) {
			
			// if target is world-object, stop displaying the world-object's escrow amount
			if (global.nev_current_target != noone) {
				var _target = global.nev_current_target;	
				if (object_is_ancestor(_target.object_index, obj_par_world_objects)) {
					if (_target.nev_taking_escrow) _target.nev_taking_escrow = false;
				}
			}
			
            // DECISION GATE: check if there's more to do before going back to the van
            if (array_length(global.nev_todo_queue) > 0) {
				show_debug_message("obj_nev STEP: "+current_state+": there's more to do before returning to the van.");
                // go to the next POI in the list 
				//		 might be good to order the list by distance here also !!!
				sort_todo_queue_by_distance();
				show_debug_message("obj_nev STEP: "+current_state+": sorted todo_queue by distance.");
				
                global.nev_current_target = global.nev_todo_queue[0];
				show_debug_message("obj_nev STEP: "+current_state+": new current_target: "+string(global.nev_current_target.id)+" | removed inst from todo_queue.");
				
				//show_debug_message("obj_nev STEP: "+current_state+": removed inst from todo_queue: "+string(global.nev_current_target.id));
                //array_delete(global.nev_todo_queue, 0, 1);
				
				var _arr_length = array_length(global.nev_todo_queue);
				if (_arr_length > -1) {
					show_debug_message("obj_nev STEP: "+current_state+": todo_queue now contains "+string(_arr_length)+" POIs total");
				}
				
				var _target = global.nev_current_target;
				
				if (_target.x > 20000) { // nev has another target in this building
					current_state = "APPROACH_POI";
					// move nev to target directly without collision
					var _xoffset = 30/1.5;
					var _yoffset = 30/3;
					target_x = _target.x + irandom_range(-_xoffset, _xoffset);
					target_y = _target.y + irandom_range(_target.y, _yoffset);
					path_clear_points(my_path);
		            path_add_point(my_path, x, y, 100);
		            path_add_point(my_path, target_x, target_y, 100);
		            path_start(my_path, move_speed, path_action_stop, true);
					
					array_delete(global.nev_todo_queue, 0, 1);
					
				} else { // nev has another target that is outside
					
					if (is_inside) leave_building();
					
					// before moving to target along path obeying collision,
					// if off_path, move back on to the path first
					if (current_state != "RETURN_TO_PATH") {
						var _path_node = instance_nearest(x, y, obj_node_circuit);
						target_x = _path_node.x;
						target_y = _path_node.y;
						path_clear_points(my_path);
						path_add_point(my_path, x, y, 100);
						path_add_point(my_path, target_x, target_y, 100);
						path_start(my_path, move_speed, path_action_stop, true);
						off_path = false;
						show_debug_message("obj_nev STEP: "+current_state+": more tasks to do - returning to path");
						current_state = "RETURN_TO_PATH";
					}
				}
            } else {
				// no more tasks? finally return to the van
                
				if (is_inside) leave_building();
				
				if (current_state != "RETURN_TO_PATH") {
					var _path_node = instance_nearest(x, y, obj_node_circuit);
					target_x = _path_node.x;
					target_y = _path_node.y;
					path_clear_points(my_path);
					path_add_point(my_path, x, y, 100);
					path_add_point(my_path, target_x, target_y, 100);
					path_start(my_path, move_speed, path_action_stop, true);
					//off_path = false;
					show_debug_message("obj_nev STEP: "+current_state+": no more tasks! returning to path");
					current_state = "RETURN_TO_PATH";
				}
            }
        }
    } break;
	case "RETURN_TO_PATH": {
		if (array_length(global.nev_todo_queue) > 0) {
			// more tasks to do - approach next POI
			if (point_distance(x, y, target_x, target_y) < 2) and (current_state != "APPROACH_POI") {
				current_state = "APPROACH_POI";
				show_debug_message("obj_nev STEP: "+current_state+": more tasks to do - now approaching next POI");
				var _target = global.nev_current_target;
				move_along_path_to_target(_target);
				array_delete(global.nev_todo_queue, 0, 1);
			}
		} else {
			// no more tasks - return to van
			if (point_distance(x, y, target_x, target_y) < 2) and (current_state != "RETURN_TO_VAN") {
				current_state = "RETURN_TO_VAN";
			    target_x = return_path_x;
			    target_y = return_path_y;
                
				path_clear_points(my_path);
				
				// reset global.nev_current_target
				global.nev_current_target = noone;
				
			    if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
			        path_start(my_path, move_speed, path_action_stop, true);
			    }
				show_debug_message("obj_nev STEP: "+current_state+": no more tasks. returning to van!");
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
            //instance_destroy(gear);
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

// make nev reset his behaviour if target npc goes into a building
// note: alternatively, he could follow them inside ???
var _target = global.nev_current_target;
if (_target != noone) {
	if (object_is_ancestor(_target.object_index, obj_par_npc)) {
		if (_target.is_inside) and (current_state != "SURVEY_POI") {
			current_state = "SURVEY_POI";
		}
	}
}

// make ps inst track with nev's pos
if (ps_subs != noone) {
	if (instance_exists(ps_subs)) {
		ps_subs.x = x;
		ps_subs.y = y - sprite_get_height(sprite_index);
	}
}