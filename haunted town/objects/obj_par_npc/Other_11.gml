var _schedule = variable_struct_get(global.routines, routine_type);		
var _time = global.current_time_;										

if (global.day_counter == 6) {
	_schedule = variable_struct_get(global.routines_sunday, routine_type);
}

// find which part of the routine we are currently in
var _new_state = "";
for (var i = 0; i < array_length(_schedule); i++) {
    var _entry = _schedule[i];
    if (_time >= _entry.start) and (_time < _entry.dest) {
        _new_state = _entry.state;
        break;
    }
}

if (current_state == _new_state) {
	//show_debug_message("obj_par_npc USER_EVENT(1): "+string(id)+": current_state is the same as _new_state. exiting");
	exit;
}

current_state = _new_state;
//show_debug_message("obj_par_npc USER_EVENT(1): "+string(id)+": "+routine_type+": current_state set to "+current_state);
	
#region // determine target coordinates based on state (commented)
//switch (current_state) {
//	case "INSIDE": {
//		//visible = false;
			
//		//var _building = instance_place(x, y, obj_par_building);
//		//if (_building != noone) {
//		//	// register as occupant inside the building
//		//	array_push(_building.occupants, id);
//		//}
			
//		//var _b = instance_place(x, y, obj_par_building);
			
//		//// register with the building
//		//array_push(_b.occupants, id);
//		//current_building = _b;
//		//is_inside = true;

//		//// teleport to the void
//		//// we add a small offset so they don't all spawn on the exact same pixel
//		//x = _b.interior_x + (interior_width / 2);
//		//y = _b.interior_y + (interior_height / 2);
    
//		//// change to inside behavior
//		//path_end();
//		//current_state = "IDLE_INSIDE";
			
//	} break;
//	case "CIRCUIT": {
//		// store start coords to include in path
//		var _start_x = x;
//		var _start_y = y;
//		// store nearest node coords
//		var _nearest_node = instance_nearest(x, y, obj_node_circuit);
//		target_x = _nearest_node.x;
//		target_y = _nearest_node.y;
//		target_obj = _nearest_node;
			
//		path_add_point(my_path, _start_x, _start_y, 100);
//		path_add_point(my_path, target_x, target_y, 100);
			
//		var _start_val = _nearest_node.node_id;				// starting point value in array
//		var _total_elements = 41;							// total values (0 through 40) (41 nodes but excluding the nearest node)
//		var _id_arr_sort = array_create(_total_elements);	// create an array with 41 slots
//		// loop through the array entirely
//		for (var i = 0; i < _total_elements; i++) {
//			// insert the values incrementally starting from start_val
//			_id_arr_sort[i] = (_start_val + i) % _total_elements;
//		}
//		// add all node points to path in the right order
//		for (var j = 0; j < array_length(_id_arr_sort); j++) {
//			for (var i = 0; i < instance_number(obj_node_circuit); i++) {
//				var _node_inst = instance_find(obj_node_circuit, i);
//				if (_node_inst.node_id == _id_arr_sort[j]) {
//					path_add_point(my_path, _node_inst.x, _node_inst.y, 100);
//					//show_debug_message("obj_par_npc USER_EVENT[0]: "+string(id)+" added point to my_path ("+string(j)+") | node_id:"+string(_node_inst.node_id));
//				}
//			}
//		}
			
//		// add the first node again (nearest node at start)
//		// so that when path movement is complete, npc returns to house cleanly
//		// (idk why it returns to the house i thought it would stop at the node)
//		path_add_point(my_path, target_x, target_y, 100);
//	} break;
//    case "RETURN_HOME": {
//		//visible = true;
//        target_x = home_obj.x;
//        target_y = home_obj.y;
//		//target_obj = home_obj;
//	} break;
//    case "PLAY_PARK": {
//        //visible = true;
//        target_x = obj_node_park.x + irandom_range(-obj_node_park.area, obj_node_park.area);
//        target_y = obj_node_park.y + irandom_range(-obj_node_park.area, obj_node_park.area);
//	} break;
//    case "WANDER_TOWN": {
//        //visible = true;
//        // pick a random building that isn't their home
//		do {
//			target_obj = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
//		} until (target_obj != home_obj);
			
//        target_x = target_obj.x;
//        target_y = target_obj.y; //- (target_obj.sprite_height/4);
			
//		//visible = false; // "enter" the house // this does not work as intended
//	} break;
//	case "WANDER_TOWN_AGAIN": {
//        //visible = true;
//        // pick a random building that isn't their home
//        target_obj = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
//		while (target_obj == home_obj) {
//			target_obj = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
//		}
//        target_x = target_obj.x;
//        target_y = target_obj.y;
//	} break;
//    case "VISIT_HAUNTED": {
//        //visible = true;
//        // logic to find the nearest haunted building
//        // ...
//	} break;
//	case "CHURCH": {
//		//visible = true;
//		if (instance_exists(obj_building_church)) {
//			target_x = obj_building_church.x;
//			target_y = obj_building_church.y;
//		}
//	} break;
//}
#endregion

// if was inside, leave
if (is_inside) {
	// extra conditional to prevent npcs from leaving and entering their home instantaneously
	if (current_state == "RETURN_HOME") and (current_building == home_obj) {
		exit;
	} else if (current_state == "WANDER_TOWN") and (current_building == target_obj) {
		exit;
	} else if (current_state == "WANDER_TOWN_AGAIN") and (current_building == target_obj) {
		exit;
	} else {
		leave_building();
	}
}

switch (current_state) {
	case "CIRCUIT": {
		#region old circuit logic (commented)
		//// store start coords to include in path
		//var _start_x = x;
		//var _start_y = y;
		
		//// store nearest node coords
		//var _nearest_node = instance_nearest(x, y, obj_node_circuit);
		//target_x = _nearest_node.x;
		//target_y = _nearest_node.y;
		//target_obj = _nearest_node;
		
		//// add these points to the path
		//path_add_point(my_path, _start_x, _start_y, 100);
		//path_add_point(my_path, target_x, target_y, 100);
			
		//var _start_val = _nearest_node.node_id;				// starting point value in array
		//var _total_elements = 41;							// total values (0 through 40) (41 nodes but excluding the nearest node)
		//var _id_arr_sort = array_create(_total_elements);	// create an array with 41 slots
		//// loop through the array of circuit nodes entirely
		//for (var i = 0; i < _total_elements; i++) {
		//	// insert the values incrementally starting from start_val
		//	_id_arr_sort[i] = (_start_val + i) % _total_elements;
		//}
		//// add all node points to path in the right order
		//for (var j = 0; j < array_length(_id_arr_sort); j++) {
		//	for (var i = 0; i < instance_number(obj_node_circuit); i++) {
		//		var _node_inst = instance_find(obj_node_circuit, i);
		//		if (_node_inst.node_id == _id_arr_sort[j]) {
		//			path_add_point(my_path, _node_inst.x, _node_inst.y, 100);
		//			//show_debug_message("obj_par_npc USER_EVENT[0]: "+string(id)+" added point to my_path ("+string(j)+") | node_id:"+string(_node_inst.node_id));
		//		}
		//	}
		//}
			
		//// add the first node again (nearest node at start)
		//// so that when path movement is complete, npc returns to house cleanly
		//// (idk why it returns to the house i thought it would stop at the node)
		//// it returned to the house because it was a closed path; i've fixed this now by making my_path open
		//path_add_point(my_path, target_x, target_y, 100);
		#endregion
		
		//// store start coords to include in path
		//var _start_x = x;
		//var _start_y = y;
		
		//// store nearest node coords
		//var _nearest_node = instance_nearest(x, y, obj_node_circuit);
		//target_x = _nearest_node.x;
		//target_y = _nearest_node.y;
		//target_obj = _nearest_node;
		
		//// add these points to the path
		//path_add_point(my_path, _start_x, _start_y, 100);
		//path_add_point(my_path, target_x, target_y, 100);
		
		// pick random node_circuit to navigate to
		var _total_nodes = instance_number(obj_node_circuit) - 1;
		var _rand = irandom_range(1, _total_nodes);
		var _random_node = instance_find(obj_node_circuit, _rand);
		target_x = _random_node.x;
		target_y = _random_node.y;
		target_obj = _random_node;
		//path_add_point(my_path, target_x, target_y, 100);
		
	} break;
	case "RETURN_HOME": {
		target_obj = home_obj;
        target_x = target_obj.x;
        target_y = target_obj.y;
	} break;
    case "PLAY_PARK": {
		target_obj = obj_node_park;
        target_x = target_obj.x + irandom_range(-target_obj.area, target_obj.area);
        target_y = target_obj.y + irandom_range(-target_obj.area, target_obj.area);
	} break;
    case "WANDER_TOWN": {
        // pick a random building that isn't their home
		do {
			target_obj = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1)); // note: is this -1 necessary???
		} until (target_obj != home_obj);
		
        target_x = target_obj.x;
        target_y = target_obj.y;
	} break;
	case "WANDER_TOWN_AGAIN": {
        // pick a random building that isn't their home
        do {
			target_obj = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1)); // note: is this -1 necessary???
		} until (target_obj != home_obj);
		
        target_x = target_obj.x;
        target_y = target_obj.y;
	} break;
    case "VISIT_HAUNTED": {
        // logic to find the nearest/random haunted building
        //...
	} break;
	case "CHURCH": {
		if (instance_exists(obj_building_church)) {
			target_obj = obj_building_church;
			target_x = target_obj.x;
			target_y = target_obj.y;
		}
	} break;
}

//if (current_state == "CIRCUIT") {
//	path_start(my_path, move_speed, path_action_stop, true);
//	//show_debug_message("obj_par_npc USER_EVENT[1]: "+string(id)+" type:"+string(routine_type)+" | circuit path started.");
//} else if (current_state != "") {
	if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
		path_start(my_path, move_speed, path_action_stop, true);
	}
//	//show_debug_message("obj_par_npc USER_EVENT[1]: "+string(id)+" type:"+string(routine_type)+" | path started.");
//}