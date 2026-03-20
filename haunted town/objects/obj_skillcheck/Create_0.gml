var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

margin = 50;
x1 = margin;
x2 = _gui_w - margin;
y1 = _gui_h - (margin*2) - 50;
y2 = _gui_h - (margin*2);

win_zone_radius = 200;
win_zone_x1 = (_gui_w/2) - win_zone_radius;
win_zone_x2 = (_gui_w/2) + win_zone_radius;
win_zone_h = 7;

cursor_x = x1;
cursor_y = (y1 + y2) / 2;
cursor_w = 6;
cursor_h = 50;
cursor_outline_w = 6;

cursor_start = false;
cursor_freeze = false;

cursor_speed = 15;

countdown_display = false;
countdown_value = 3;

//// queue displaying number countdown
//alarm[0] = game_get_speed(gamespeed_fps) * 2;

function trigger() {
	if (!cursor_start) and (!cursor_freeze) {
		// start moving the cursor along the bar; see step event
		cursor_start = true;
		// subtract spent haunt points from total
		global.haunt_points -= global.offered_haunt_points;
	} else if (cursor_start) and (!cursor_freeze) {
		cursor_start = false;
		cursor_freeze = true;
	}
}