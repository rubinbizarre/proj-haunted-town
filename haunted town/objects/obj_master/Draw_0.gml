//draw_sprite(global.my_cursor_sprite, 0, cursor_x(), cursor_y());

switch (room) {
	case rm_main: {
		if (global.debug) {
			draw_set_alpha(0.2);
			mp_grid_draw(global.town_grid);
			draw_set_alpha(1);
		}
	} break;
}