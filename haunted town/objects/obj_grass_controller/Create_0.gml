surf_grass = surface_create(room_width, room_height);
uni_time   = shader_get_uniform(shd_grass, "u_time");
uni_res    = shader_get_uniform(shd_grass, "u_resolution");
timer      = 0;