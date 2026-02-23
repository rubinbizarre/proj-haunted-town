///@desc the routine brain
// loosely copied from obj_par_npc user_event[0] event

// get the current schedule for nev
var _schedule = variable_struct_get(global.routines, "nev");
var _time = global.current_time_;

// find which part of the routine we are currently in
var _new_state = "";
for (var i = 0; i < array_length(_schedule); i++) {
    var _entry = _schedule[i];
    if (_time >= _entry.start) and (_time < _entry.dest) {
        _new_state = _entry.state;
        break;
    }
}

if (_new_state != current_state) {
    current_state = _new_state;
	circuit_start = false;
    
    // determine target coordinates based on state
    switch (current_state) {
		case "RETURN_HOME": {
			// if we're already home, do nothing
			if (x == home_id.x) or (y == home_id.y) {
				// nothing
			} else {
				// if not home, set home xy as target xy
				target_x = home_id.x;
				target_y = home_id.y;
			}
		} break;
		case "OUT": {
			// a path from home to somewhere along a path between two obj_node_nev_van nodes
			// avoiding points where NPCs cross the road
			//		this may be achieved by making sure that the target pos is within certain ranges
			
			// store start coords to include in path
			var _start_x = x;
			var _start_y = y;
			var _node_ref = obj_node_nev_van;
			// find nearest obj_node_nev_van and store its x,y coords
			var _nearest_node = instance_nearest(x, y, _node_ref);
			target_x = _nearest_node.x;
			target_y = _nearest_node.y;
			
			path_add_point(my_path, _start_x, _start_y, 100);
			path_add_point(my_path, target_x, target_y, 100);
			
			var _start_val = _nearest_node.node_id;
			var _total_elements = instance_number(_node_ref);
			var _id_arr_sort = array_create(_total_elements);
			// loop through the array entirely
			for (var i = 0; i < _total_elements; i++) {
				// insert the values incrementally starting from start_val
				_id_arr_sort[i] = (_start_val + i) % _total_elements;
			}
			// add all node points to path in the right order
			for (var j = 0; j < array_length(_id_arr_sort); j++) {
				for (var i = 0; i < instance_number(_node_ref); i++) {
					var _node_inst = instance_find(_node_ref, i);
					if (_node_inst.node_id == _id_arr_sort[j]) {
						path_add_point(my_path, _node_inst.x, _node_inst.y, 100);
						show_debug_message("obj_nev_van USER_EVENT[0]: "+string(id)+" added point to my_path ("+string(j)+") | node_id:"+string(_node_inst.node_id));
					}
				}
			}
			// add the first node again (nearest node at start)
			path_add_point(my_path, target_x, target_y, 100);
		} break;
	}
	// start the path
	path_start(my_path, move_speed, path_action_stop, true);
}
