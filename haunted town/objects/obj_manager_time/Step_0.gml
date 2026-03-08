// increment current time by time_speed * (~0.15-0.20)
//global.current_time_ += (delta_time / 1000000) * time_speed; // using delta_time means that time appears to jumps forward after dragging the window round. it's the difference in time between the previous frame and the current frame
// increment current time by time_speed * 0.17
time_speed_actual = time_speed_base * time_speed_multiplier;
//global.current_time_ += (game_get_speed(gamespeed_microseconds) / 100000) * time_speed_actual; // seems to be more appropriate than using delta_time. game_get_speed(gamespeed_microseconds) = 0.17
global.current_time_ += (delta_time / 100000) * time_speed_actual;

//// loop the time back to zero after reaching a full week
//if (global.current_time_ >= global.total_cycle_minutes) {
//    global.current_time_ = 0;
//	  global.week_counter++;
//}

current_hour_ = floor(global.current_time_ / 60);
if (current_hour_ > prev_hour_) {
	// new hour just happened - broadcast to npcs to check their schedule
	with (obj_par_npc) {
		if (current_state != "ENTICED") and (current_state != "SCARED_STIFF") {
			event_user(0);
		}
	}
	prev_hour_ = current_hour_;
}


// loop the time back to zero after reaching a full day
if (global.current_time_ >= global.total_cycle_minutes) {
	// reset time to 0, start of new day
	global.current_time_ = 0;
	prev_hour_ = 0;
	
	//increment_day_counter(); // moved to trigger remotely via obj_master
	
	// now trigger displaying podcast & daily events breakdown
	obj_master.toggle_display_end_of_day();
}

if (global.debug) {
	if (keyboard_check(vk_right)) {
		time_speed_multiplier += (0.1 * time_speed_actual);
	}
	if (keyboard_check(vk_left)) {
		time_speed_multiplier -= (0.1 * time_speed_actual);
	}
	if (keyboard_check_pressed(vk_down)) {
		time_speed_multiplier = time_speed_multiplier_init;
	}
}