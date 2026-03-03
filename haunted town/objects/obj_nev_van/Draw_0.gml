if (global.debug) {
	var _mod = sprite_get_height(sprite_index) * 4;
	var _y = y + 50;
	var _ysep = 10;
	// draw detect_radius ring
	draw_set_color(c_yellow);
	draw_circle(x, y, global.nev_detect_radius, true);
	// draw path of van
	draw_set_color(c_teal);
	if (path_exists(my_path)) {
		draw_path(my_path, x, y, true);
	}
	// draw text var values
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text_transformed(x, _y, "state:"+string(current_state), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "type:"+string(routine_type), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "home:"+string(home_obj), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "dest:"+string(target_obj), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "spd:"+string(move_speed), 0.5, 0.5, 0); _y += _ysep;
	_y += _ysep;
	draw_text_transformed(x, _y, "x:"+string(round(x)), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "y:"+string(round(y)), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "tx:"+string(target_x), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "ty:"+string(target_y), 0.5, 0.5, 0); _y += _ysep;
	draw_set_halign(fa_left);
}

draw_self();