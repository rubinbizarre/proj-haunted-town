draw_self();
	
if (mouse_hover) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	var _prev_font = draw_get_font();
	draw_set_font(font_main_sub);
	//var _scale_mod = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
	draw_text_transformed(x, y, "LEAVE", 1, 1, 0);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(_prev_font);
}