if (global.debug) {
	draw_set_color(c_fuchsia);
	// draw the click_radius around each house (click radius for enticing/spooking people)
	draw_ellipse(x - click_radius, y - click_radius, x + click_radius, y + click_radius, true);
	draw_set_color(c_green);
	// draw area where mouse click would 'select' the building
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	// draw text var values
	draw_text_transformed(x, y+5, string(id), 0.5, 0.5, 0);
	draw_set_halign(fa_left);
}

// draw border around selected house
if (building_selected) {
	draw_set_color(c_yellow);
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
	draw_set_color(c_white);
}

//draw_self();
if (stats.is_haunted) {
	// if haunted, draw self differently
	draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_fuchsia, 1);
} else {
	// otherwise, draw self normally
	draw_self();
	 
	// draw haunt difficulty value when hovering over
	if (mouse_hover) {
		var _haunt_diff_str = string(stats.haunt_difficulty);
		
		// draw rectangle as 'background label' for haunt diff string
		draw_rectangle_colour(
			x-string_width(_haunt_diff_str),
			(y-(sprite_height/2)) - 10,
			x+string_width(_haunt_diff_str),
			(y-(sprite_height/2)) + 10,
			c_white, c_white, c_white, c_white, false
		);
		
		// draw actual haunt diff string
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_black);
		draw_text_transformed(x, y-(sprite_height/2), _haunt_diff_str, 1, 1, 0);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_color(c_white);
	}
}