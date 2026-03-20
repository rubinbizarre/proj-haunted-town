var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _x = _gui_w/2;
var _y = _gui_h/2 + 80;
var _label_w = 400;
var _label_h = 300;
// draw backing rect 'label'
draw_set_color(c_dkgray);
draw_rectangle(
	_x - _label_w,
	_y - _label_h,
	_x + _label_w,
	_y + _label_h,
	false
);
draw_set_color(c_white);

var _margin = 16;
//_x = _gui_w/2 - _margin;
_x = _gui_w/2 + _margin;
_y = _gui_h/2 - _margin;
var _c = #cb73ff;
//var _margin = 16;
//var _vcw = camera_get_view_width(view_camera[0]);
//var _vch = camera_get_view_height(view_camera[0]);
//var _x = _vcw/2 - _margin;
//var _y = _vch/2;
var _ysep = 40;
var _prev_font = draw_get_font();


draw_set_font(font_main_header);
draw_set_halign(fa_center);
draw_text_transformed(_x - 10, ((_gui_h/2 + 80) - _label_h) + 40, "[NOT] SETTINGS", 1, 1, 0);

draw_set_font(font_main_body);
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

_y += 100;
_x = _gui_w/2;
draw_set_halign(fa_center);
draw_text_transformed(_x, _y, "Press [ENTER/SPACE]\nto Confirm Changes", 1, 1, 0);
_y += _ysep*3.5;
draw_text_transformed(_x, _y, "Press [ESC] to Exit Settings", 1, 1, 0);

_x = _gui_w/2 + (_margin*2);
_y = _gui_h/2 - _margin;
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