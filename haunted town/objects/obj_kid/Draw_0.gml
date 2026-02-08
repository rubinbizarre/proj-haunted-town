if (global.debug) {
	var _xmod = sprite_width * 4;
	var _ymod = sprite_height * 4;
	draw_set_color(c_fuchsia);
	draw_set_alpha(0.5);
	draw_ellipse(x - _xmod, y - _ymod, x + _xmod, y + _ymod, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	draw_text_transformed(x, y+10, string(current_state), 0.2, 0.2, 0);
}

draw_self();