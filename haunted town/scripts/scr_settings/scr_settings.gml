// scr_settings
function settings_load() {
    ini_open("settings.ini");
    global.opt_fullscreen = ini_read_real("display", "fullscreen", 0);
    global.opt_res        = ini_read_real("display", "res",        2);    // index into resolution list
	global.opt_res = clamp(global.opt_res, 0, array_length(global.res_list) - 1);
    global.opt_vsync      = ini_read_real("display", "vsync",      1);
    global.opt_music      = ini_read_real("audio",   "music",      0.7);
    global.opt_sfx        = ini_read_real("audio",   "sfx",        0.8);
    ini_close();
}

function settings_save() {
    ini_open("settings.ini");
    ini_write_real("display", "fullscreen", global.opt_fullscreen);
    ini_write_real("display", "res",        global.opt_res);
    ini_write_real("display", "vsync",      global.opt_vsync);
    ini_write_real("audio",   "music",      global.opt_music);
    ini_write_real("audio",   "sfx",        global.opt_sfx);
    ini_close();
}

function settings_apply() {
    window_set_fullscreen(global.opt_fullscreen == 1);
    apply_resolution();
    display_reset(0, global.opt_vsync == 1);
}