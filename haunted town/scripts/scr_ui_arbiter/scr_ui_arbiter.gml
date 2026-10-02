// scr_ui
#macro UI_Z_HUD          100
#macro UI_Z_PANEL        200
#macro UI_Z_PAUSE_BLOCK  1000
#macro UI_Z_PAUSE_ITEM   1010

function ui_init() {
    global.ui_reg = [];
    global.ui_hot = undefined;
    global.ui_hot_valid = false;
}

function ui_register(_key, _x1, _y1, _x2, _y2, _z) {
    array_push(global.ui_reg, { key: _key, x1: _x1, y1: _y1, x2: _x2, y2: _y2, z: _z });
}

function ui_hot_id() {
    if (!global.ui_hot_valid) {
        var mx = cursor_gui_x(), my = cursor_gui_y();
        var best = -infinity;
        global.ui_hot = undefined;
        for (var i = 0; i < array_length(global.ui_reg); i++) {
            var r = global.ui_reg[i];
            if (mx >= r.x1 && mx <= r.x2 && my >= r.y1 && my <= r.y2 && r.z >= best) {
                best = r.z;
                global.ui_hot = r.key;      // ties go to whichever registered last
            }
        }
        global.ui_hot_valid = true;
    }
    return global.ui_hot;
}

function ui_is_hot(_key) {
    var h = ui_hot_id();
    return !is_undefined(h) && h == _key;
}

function ui_over_any() { return !is_undefined(ui_hot_id()); }

function ui_click_pressed() {
    // swap gp_face1 for whatever your gamepad cursor uses to click
    return global.using_gamepad_cursor ? gamepad_button_check_pressed(0, gp_face1)
                                       : mouse_check_button_pressed(mb_left);
}
function ui_click_held() {
    return global.using_gamepad_cursor ? gamepad_button_check(0, gp_face1)
                                       : mouse_check_button(mb_left);
}
function ui_click_released() {
    return global.using_gamepad_cursor ? gamepad_button_check_released(0, gp_face1)
                                       : mouse_check_button_released(mb_left);
}