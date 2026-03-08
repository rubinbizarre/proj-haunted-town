

if (global.debug) {
	//draw_set_color(c_white);
	draw_circle(x, y, scare_radius, true);
	//draw_set_color(c_white);
}

if (haunted) {
	draw_set_color(c_red);
	draw_set_alpha(0.3);
	//draw_circle(x, y, scare_radius, false);
	var _i = instance_nearest(x, y, obj_interior);
	//draw_rectangle(_i.bbox_left, _i.bbox_top, _i.bbox_right, _i.bbox_bottom, false);
	var _sprite_w = sprite_get_width(_i.sprite_index)/2;
	var _sprite_h = sprite_get_height(_i.sprite_index)/2;
	draw_rectangle(_i.x - _sprite_w, _i.y - (_sprite_h-0.5), _i.x + (_sprite_w-1), _i.y + (_sprite_h-0.5), false);
	draw_set_alpha(1);
	draw_set_color(c_white);
}

draw_self();