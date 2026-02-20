var _prev_font = draw_get_font();
var _prev_halign = draw_get_halign();
draw_set_font(font_main);
draw_set_halign(fa_center);

//// draw 'shadow' outline text
//draw_text_transformed_colour(_xpos - _shadow_offset, _ypos - _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);
//draw_text_transformed_colour(_xpos - _shadow_offset, _ypos + _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);
//draw_text_transformed_colour(_xpos + _shadow_offset, _ypos + _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);
//draw_text_transformed_colour(_xpos + _shadow_offset, _ypos - _shadow_offset, str_btn, _xscale, _yscale, _angle, c_black, c_black, c_black, c_black, _shadow_alpha);

//if (mouse_hover) {
//	
//} else {
//	
//}

//if (clicked) {
//	//...
//}

draw_set_font(_prev_font);
draw_set_halign(_prev_halign);