shader_set(sh_pause_fx);
shader_set_uniform_f(fx_amount, blend);
shader_set_uniform_f(fx_texel, 1 / surface_get_width(application_surface), 1 / surface_get_height(application_surface));
draw_surface_stretched(application_surface, 0, 0, window_get_width(), window_get_height());
shader_reset();