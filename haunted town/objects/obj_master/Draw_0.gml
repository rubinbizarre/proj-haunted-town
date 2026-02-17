switch (room) {
	case rm_main: {
		if (global.debug) {
			draw_set_alpha(0.2);
			mp_grid_draw(global.town_grid);
			draw_set_alpha(1);
		}
	} break;
}