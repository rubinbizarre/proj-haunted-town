if (global.debug) {
	with (obj_node_road) {
	    draw_self();
	    for (var i = 0; i < array_length(connections); i++) {
	        draw_line_color(x, y, connections[i].x, connections[i].y, c_yellow, c_yellow);
	    }
		draw_circle_colour(x, y, 10, c_yellow, c_yellow, true);
	}
}