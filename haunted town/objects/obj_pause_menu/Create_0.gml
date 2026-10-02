depth = obj_master.depth - 5000;		// Draw GUI order matters, keep this above everything
application_surface_draw_enable(false);

//global.paused = false;
blend = 0;                            // eased 0..1, real time
sel = 0;
sel_y = 0;
stack = [];

fx_amount = shader_get_uniform(sh_pause_fx, "u_amount");
fx_texel  = shader_get_uniform(sh_pause_fx, "u_texel");

menu_push = function(_items) { array_push(stack, { items: _items, sel: 0 }); sel = 0; }
menu_pop  = function() {
    array_pop(stack);
    if (array_length(stack) == 0) global.paused = false;
    else sel = stack[array_length(stack)-1].sel;
}

menu_main = [
    menu_button("Resume",   function() { global.paused = false; }),
    menu_button("Settings", function() { menu_push(menu_settings); }),
    menu_button("Quit",     function() { game_end(); })
];

menu_settings = [
    menu_cycle("Display Mode", ["Windowed", "Fullscreen"],
        function() { return window_get_fullscreen(); },
        function(i) { window_set_fullscreen(i == 1); }),
    menu_cycle("Resolution", global.res_labels,
	    function() { return global.opt_res; },
	    function(i) { global.opt_res = i; apply_resolution(); }),
    menu_cycle("VSync", ["Off", "On"],
        function() { return global.opt_vsync; },
        function(i) { global.opt_vsync = i; display_reset(0, i == 1); }),
    menu_slider("Music",
	    function() { return global.opt_music; },
	    function(v) { global.opt_music = v; audio_emitter_gain(global.em_music, sqr(v)); }),
	menu_slider("SFX",
	    function() { return global.opt_sfx; },
	    function(v) { global.opt_sfx = v; audio_emitter_gain(global.em_sfx, sqr(v)); }),
    menu_button("Back", function() { menu_pop(); })
];

// ---- Menu layout: shared by Begin Step, Step and Draw GUI ----
list_top_y         = 300;    // y of the first item
item_spacing       = 72;     // vertical distance between items
item_height        = 64;     // height of each item's hit box and highlight
list_left_x        = 60;     // left edge of the hit box/highlight
text_rest_x        = 80;     // where labels sit once slid in
text_offscreen_x   = -100;   // where labels start before sliding in
control_offset_x   = 360;    // <-- your new value
slider_track_width = 200;    // length of the slider bar

// derived: slider/cycle position at rest, and a row wide enough to cover it
control_rest_x = text_rest_x + 100;
list_right_x   = control_rest_x + slider_track_width + 40;   // 40px margin

sel_y = list_top_y;          // start the highlight bar on the first item, not at y=0