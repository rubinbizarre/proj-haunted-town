if (!cooldown_active) {
	draw_self();
} else {
	draw_sprite_ext(sprite_normal, 0, x, y, image_xscale, image_yscale, 0, c_white, 0.5);
	
	#region draw pie wheel representing cooldown timer
	var _c = c_ltgray;
	var _y = y-(sprite_height/2);
	draw_pie_slice(x, _y, pie_r1, pie_r2, 0, 360, c_dkgray);
	draw_pie_slice(x, _y, pie_r1, pie_r2, 0, 360 * (cooldown_timer/cooldown_timer_init), _c);
	draw_set_color(c_white);
	#endregion
}

if (global.debug) {
	draw_set_color(c_fuchsia);
	draw_circle(x, y, haunt_radius, true);
	draw_set_color(c_white);
}