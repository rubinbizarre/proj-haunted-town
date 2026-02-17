if (cursor_start) {
	cursor_x += cursor_speed;
	
	if (cursor_x > x2) {
		cursor_start = false;
		cursor_freeze = true;
		cursor_x = x2;
	}
}

if (cursor_freeze) {
	cursor_freeze = false;
	// assess whether win or fail
	if (cursor_x > win_zone_x1) and (cursor_x < win_zone_x2) {
		// win
		show_message("obj_skillcheck STEP:\nYou succeeded in Haunting this building!");
		global.tracked_building.stats.is_haunted = true;
		alarm[0] = game_get_speed(gamespeed_fps) * 1;
	} else {
		// fail
		show_message("obj_skillcheck STEP:\nYou failed the Haunt.");
		alarm[0] = game_get_speed(gamespeed_fps) * 1;
	}
}