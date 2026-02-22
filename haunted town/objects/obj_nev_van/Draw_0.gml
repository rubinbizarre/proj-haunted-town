//if (global.debug) {
//	var _mod = sprite_get_height(sprite_index) * 4;
//	var _y = y+10;
//	var _ysep = 10;
//	draw_set_color(c_fuchsia);
//	draw_set_alpha(0.1);
//	// draw massive purple circle around 
//	draw_ellipse(x - _mod, y - _mod, x + _mod, y + _mod, false);
//	if (path_exists(my_path)) {
//		draw_path(my_path, x, y, true);
//	}
//	draw_set_color(c_white);
//	draw_set_alpha(1);
//	draw_set_halign(fa_center);
//	// draw text var values
//	draw_text_transformed(x, _y, "state:"+string(current_state), 0.5, 0.5, 0); _y += _ysep;
//	//draw_text_transformed(x, _y, "type:"+string(routine_type), 0.5, 0.5, 0); _y += _ysep;
//	draw_text_transformed(x, _y, "home:"+string(home_id), 0.5, 0.5, 0); _y += _ysep;
//	//draw_text_transformed(x, _y, "dest:"+string(dest_id), 0.5, 0.5, 0); _y += _ysep;
//	draw_text_transformed(x, _y, "spd:"+string(move_speed), 0.5, 0.5, 0); _y += _ysep;
//	draw_set_halign(fa_left);
//}

draw_self();