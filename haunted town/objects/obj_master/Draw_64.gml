var _x = 0;
var _y = 0;
var _ysep = 0;

#region DEBUG
if (global.debug) {
	draw_set_color(c_lime);
	_x = 16;
	_y = 16;
	_ysep = 40;
	
	draw_text_transformed(_x, _y, "current_time: "+string(global.current_time_)+"/"+string(global.total_cycle_minutes), 2, 2, 0); _y += _ysep;
	if (instance_exists(obj_manager_time)) draw_text_transformed(_x, _y, "time_speed: "+string(obj_manager_time.time_speed_actual), 2, 2, 0); _y += _ysep;
	// display controls for time speed manipulation
	draw_set_halign(fa_center); draw_text_transformed(room_width/2, room_height-40, "left = decrease time spd | down = reset time spd | right = increase time spd", 2, 2, 0); _y += _ysep; draw_set_halign(fa_left);
	draw_set_color(c_white);
}
#endregion

#region HUD
if (global.hud) {
	draw_set_halign(fa_center);
	_x = room_width/2;
	_y = 16;
	_ysep = 40;

	draw_text_transformed(_x, _y, "HAUNT POWER: "+string(global.haunt_power), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "WEEK "+string(global.week_counter), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, scr_date_and_time(global.current_time_), 2, 2, 0); _y += _ysep; // draw time in format "Monday 20:32" include toggle for 12 hr time in settings "Monday 8:32 PM"
	draw_set_halign(fa_left);
}
#endregion