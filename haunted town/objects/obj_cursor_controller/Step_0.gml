#region virtual cursor via right stick
if (gamepad_is_connected(0)) {
    var _rx = gamepad_axis_value(0, gp_axisrh);
    var _ry = gamepad_axis_value(0, gp_axisrv);

    var _dz = 0.15;
    if (abs(_rx) < _dz) _rx = 0;
    if (abs(_ry) < _dz) _ry = 0;

    if (_rx != 0 || _ry != 0) {
        global.using_gamepad_cursor = true;

        //global.vcursor_room_x += _rx * cursor_speed_room;
        //global.vcursor_room_y += _ry * cursor_speed_room;
        //global.vcursor_room_x = clamp(global.vcursor_room_x, 0, room_width);
        //global.vcursor_room_y = clamp(global.vcursor_room_y, 0, room_height);

        global.vcursor_gui_x += _rx * cursor_speed_gui;
        global.vcursor_gui_y += _ry * cursor_speed_gui;
        global.vcursor_gui_x = clamp(global.vcursor_gui_x, 0, display_get_gui_width());
        global.vcursor_gui_y = clamp(global.vcursor_gui_y, 0, display_get_gui_height());
    }
}

// if physical mouse moves, hand control back to it
if (device_mouse_x_to_gui(0) != global.last_mouse_x || device_mouse_y_to_gui(0) != global.last_mouse_y) {
    global.using_gamepad_cursor = false;
    //global.vcursor_room_x = mouse_x;
    //global.vcursor_room_y = mouse_y;
	global.vcursor_gui_x = device_mouse_x_to_gui(0);
	global.vcursor_gui_y = device_mouse_y_to_gui(0);
	
}
global.last_mouse_x = device_mouse_x_to_gui(0);
global.last_mouse_y = device_mouse_y_to_gui(0);
#endregion