var w = display_get_gui_width();
var h = display_get_gui_height();

shader_set(sh_vignette);
shader_set_uniform_f(u_intensity, vig_strength);
//shader_set_uniform_f(u_inner, 0.35);
//shader_set_uniform_f(u_outer, 0.85);
shader_set_uniform_f(u_inner, 0.6);
shader_set_uniform_f(u_outer, 1.2);

draw_primitive_begin_texture(pr_trianglestrip, -1);
draw_vertex_texture(0, 0, 0, 0);
draw_vertex_texture(w, 0, 1, 0);
draw_vertex_texture(0, h, 0, 1);
draw_vertex_texture(w, h, 1, 1);
draw_primitive_end();

shader_reset();