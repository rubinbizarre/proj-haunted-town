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
//	case "RETURN_HOME": {
//		if (x == target_x) or (y == target_y) {
//			current_state = "INSIDE";
//		}
//	} break;
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