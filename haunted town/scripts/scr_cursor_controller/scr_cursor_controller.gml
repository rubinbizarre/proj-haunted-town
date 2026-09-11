function cursor_x() {
    return global.using_gamepad_cursor ? global.vcursor_room_x : mouse_x;
}
function cursor_y() {
    return global.using_gamepad_cursor ? global.vcursor_room_y : mouse_y;
}
function cursor_gui_x() {
    return global.using_gamepad_cursor ? global.vcursor_gui_x : device_mouse_x_to_gui(0);
}
function cursor_gui_y() {
    return global.using_gamepad_cursor ? global.vcursor_gui_y : device_mouse_y_to_gui(0);
}