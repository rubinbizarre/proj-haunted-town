// periodic routine check
if (check_timer-- <= 0) {
    check_timer = check_interval;
    event_user(0); // trigger routine logic
}

// animation & sprite flipping logic
if (path_index != -1) {
    // if moving, face the direction of movement
    image_xscale = (direction > 90 and direction < 270) ? -scale_init : scale_init;
    //sprite_index = spr_npc_walk;
} else {
    //sprite_index = spr_npc_idle;
}

if (instance_exists(obj_manager_time)) {
	move_speed = move_speed_init * obj_manager_time.time_speed_actual;
}

//switch (current_state) {
//	case "CIRCUIT": {
//		if (!circuit_start) and ((x == instance_nearest(x, y, obj_node_circuit)) or (y == instance_nearest(x, y, obj_node_circuit))) {
//			circuit_start = true;
//			var _inst = instance_nearest(x, y, obj_node_circuit);
//			show_debug_message("obj_par_npc STEP: "+string(id)+" made circuit_start TRUE. nearest node id: "+string(_inst.node_id));
//		}
//		if (circuit_start) {
//			// compare node_ids to determine which direction to go, which target x,y to move to
//			var _node_nearest = instance_nearest(x, y, obj_node_circuit);
//			// if the node we're on is 41, its the last one so have to find the node with id 0, that's the next one in sequence
//			if (_node_nearest.node_id == 41) {
//				// loop through node instances, find the node inst with id 0
//				// when we do, set the target coords to move to
//				for (var i = 0; i < instance_number(obj_node_circuit); i++) {
//					var _inst = instance_find(obj_node_circuit, i);
//					if (_inst.node_id == 0) {
//						target_x = _inst.x;
//						target_y = _inst.y;
//						show_debug_message("obj_par_npc STEP: "+string(id)+" found next node with id "+string(_inst.node_id)+" | x:"+string(_inst.x)+" y:"+string(_inst.y));
//						break;
//					}
//				}
//			} else { // if node we're on is not 41
//				// loop through node instances, find the node inst with next node_id in sequence
//				for (var i = 0; i < instance_number(obj_node_circuit); i++) {
//					var _inst = instance_find(obj_node_circuit, i);
//					// if the node we're looking at is the next node in the circuit (goes counter-clockwise around the town)
//					// set the target coords to move to
//					if (_inst.node_id == _node_nearest.node_id + 1) {
//						target_x = _inst.x;
//						target_y = _inst.y;
//						show_debug_message("obj_par_npc STEP: "+string(id)+" found next node with id "+string(_inst.node_id)+" | x:"+string(_inst.x)+" y:"+string(_inst.y));
//						break;
//					}
//				}
//			}
//			circuit_start = false;
//			show_debug_message("obj_par_npc STEP: "+string(id)+" made circuit_start FALSE");
//		}
//	} break;
//}
//	case "WANDER_TOWN": {
//		if (x == target_x) or (y == target_y) {
//			current_state = "INSIDE";
//		}
//	} break;
//	case "WANDER_TOWN_AGAIN": {
//		if (x == target_x) or (y == target_y) {
//			current_state = "INSIDE";
//		}
//	} break;
//	case "VISIT_HAUNTED": {
//		if (x == target_x) or (y == target_y) {
//			current_state = "INSIDE";
//		}
//	} break;
//}