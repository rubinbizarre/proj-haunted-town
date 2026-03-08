if (global.debug) {
	//var _xmod = sprite_get_width(sprite_index) * 4;
	var _mod = sprite_get_height(sprite_index) * 4;
	var _y = y+10;
	var _ysep = 10;
	draw_set_color(c_fuchsia);
	draw_set_alpha(0.1);
	// draw massive purple circle around npc
	draw_ellipse(x - _mod, y - _mod, x + _mod, y + _mod, false);
	if (path_exists(my_path)) {
		draw_path(my_path, x, y, true);
	}
	draw_set_color(c_white);
	draw_rectangle(
		x - abs(sprite_width/2) - 4,
		y - sprite_height - 4,
		x + abs(sprite_width/2) + 4,
		y + 4,
		false
	);
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	// draw text var values
	draw_text_transformed(x, _y, "state:"+string(current_state), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "move_inside:"+string(move_inside), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "move_timer:"+string(move_timer), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "type:"+string(routine_type), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "home:"+string(home_obj), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "t_x:"+string(target_x), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "t_y:"+string(target_y), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "t_obj:"+string(target_obj), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "path_index:"+string(path_index), 0.5, 0.5, 0); _y += _ysep;
	draw_set_halign(fa_left);
}

draw_self();