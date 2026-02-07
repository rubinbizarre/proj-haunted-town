if (global.debug) {
	draw_set_color(c_fuchsia);
	// draw the click_radius around each house (click radius for enticing/spooking people)
	draw_ellipse(x - click_radius, y - click_radius, x + click_radius, y + click_radius, true);
	draw_set_color(c_green);
	// draw area where mouse click would 'select' the building
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
	draw_set_color(c_white);
}

// draw border around selected house
if (building_selected) {
	draw_set_color(c_yellow);
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
	draw_set_color(c_white);
}

draw_self();