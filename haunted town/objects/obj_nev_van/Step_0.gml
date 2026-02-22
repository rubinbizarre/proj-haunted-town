if (depth != -(y + 25)) depth = -(y + 25); // i think its closer to 22 but whatever

//// periodic routine check
//if (check_timer-- <= 0) {
//	check_timer = check_interval;
//	event_user(0); // trigger routine logic
//}

//// animation & sprite flipping logic
//if (path_index != -1) {
//	// if moving/on a path, face the direction of movement
//	image_xscale = (direction > 90 and direction < 270) ? -scale_init : scale_init; // flip left or face right
//	sprite_index = (direction > 180 and direction < 360) ? spr_nev_van_up : spr_nev_van_side; // face up
//	sprite_index = (direction > 0 and direction < 180) ? spr_nev_van_down : spr_nev_van_side; // face down
//}
	
//// make path_speed affected by current time_speed
//if (instance_exists(obj_manager_time)) {
//	path_speed = move_speed_init * obj_manager_time.time_speed_actual;
//}