///@desc the routine brain

// get the current schedule based on the NPC's type
var _schedule = variable_struct_get(global.routines, routine_type);		// e.g. global.routines.adult
var _time = global.current_time_;										// e.g. 480

// if we're on Sunday, do sunday routine instead
if (global.day_counter == 6) {
	_schedule = variable_struct_get(global.routines_sunday, routine_type);
}

// find which part of the routine we are currently in
var _new_state = "";
for (var i = 0; i < array_length(_schedule); i++) {						// loop through states for this routine type. arr_length of global.routines.adult (3 (0,1,2,3))
    var _entry = _schedule[i];											// _entry = global.routines.adult[0] {start, dest, state}
    if (_time >= _entry.start) and (_time < _entry.dest) {				// compares time to AT_HOME start and dest(end)
	//if (_time >= _entry.start) and (_time < _schedule[i+1].start) {
        _new_state = _entry.state;										// _new_state = AT_HOME state ("AT_HOME")
        break;
    }
}

// if our state has changed, do x once (e.g. find a new destination, set a path)
if (_new_state != current_state) {
    current_state = _new_state;
	circuit_start = false;
    
    // determine target coordinates based on state
    switch (current_state) {
		case "INSIDE": {
			visible = false;
		} break;
		case "CIRCUIT": {
			// store start coords to include in path
			var _start_x = x;
			var _start_y = y;
			// store nearest node coords
			var _nearest_node = instance_nearest(x, y, obj_node_circuit);
			target_x = _nearest_node.x;
			target_y = _nearest_node.y;
			
			path_add_point(my_path, _start_x, _start_y, 100);
			path_add_point(my_path, target_x, target_y, 100);
			
			var _start_val = _nearest_node.node_id;				// starting point value in array
			var _total_elements = 41;							// total values (0 through 40) (41 nodes but excluding the nearest node)
			var _id_arr_sort = array_create(_total_elements);	// create an array with 41 slots
			// loop through the array entirely
			for (var i = 0; i < _total_elements; i++) {
				// insert the values incrementally starting from start_val
				_id_arr_sort[i] = (_start_val + i) % _total_elements;
			}
			// add all node points to path in the right order
			for (var j = 0; j < array_length(_id_arr_sort); j++) {
				for (var i = 0; i < instance_number(obj_node_circuit); i++) {
					var _node_inst = instance_find(obj_node_circuit, i);
					if (_node_inst.node_id == _id_arr_sort[j]) {
						path_add_point(my_path, _node_inst.x, _node_inst.y, 100);
						//show_debug_message("obj_par_npc USER_EVENT[0]: "+string(id)+" added point to my_path ("+string(j)+") | node_id:"+string(_node_inst.node_id));
					}
				}
			}
			
			// add the first node again (nearest node at start)
			// so that when path movement is complete, npc returns to house cleanly
			// (idk why it returns to the house i thought it would stop at the node)
			path_add_point(my_path, target_x, target_y, 100);
		} break;
        case "RETURN_HOME": {
			visible = true;
            target_x = home_id.x;
            target_y = home_id.y;
		} break;
        case "PLAY_PARK": {
            visible = true;
            target_x = obj_node_park.x + irandom_range(-obj_node_park.park_spawn_area, obj_node_park.park_spawn_area);
            target_y = obj_node_park.y + irandom_range(-obj_node_park.park_spawn_area, obj_node_park.park_spawn_area);
		} break;
        case "WANDER_TOWN": {
            visible = true;
            // pick a random building that isn't their home
			do {
				dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			} until (dest_id != home_id);
			
            target_x = dest_id.x;
            target_y = dest_id.y; //- (dest_id.sprite_height/4);
			
			//visible = false; // "enter" the house // this does not work as intended
		} break;
		case "WANDER_TOWN_AGAIN": {
            visible = true;
            // pick a random building that isn't their home
            dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			while (dest_id == home_id) {
				dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			}
            target_x = dest_id.x;
            target_y = dest_id.y;
		} break;
        case "VISIT_HAUNTED": {
            visible = true;
            // logic to find the nearest haunted building
            // ...
		} break;
		case "CHURCH": {
			visible = true;
			if (instance_exists(obj_building_church)) {
				target_x = obj_building_church.x;
				target_y = obj_building_church.y;
			}
		} break;
    }
    
    //// If we are visible, start moving to the target
    //if (visible) {
    //    if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
    //        path_start(my_path, move_speed, path_action_stop, true);
    //    }
	//	show_debug_message("obj_par_npc USER_EVENT[0]: "+string(id)+" path started.");
    //} else {
	//	// THIS BASICALLY NEVER FIRES BECAUSE WHY WOULD WE MAKE THEM NOT VISIBLE
	//	// THE FLAG INVOLVED HERE NEEDS TO CHANGE
    //    path_end();
    //    x = target_x;
    //    y = target_y;
	//	show_debug_message("obj_par_npc USER_EVENT[0]: "+string(id)+" path ended.");
    //}
	
	if (current_state == "CIRCUIT") {
		path_start(my_path, move_speed, path_action_stop, true);
		//show_debug_message("obj_par_npc USER_EVENT[0]: "+string(id)+" type:"+string(routine_type)+" | circuit path started.");
	} else if (current_state != "") {
		if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
			path_start(my_path, move_speed, path_action_stop, true);
	    }
		//show_debug_message("obj_par_npc USER_EVENT[0]: "+string(id)+" type:"+string(routine_type)+" | path started.");
	}
}