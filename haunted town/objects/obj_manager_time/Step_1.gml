if (global.hud) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _x1 = _gui_w * 0.16;
    var _y1 = _gui_h * 0.79;
    ui_register("x2_button", _x1, _y1, _x1 + 64, _y1 + 64, UI_Z_HUD);
}