var _x = room_width/2;
var _y = room_height/2 + 80;
var _label_w = 400;
// draw backing rect 'label'
draw_set_color(c_dkgray);
draw_rectangle(_x - _label_w, _y - (_label_w/2), _x + _label_w, _y + (_label_w/2), false);
draw_set_color(c_white);

var _margin = 16;
_x = room_width/2 - _margin;
_y = room_height/2;
var _c = #cb73ff;
//var _margin = 16;
//var _vcw = camera_get_view_width(view_camera[0]);
//var _vch = camera_get_view_height(view_camera[0]);
//var _x = _vcw/2 - _margin;
//var _y = _vch/2;
var _ysep = 40;
var _prev_font = draw_get_font();

draw_set_font(font_main);
draw_set_valign(fa_middle);
draw_set_halign(fa_right);

switch (menu_index) {
	case 0: {
		draw_set_color(_c);
		draw_text_transformed(_x, _y, "Display Mode:", 1, 1, 0); _y += _ysep;
		draw_set_color(c_white);
		draw_text_transformed(_x, _y, "Resolution:", 1, 1, 0); _y += _ysep;
	} break;
	case 1: {
		draw_text_transformed(_x, _y, "Display Mode:", 1, 1, 0); _y += _ysep;
		draw_set_color(_c);
		draw_text_transformed(_x, _y, "Resolution:", 1, 1, 0); _y += _ysep;
		draw_set_color(c_white);
	} break;
}

_y += _ysep*2;
_x = room_width/2;
draw_set_halign(fa_center);
draw_text_transformed(_x, _y, "[Enter/Space]\nConfirm Changes", 1, 1, 0);

_x = room_width/2 + _margin;
_y = room_height/2;
//_x = _vcw/2 + _margin;
//_y = _vch/2;
draw_set_halign(fa_left);
switch (menu_index) {
	case 0: {
		draw_set_color(_c);
		draw_text_transformed(_x, _y, mode_options[global.mode_index], 1, 1, 0); _y += _ysep;
		draw_set_color(c_white);
		draw_text_transformed(_x, _y, res_name, 1, 1, 0);
	} break;
	case 1: {
		draw_text_transformed(_x, _y, mode_options[global.mode_index], 1, 1, 0); _y += _ysep;
		draw_set_color(_c);
		draw_text_transformed(_x, _y, res_name, 1, 1, 0);
		draw_set_color(c_white);
	} break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(_prev_font);