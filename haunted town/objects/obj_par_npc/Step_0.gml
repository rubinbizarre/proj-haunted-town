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
	//if (sprite_index == spr_kid) {
		if (ac_time_bob < 1) {
			ac_time_bob += ac_speed_bob;
		} else {
			ac_time_bob = 0;
		}
		image_yscale = animcurve_channel_evaluate(ac_channel_bob, ac_time_bob);
	//}
} else {
    //sprite_index = spr_npc_idle;
	//if (sprite_index == spr_kid) {
		image_yscale = 1;
		ac_time_bob = 0;
	//}
}

if (instance_exists(obj_manager_time)) {
	//move_speed = move_speed_init * obj_manager_time.time_speed_actual;
	path_speed = move_speed_init * obj_manager_time.time_speed_actual;
}

switch (current_state) {
	case "CIRCUIT": {
		// tie path speed to time speed like everyone else
		path_speed = move_speed_init * obj_manager_time.time_speed_actual;
	} break;
	//case "WANDER_TOWN": {
		//// hide when arrived at destination
		//if (visible) {
		//	if (x == dest_id.x) or (y == dest_id.y) {
		//		current_state = "INSIDE";
		//		visible = false;
		//	}
		//}
	//} break;
}