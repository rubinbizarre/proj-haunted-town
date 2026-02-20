// define supported resolutions
res_options = [
    { w: 1280, h: 720},
    { w: 1600, h: 900},
    { w: 1920, h: 1080},
    { w: 2560, h: 1440},
	{ w: 3840, h: 2160}
];

// define display modes
mode_options = ["Windowed", "Fullscreen", "Borderless"];

// selection trackers
//res_index = 2;   // default to 1920x1080
//prev_res_index = res_index;
prev_res_index = global.res_index;
//mode_index = 0;  // default to Windowed
//prev_mode_index = mode_index;
prev_mode_index = global.mode_index;

menu_index = 0;

var _w = string(res_options[prev_res_index].w);
var _h = string(res_options[prev_res_index].h);
// define resolution string name to display e.g. 1920x1080
res_name = _w + "x" + _h;