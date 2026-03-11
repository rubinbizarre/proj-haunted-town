amount = ""; // e.g. -20, +100, etc.
fading = false;
alpha = 1;
ascent_speed = 0.25;
if (global.building_view_inside) ascent_speed /= 2;
fade_speed = 0.025;
c = global.c_haunt;//c_white;

// start fading after short delay
alarm[0] = game_get_speed(gamespeed_fps) * 0.8;