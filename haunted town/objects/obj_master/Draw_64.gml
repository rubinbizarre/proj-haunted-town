var _x = 0;
var _y = 0;
var _ysep = 0;

#region DEBUG
if (global.debug) {
	draw_set_color(c_lime);
	_x = 16;
	_y = 16;
	_ysep = 40;

	draw_text_transformed(_x, _y, "current_time: "+string(global.current_time_)+" / "+string(global.total_cycle_minutes), 2, 2, 0); _y += _ysep;
	draw_set_color(c_white);
}
#endregion

#region HUD
if (global.hud) {
	draw_set_halign(fa_center);
	_x = room_width/2;
	_y = 16;
	_ysep = 40;

	draw_text_transformed(_x, _y, "Haunt Power: "+string(global.haunt_power), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "Time: "+string("use a script or smthn"), 2, 2, 0); _y += _ysep; // draw time in format "Monday 8:32 PM" include toggle for 24 hr time in settings "Monday 20:32"
	draw_set_halign(fa_left);
}
#endregion