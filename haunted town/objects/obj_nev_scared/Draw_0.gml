if (global.debug) {
	var _mod = sprite_get_height(sprite_index) * 4;
	var _y = y+10;
	var _ysep = 10;
	draw_set_color(c_yellow);
	draw_set_alpha(1);
	//draw_circle(x, y, global.nev_detect_radius, true);
	if (path_exists(my_path)) {
		draw_path(my_path, x, y, true);
	}
	draw_set_color(c_white);
	draw_set_alpha(1 );
	draw_set_halign(fa_center);
	// draw text var values
	//draw_text_transformed(x, _y, "state:"+current_state, 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "gear_tier:"+string(global.nev_gear_tier), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "path_index:"+string(path_index), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "r_path_x:"+string(return_path_x), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "r_path_y:"+string(return_path_y), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "r_van_x:"+string(return_van_x), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "r_van_y:"+string(return_van_y), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "fear:"+string(global.nev_fear), 0.5, 0.5, 0); _y += _ysep;
	draw_set_halign(fa_left);
}

#region draw progress bar above indicating current fear level - functional (commented moved to obj_master draw gui)
//if (global.nev_fear > 0) {
//	var _x1 = x - sprite_get_width(sprite_index)/2;
//	var _x2 = x + sprite_get_width(sprite_index)/2;
//	var _y1 = y - sprite_get_height(sprite_index) - 15;
//	var _y2 = y - sprite_get_height(sprite_index) - 13;
	
//	var _total_width = _x2 - _x1;
	
//	draw_set_color(c_dkgray);
//	draw_rectangle(_x1, _y1, _x2, _y2, false);
//	draw_set_color(c_ltgray);
//	draw_rectangle(_x1, _y1, _x1 + (_total_width * global.nev_fear), _y2, false);
//	draw_set_color(c_white);
//}
#endregion

draw_self();