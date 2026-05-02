if (mouse_check_button_pressed(mb_left) and x2_hover) {
	x2_press = true;
}
if (x2_press and !x2_hover) {
	x2_press = false;
}
if (mouse_check_button_released(mb_left) and x2_press and x2_hover) {
	// confirm input
	x2_press = false;
	x2_hover = false;
	toggle_x2();
}

x = cam.x;
y = cam.y;