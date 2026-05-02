image_xscale = 3;
image_yscale = 3;

x2_hover = false;
x2_press = false;
x2_active = false;

cam = view_get_camera(view_current);

function toggle_x2() {
	x2_active = !x2_active;
	if (x2_active) {
		time_speed_multiplier = 2;
	} else {
		time_speed_multiplier = 1;
	}
}