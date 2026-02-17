// draw whole bar bg
draw_set_colour(c_black);
draw_rectangle(x1, y1, x2, y2, false);
// draw win zone inside bar
draw_set_colour(c_fuchsia);
draw_rectangle(
	//win_zone_x1,
	(room_width/2) - (win_zone_radius * global.haunt_difficulty),
	y1 + win_zone_h,
	//win_zone_x2,
	(room_width/2) + (win_zone_radius * global.haunt_difficulty),
	y2 - win_zone_h,
	false
);
// outline the whole bar
draw_set_colour(c_white);
draw_rectangle(x1, y1, x2, y2, true);

// draw the cursor outline
draw_set_colour(c_black);
draw_rectangle(
	cursor_x - cursor_w - cursor_outline_w,
	cursor_y - cursor_h - cursor_outline_w,
	cursor_x + cursor_w + cursor_outline_w,
	cursor_y + cursor_h + cursor_outline_w,
	false
);
// draw the cursor
draw_set_colour(c_fuchsia);
draw_rectangle(
	cursor_x - cursor_w,
	cursor_y - cursor_h,
	cursor_x + cursor_w,
	cursor_y + cursor_h,
	false
);
draw_set_colour(c_white);