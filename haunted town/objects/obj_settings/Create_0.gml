// define supported resolutions
res_options = [
    { w: 1280, h: 720,  name: "720p" },
    { w: 1600, h: 900,  name: "900p" },
    { w: 1920, h: 1080, name: "1080p" },
    { w: 2560, h: 1440, name: "1440p" },
	{ w: 3840, h: 2160, name: "2160p" },
];

// define display modes
mode_options = ["Windowed", "Fullscreen", "Borderless"];

// selection trackers
res_index = 2;   // default to 1920x1080
mode_index = 0;  // default to Windowed

// define resolution string name to display e.g. 1920x1080
res_name = string(res_options[res_index.w]) + "x" + string(res_options[res_index.h]);