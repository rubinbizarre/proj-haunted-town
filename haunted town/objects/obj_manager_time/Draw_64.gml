#region draw 'x2' time speed toggle button
if (global.hud) {
	var _gui_w = display_get_gui_width();
	var _gui_h = display_get_gui_height();

	var _w = 64;
	var _h = 64;
	var _x1 = _gui_w * 0.16;
	var _x2 = _x1 + _w;
	var _y1 = _gui_h * 0.79;
	var _y2 = _y1 + _h;
	var _r = 12;

	//if (x2_active) or (x2_hover) or (x2_press) draw_set_alpha(1); else draw_set_alpha(0.6);

	// label:
	// switch colours depending on state
	if (x2_active) {
		if (x2_hover) draw_set_colour(#d387ff); else draw_set_colour(global.c_haunt);
	} else {
		if (x2_hover) draw_set_colour(#777777); else draw_set_colour(#555555);
	}
	draw_roundrect_ext(_x1, _y1, _x2, _y2, _r, _r, false);

	// text:
	// switch colours depending on state
	if (x2_active) {
		if (x2_hover) draw_set_colour(#7e618f); else draw_set_colour(#5c4769);
	} else {
		if (x2_hover) draw_set_colour(#999999); else draw_set_colour(#777777);
	}
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(font_main_body);
	var _tx = (_x1 + _x2) / 2;
	var _ty = (_y1 + _y2) / 2;
	var _s = 1;
	if (x2_press) _s = 0.75;
	draw_text_transformed(_tx, _ty, "x2", _s, _s, 0);

	// cleanup
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	draw_set_font(global.font_default);
}
#endregion