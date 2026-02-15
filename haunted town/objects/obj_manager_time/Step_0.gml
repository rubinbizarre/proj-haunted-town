// increment current time by time_speed * (~0.15-0.20)
//global.current_time_ += (delta_time / 1000000) * time_speed; // using delta_time means that time appears to jumps forward after dragging the window round. it's the difference in time between the previous frame and the current frame
// increment current time by time_speed * 0.17
time_speed_actual = time_speed_base * time_speed_multiplier;
//global.current_time_ += (game_get_speed(gamespeed_microseconds) / 100000) * time_speed_actual; // seems to be more appropriate than using delta_time. game_get_speed(gamespeed_microseconds) = 0.17
global.current_time_ += (delta_time / 100000) * time_speed_actual;

// loop the time back to zero after reaching a full week
if (global.current_time_ >= global.total_cycle_minutes) {
    global.current_time_ = 0;
	global.week_counter++;
}

if (global.debug) {
	if (keyboard_check(vk_right)) {
		time_speed_multiplier += 0.1;
	}
	if (keyboard_check(vk_left)) {
		time_speed_multiplier -= 0.1;
	}
	if (keyboard_check_pressed(vk_down)) {
		time_speed_multiplier = time_speed_multiplier_init;
	}
}