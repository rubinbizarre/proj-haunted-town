draw_self();

if (global.debug) {
	draw_set_color(c_red);
	draw_circle(x, y, scare_radius, true);
	draw_set_color(c_white);
}