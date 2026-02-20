if (global.debug) {
	var _margin = 16;
	var _x = room_width - _margin;
	var _y = 16;
	var _ysep = 40;
	draw_set_halign(fa_right);
	draw_set_color(c_lime);
	draw_text_transformed(_x, _y, "//OBJ_CAMERA//", 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "cam_w:"+string(camera_get_view_width(cam)), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "cam_h:"+string(camera_get_view_height(cam)), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "vp_w:"+string(view_get_wport(cam)), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "vp_h:"+string(view_get_hport(cam)), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "room_w:"+string(room_width), 2, 2, 0); _y += _ysep;
	draw_text_transformed(_x, _y, "room_h:"+string(room_height), 2, 2, 0); _y += _ysep;
	draw_set_color(c_white);
	draw_set_halign(fa_left);
}