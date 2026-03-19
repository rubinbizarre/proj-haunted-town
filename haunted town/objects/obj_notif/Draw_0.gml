//var _prev_font = draw_get_font();
draw_set_font(font_main_sub);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

draw_set_color(c);
draw_set_alpha(alpha);

//var _sign;
//if (amount >= 0) {
//	_sign = "+";
//} else {
//	_sign = "-";
//}

//draw_text_transformed(x, y, amount, scale, scale, 0);
draw_text(x, y, amount);

// cleanup
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(global.font_default);