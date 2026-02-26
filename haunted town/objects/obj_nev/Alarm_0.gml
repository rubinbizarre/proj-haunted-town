///@desc glance the other way briefly

image_xscale *= -1;

glance_counter++;

if (glance_counter >= 2) {
	// start path to POI after short delay
	alarm[1] = game_get_speed(gamespeed_fps) * (glance_delay * 1.5);
	show_debug_message("obj_nev ALARM[0]: queued path to nearest circuit node");
	exit;
}

alarm[0] = game_get_speed(gamespeed_fps) * glance_delay;