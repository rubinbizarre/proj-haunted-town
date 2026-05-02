// increment current time by time_speed * (~0.15-0.20)
//global.current_time_ += (delta_time / 1000000) * time_speed; // using delta_time means that time appears to jumps forward after dragging the window round. it's the difference in time between the previous frame and the current frame
// increment current time by time_speed * 0.17
time_speed_actual = time_speed_base * time_speed_multiplier;
//global.current_time_ += (game_get_speed(gamespeed_microseconds) / 100000) * time_speed_actual; // seems to be more appropriate than using delta_time. game_get_speed(gamespeed_microseconds) = 0.17
global.current_time_ += (delta_time / 100000) * time_speed_actual;

time_speed_normalised = time_speed_actual / time_speed_base; // used for all decrementing alarms. when time_speed_base = 0.5, time_speed_normalised = 1. when time_speed_base = 1, time_speed_normalised = 2.

//// loop the time back to zero after reaching a full week
//if (global.current_time_ >= global.total_cycle_minutes) {
//    global.current_time_ = 0;
//	  global.week_counter++;
//}

if (light_change_sunrise) or (light_change_sunset) {
	light_change_timer += (delta_time / 100000) * time_speed_actual;
}
if (light_change_sunrise) {
	global.light_change_progress = 1 - (light_change_timer / 180); // 180 is 3 hours, 3 * 60 = 180
}
if (light_change_sunset) {
	global.light_change_progress = light_change_timer / 180;
}

current_hour_ = floor(global.current_time_ / 60);
if (current_hour_ > prev_hour_) {
	// new hour just happened
	
	// play sound (church bell chime)
	//...
	
	// broadcast to npcs to check their schedule
	with (obj_par_npc) {
		if (current_state != "ENTICED") and (current_state != "SCARED_STIFF") {
			event_user(0);
		}
	}
	
	#region watch for certain times to trigger light_change_timer, with sunset or sunrise
	var _sunrise_start = 5;
	var _sunrise_end = 8;
	var _sunset_start = 20;
	var _sunset_end = 23;
	if (current_hour_ == _sunrise_start) and (!light_change_sunrise) {
		light_change_sunrise = true;
		light_change_timer = 0;
	}
	if (current_hour_ == _sunrise_end) and (light_change_sunrise) {
		light_change_sunrise = false;
		light_change_timer = 1;
	}
	if (current_hour_ == _sunset_start) and (!light_change_sunset) {
		light_change_sunset = true;
		light_change_timer = 0;
	}
	if (current_hour_ == _sunset_end) and (light_change_sunset) {
		light_change_sunset = false;
		light_change_timer = 1;
	}
	#endregion
	
	#region watch for certain times to trigger certain light sources
	var _night_light_start = 21;
	var _night_light_end = 7;
	if (current_hour_ == _night_light_start) and (!global.light_night) {
		global.light_night = true;
	}
	if (current_hour_ == _night_light_end) and (global.light_night) {
		global.light_night = false;
	}
	#endregion
	
	prev_hour_ = current_hour_;
}

// loop the time back to zero after reaching a full day
if (global.current_time_ >= global.total_cycle_minutes) {
	// reset time to 0, start of new day
	global.current_time_ = 0;
	prev_hour_ = 0;
	
	//increment_day_counter(); // moved to trigger remotely via obj_master
	
	// increase nev's total subs with passive growth
	global.subs += global.daily_passive_growth;
	
	// now trigger displaying podcast & daily events breakdown
	obj_master.toggle_display_end_of_day();
}

#region handle time manipulation while debugging
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
#endregion

#region handle click input on 'x2' button - working sorta
// known issue: clicking also affects objects underneath the GUI layer in the world, this needs addressing
if (global.hud) {
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	var _gui_w = display_get_gui_width();
	var _gui_h = display_get_gui_height();
	var _w = 64;
	var _h = 64;
	var _x1 = _gui_w * 0.16;
	var _x2 = _x1 + _w;
	var _y1 = _gui_h * 0.79;
	var _y2 = _y1 + _h;
	x2_hover = point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2);
	if (mouse_check_button_pressed(mb_left) and x2_hover) {
	    x2_press = true;
	}
	if (x2_press and !x2_hover) {
		x2_press = false;
	}
	if (mouse_check_button_released(mb_left) and x2_press and x2_hover) {
		// confirm input
		x2_press = false;
		x2_hover = false;
		toggle_x2();
	}
}
#endregion