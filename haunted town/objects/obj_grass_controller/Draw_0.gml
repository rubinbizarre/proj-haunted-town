if (surface_exists(surf_grass)) {
	surface_set_target(surf_grass);
	    shader_set(shd_grass);
	    shader_set_uniform_f(uni_time, timer);
	    shader_set_uniform_f_array(uni_res, [surface_get_width(surf_grass), surface_get_height(surf_grass)]);
	    draw_rectangle_colour(0, 0, surface_get_width(surf_grass), surface_get_height(surf_grass), c_white, c_white, c_white, c_white, false);
	    shader_reset();
	surface_reset_target();

	draw_surface_tiled(surf_grass, 0, 0);
} else {
	surf_grass = surface_create(room_width, room_height);
}