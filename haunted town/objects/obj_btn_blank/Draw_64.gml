var _prev_font = draw_get_font();
var _prev_halign = draw_get_halign();
draw_set_font(font_main);
draw_set_halign(fa_center);

//// draw 'shadow' outline text
//draw_text_transformed_colour(_xpos - _shadow_offset, _ypos - _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);
//draw_text_transformed_colour(_xpos - _shadow_offset, _ypos + _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);
//draw_text_transformed_colour(_xpos + _shadow_offset, _ypos + _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);
//draw_text_transformed_colour(_xpos + _shadow_offset, _ypos - _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);

var _c = c_red;

if (mouse_hover) {
	_c = c_fuchsia;
} else {
	_c = c_ltgray;
}

if (clicked) {
	_c = c_white;
}

// draw actual text
draw_text_transformed_colour(x, y, str_btn, 1, 1, 0, _c, _c, _c, _c, 1);

draw_set_font(_prev_font);
draw_set_halign(_prev_halign);