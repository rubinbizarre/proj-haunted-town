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
	//draw_text_transformed(x, _y, "fear_drain:"+string(fear_drain), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "fear:"+string(fear), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "move_timer:"+string(move_timer), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "type:"+string(routine_type), 0.5, 0.5, 0); _y += _ysep;
	//draw_text_transformed(x, _y, "home:"+string(home_obj), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "t_x:"+string(target_x), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "t_y:"+string(target_y), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "t_obj:"+string(target_obj), 0.5, 0.5, 0); _y += _ysep;
	draw_text_transformed(x, _y, "path_index:"+string(path_index), 0.5, 0.5, 0); _y += _ysep;
	draw_set_halign(fa_left);
}

#region draw possessed radius if possessed, indicating area in which player can remotely entice other npcs
if (possessed) {
	draw_set_color(global.c_haunt);
	draw_circle(x, y, possessed_radius, true);
	draw_set_color(c_white);
}
#endregion

draw_self();

#region draw progress bar above NPC indicating current fear level
if (fear > 0) and (!dying) {
	var _x1 = x - sprite_get_width(spr_npc_elderly)/2;
	var _x2 = x + sprite_get_width(spr_npc_elderly)/2;
	var _y1 = y - sprite_get_height(sprite_index) - 10;
	var _y2 = y - sprite_get_height(sprite_index) - 8;
	
	var _total_width = _x2 - _x1;
	
	draw_set_color(c_dkgray);
	draw_rectangle(_x1, _y1, _x2, _y2, false);
	draw_set_color(c_ltgray);
	draw_rectangle(_x1, _y1, _x1 + (_total_width * fear), _y2, false);
	draw_set_color(c_white);
}
#endregion

#region draw specific 'haunted outline' around npc under certain conditions
if (current_state = "SCARED_STIFF") and (!dying) and (!possess_transition) and (!possessed) {
	var _subimg;
	switch (sprite_index) {
		case spr_npc_adult: _subimg = 0; break;
		case spr_npc_elderly: _subimg = 1; break;
		case spr_npc_kid: _subimg = 2; break;
	}
	draw_sprite_ext(spr_npc_outlines, _subimg, x, y, image_xscale, image_yscale, 0, c_white, image_alpha);
} else if (dying) or (possess_transition) {
	var _subimg;
	switch (sprite_index) {
		case spr_npc_adult: _subimg = 3; break;
		case spr_npc_elderly: _subimg = 4; break;
		case spr_npc_kid: _subimg = 5; break;
	}
	draw_sprite_ext(spr_npc_outlines, _subimg, x, y, image_xscale, image_yscale, 0, c_white, image_alpha);
}
#endregion