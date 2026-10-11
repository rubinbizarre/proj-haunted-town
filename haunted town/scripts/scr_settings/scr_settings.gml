// scr_settings
function settings_load() {
    var _first_launch = !file_exists("settings.ini");
    var _mon_w = display_get_width();
    var _mon_h = display_get_height();

    ini_open("settings.ini");
    global.opt_fullscreen = ini_read_real("display", "fullscreen", 1);
    global.opt_res        = ini_read_real("display", "res",        settings_find_res(_mon_w, _mon_h));
    global.opt_vsync      = ini_read_real("display", "vsync",      1);
    global.opt_music      = ini_read_real("audio",   "music",      0.7);
    global.opt_sfx        = ini_read_real("audio",   "sfx",        0.8);
    ini_close();

    global.opt_res = clamp(global.opt_res, 0, array_length(global.res_list) - 1);

    // saved res no longer fits (different monitor / changed list): re-pick from the monitor
    var _r = global.res_list[global.opt_res];
    if (!_first_launch && (_r[0] > _mon_w || _r[1] > _mon_h)) {
        global.opt_res = settings_find_res(_mon_w, _mon_h);
    }

    // persist the first-launch defaults so the next launch loads them as saved settings
    if (_first_launch) settings_save();
}

/// exact monitor match if the list has one, otherwise the largest entry that fits inside it
function settings_find_res(_w, _h) {
    var _best = 0, _best_area = -1;
    for (var i = 0; i < array_length(global.res_list); i++) {
        var _r = global.res_list[i];
        if (_r[0] == _w && _r[1] == _h) return i;
        if (_r[0] <= _w && _r[1] <= _h && _r[0] * _r[1] > _best_area) {
            _best = i;
            _best_area = _r[0] * _r[1];
        }
    }
    return _best;
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