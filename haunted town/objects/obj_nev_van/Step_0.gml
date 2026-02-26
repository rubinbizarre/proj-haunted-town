if (depth != -(y + 25)) depth = -(y + 25); // set correct depth based on ypos and sprite origin offset. i think its closer to 22 but whatever

// periodic routine check but only in certain conditions
if (current_state == "RETURN_HOME") {
	if (check_timer-- <= 0) {
		check_timer = check_interval;
		event_user(0); // trigger routine logic
	}
}

#region animation / sprite flipping logic
if (path_index != -1) {
	//// smoothly rotate the sprite to face the direction of the path
	//// works, nice effect, but not for the current sprite switching configuration?
    //var _target_angle = direction;
    //image_angle = lerp(image_angle, _target_angle, 0.1);
	
	// if moving/on a path, face the direction of movement
	switch (direction) {
		case 0: { // facing right
			if (image_xscale != scale_init) image_xscale = scale_init;
			if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
		} break;
		case 180: { // facing left
			if (image_xscale != -scale_init) image_xscale = -scale_init;
			if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
		} break;
		case 270: { // facing down
			if (image_xscale != scale_init) image_xscale = scale_init;
			if (sprite_index != spr_nev_van_down) sprite_index = spr_nev_van_down;
		} break;
		case 90: { // facing up
			if (image_xscale != scale_init) image_xscale = scale_init;
			if (sprite_index != spr_nev_van_up) sprite_index = spr_nev_van_up;
		} break;
		default: { // if any other value, make a decision
			if (direction > 90 and direction < 270) { // facing left
				if (image_xscale != -scale_init) image_xscale = -scale_init;
				if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
			} else if (direction > 180 and direction < 360) { // facing right
				if (image_xscale != scale_init) image_xscale = scale_init;
				if (sprite_index != spr_nev_van_side) sprite_index = spr_nev_van_side;
			}
		} break;
	}
}
#endregion
	
// make path_speed affected by current time_speed
if (instance_exists(obj_manager_time)) {
	path_speed = move_speed_init * obj_manager_time.time_speed_actual;
}

switch (current_state) {
	case "LEAVE_HOME": {
		if (x == target_x) and (y == target_y) {
			target_x = 0;
			target_y = 0;
			current_node = instance_nearest(x, y, obj_node_road);
			current_state = "DRIVE_AND_STOP";
			show_debug_message("obj_nev_van STEP: changed state from LEAVE_HOME to DRIVE_AND_STOP. going to new dest.");
			goto_new_dest();
		}
	} break;
	case "DRIVE_AND_STOP": {
		if (path_index == -1) and (current_state != "IDLE") {
			target_x = 0;
			target_y = 0;
			current_state = "IDLE";
			// deploy Nev after short delay
			alarm[0] = game_get_speed(gamespeed_fps) * 2;
			show_debug_message("obj_nev_van STEP: changed state from DRIVE_AND_STOP to IDLE.");
		}
	} break;
}