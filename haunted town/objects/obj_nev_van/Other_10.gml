///@desc the routine brain
// loosely copied from obj_par_npc user_event[0] event

// get the current schedule for nev
var _schedule = variable_struct_get(global.routines, "van");
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
			var _node_ref = obj_node_road;
			
			// find nearest obj_node_nev_van and store its x,y coords
			var _nearest_node = instance_nearest(x, y, _node_ref);
			target_x = _nearest_node.x;
			target_y = _nearest_node.y;
			
			path_add_point(my_path, _start_x, _start_y, 100);
			path_add_point(my_path, target_x, target_y, 100);
			
			var _start_val = _nearest_node.node_id;
			var _total_nodes = instance_number(_node_ref);
			var _id_arr_sort = array_create(_total_nodes);
			// loop through the array entirely
			for (var i = 0; i < _total_nodes; i++) {
				// insert the values incrementally starting from start_val
				_id_arr_sort[i] = (_start_val + i) % _total_nodes;
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
		case "LEAVE_HOME": {
			// go from home pos to nearest obj_node_road (with node_id 0)
			// and then to a random obj_node_road that is not 0
			// stopping somewhere between the previous node and the next
			#region commented thoughts on how to do this
			// ... how can i make this work when the nodes ids are not always sequential like how
			//		1 connects to both 0, 2, and 3. 3 only connects to 1 ...
			// some kind of lookup table or tree or something that has each nodes possible routes
			//	var node_to_node = {
			//		"0": [1],
			//		"1": [0, 2, 3],
			//		"2": [1],
			//		"3": [1]
			//	}
			// lets say node 3 is selected as the destination from 0.
			// the program would do the route in reverse?
			//	dest_id = 3
			//	loop through node_to_node.dest_id[] array in descending order (so 2, 1, etc) finding the route which leads to 0
			//		2 does not contain 0 as a possible route, move down to 1
			//		1 has 0 as a possible route
			//	next_point = node_to_node.1[i]
			//	path_add_point(my_path, next_point.x, next_point.y)
			//	path_add_point(my_path, dest_id.x, dest_id.y)
			#endregion
			
			// store start coords to include in path
			var _start_x = x;
			var _start_y = y;
			// find nearest obj_node_road and store its x,y coords
			var _nearest_node = instance_nearest(x, y, obj_node_road);
			target_x = _nearest_node.x;
			target_y = _nearest_node.y;
			
			// add positions to my_path
			path_clear_points(my_path);
			path_add_point(my_path, _start_x, _start_y, 100);
			path_add_point(my_path, target_x, target_y, 100);
			path_set_closed(my_path, false);
			
			//// now pick a random node other than nearest node (0) as the destination
			//var _chosen_id = irandom_range(1, instance_number(obj_node_road));
			//for (var i = 0; i < instance_number(obj_node_road); i++) {
			//	var _node_inst = instance_find(obj_node_road, i);
			//	if (_node_inst.node_id == _chosen_id) {
			//		target_x = _node_inst.x;
			//		target_y = _node_inst.y;
			//		break;
			//	}
			//}
			//// add position to my_path
			//path_add_point(my_path, target_x, target_y, 100);
			
			show_debug_message("obj_nev_van USER_EVENT[0]: "+string(current_state)+" total path points: "+string(path_get_number(my_path)));
		} break;
		case "DRIVE_AND_STOP": {
			// pick a dest node that is not the nearest node to current pos
			//...
		} break;
	}
	// start the path
	path_start(my_path, move_speed, path_action_stop, true);
}
