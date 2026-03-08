if (global.debug) {
	draw_set_color(c_red);
	// draw the entice_radius around each house (click radius for enticing/spooking people)
	draw_ellipse(x - entice_radius, y - entice_radius, x + entice_radius, y + entice_radius, true);
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
if (stats.owned) {
	// if haunted, draw self differently
	draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_fuchsia, 1);
	
	if (mouse_hover) {
		draw_set_halign(fa_center);
		var _scale_mod = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
		draw_text_transformed(x, y - sprite_height/3, "ENTER", 1*_scale_mod, 1*_scale_mod, 0);
		draw_set_halign(fa_left);
	}
	
} else {
	// otherwise, draw self normally
	draw_self();
	 
	// draw haunt difficulty value when hovering over
	if (mouse_hover) or (global.tracked_building == id) {
		var _haunt_diff_str = string(stats.cost);
		
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

//if (sprite_interior != noone) {
//	draw_set_alpha(0.5);
//    draw_sprite(sprite_interior, 0, interior_x, interior_y);
//	draw_set_alpha(1);
//}