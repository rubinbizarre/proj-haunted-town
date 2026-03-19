if (global.debug) {
	var _mod = sprite_get_height(sprite_index) * 4;
	var _y = y+10;
	var _ysep = 10;
	draw_set_color(c_yellow);
	draw_set_alpha(1);
	// draw detect_radius ring
	draw_circle(x, y, global.nev_detect_radius, true);
	if (path_exists(my_path)) {
		draw_path(my_path, x, y, true);
	}
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	// draw text var values
	//draw_text_transformed(x, _y, "rx:"+string(return_van_x), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "ry:"+string(return_van_y), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "spd:"+string(move_speed), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "path_spd:"+string(path_speed), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "state:"+current_state, 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "gear_tier:"+string(global.nev_gear_tier), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "path_index:"+string(path_index), 0.5, 0.5, 0); _y += _ysep;
	draw_set_halign(fa_left);
}

draw_self();