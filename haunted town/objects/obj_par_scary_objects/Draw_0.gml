

if (global.debug) {
	//draw_set_color(c_white);
	draw_circle(x, y, haunt_radius, true);
	//draw_set_color(c_white);
}

if (haunted) {
	draw_set_color(c_red);
	draw_set_alpha(0.3);
	//draw_circle(x, y, haunt_radius, false);
	var _i = instance_nearest(x, y, obj_interior);
	//draw_rectangle(_i.bbox_left, _i.bbox_top, _i.bbox_right, _i.bbox_bottom, false);
	var _sprite_w = sprite_get_width(_i.sprite_index)/2;
	var _sprite_h = sprite_get_height(_i.sprite_index)/2;
	draw_rectangle(_i.x - _sprite_w, _i.y - (_sprite_h-0.5), _i.x + (_sprite_w-1), _i.y + (_sprite_h-0.5), false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	scr_draw_infamy(infamy, 15);
}

if (cooldown_active) {
	// draw half-transparent normal sprite
	draw_sprite_ext(sprite_normal, 0, x, y, image_xscale, image_yscale, 0, c_white, 0.5);
	
	#region draw pie wheel representing cooldown timer
	var _c = c_ltgray;
	var _y = y-(sprite_height/2);
	draw_pie_slice(x, _y, pie_r1, pie_r2, 0, 360, c_dkgray);
	draw_pie_slice(x, _y, pie_r1, pie_r2, 0, 360 * (cooldown_timer/cooldown_timer_init), _c);
	draw_set_color(c_white);
	#endregion
} else if (deactivate_active) {
	// draw self normally
	draw_self();
	
	#region draw pie wheel representing deactivate timer
	var _c = c_ltgray;
	var _y = y-(sprite_height/2);
	draw_pie_slice(x, _y, pie_r1, pie_r2, 0, 360, c_dkgray);
	draw_pie_slice(x, _y, pie_r1, pie_r2, 0, 360 * (deactivate_timer/deactivate_timer_init), _c);
	draw_set_color(c_white);
	#endregion
} else {
	// draw self normally
	draw_self();
}

if (locked) and (mouse_hover) {
	// draw rectangle as 'background label'
	draw_set_font(font_main_sub);
	var _cost_str = string(cost);
	var _y = y-(sprite_height/2);
	var _r = 6;
	var _w = string_width(_cost_str)/1.2;
	var _h = 10;
	draw_set_color(global.c_haunt);
	draw_roundrect_ext(
		x - _w,
		_y - _h,
		x + (_w - 1),
		_y + (_h - 1),
		_r,
		_r,
		false
	);
		
	// draw actual string
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	//draw_set_color(c_black);
	//draw_text_transformed(x, _y, _cost_str, 1, 1, 0);
	draw_set_color(#333333);
	draw_text(x, _y, _cost_str);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_font(global.font_default);
}