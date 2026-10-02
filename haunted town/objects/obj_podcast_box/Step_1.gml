//if (global.hud) {
//    var _gui_w = display_get_gui_width();
//    var _gui_h = display_get_gui_height();
//	var _x2 = _gui_w * 0.72;
//    var _x1 = _x2 - 128;
//    var _y1 = 32;
//	var _y2 = _y1 + 128;
//    ui_register("tab", _x1, _y1, _x2, _y2, UI_Z_HUD);
//}
if (surface_exists(podcast_surface)) {
    var _surf_w = surface_get_width(podcast_surface);
    var _tab_x2 = _surf_w * 0.72;
    var _tab_x1 = _tab_x2 - 128;
    ui_register("podcast_tab", _tab_x1 + shift, 32, _tab_x2 + shift, 32 + 128, UI_Z_PANEL + 10);
}

if (display_active || shift < shift_max) {
	var _surf_w = surface_get_width(podcast_surface);
	var _surf_h = surface_get_height(podcast_surface);
	var _body_x1 = _surf_w * 0.7;
	var _body_x2 = _surf_w;
	var _body_y1 = 0;
	var _body_y2 = _surf_h;
    ui_register("podcast_box", _body_x1 + shift, _body_y1, _body_x2 + shift, _body_y2, UI_Z_PANEL);
}