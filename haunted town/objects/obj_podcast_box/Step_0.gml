#region handle click input on tab button - working sorta
// known issue: clicking also affects objects underneath the GUI layer in the world, this needs addressing
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _surf_w = surface_get_width(podcast_surface);
var _surf_h = surface_get_height(podcast_surface);
var _tab_w = 128;
var _tab_h = 128;
var _tab_x2 = (_surf_w * 0.72) ;
var _tab_x1 = (_tab_x2 - _tab_w);
var _tab_y1 = 32;
var _tab_y2 = _tab_y1 + _tab_h;
tab_hover = point_in_rectangle(_mx, _my,
	_tab_x1 + (shift),
	_tab_y1,
	_tab_x2 + (shift),
	_tab_y2
);
if (mouse_check_button_pressed(mb_left) and tab_hover) {
    tab_press = true;
}
if (tab_press and !tab_hover) {
	tab_press = false;
}
if (mouse_check_button_released(mb_left) and tab_press and tab_hover) {
	// confirm input
	tab_press = false;
	tab_hover = false;
	toggle_display();
}
#endregion

if (shift_active) {
	if (!display_active) {
		ac_time_slide = 0;
		shift_active = false;
	} else {
		ac_time_slide = 0;
		shift_active = false;
	}
}

// play through animcurve once
if (ac_time_slide < 1) {
	ac_time_slide += ac_speed_slide;
}
var _ac_value = animcurve_channel_evaluate(ac_channel_slide, ac_time_slide);
// apply animcurve value to shift (xpos)
if (!display_active) {
	shift = shift_max * _ac_value;
} else {
	shift = shift_max * (1 - _ac_value);
}

#region handle displaying subs with tick up/down lerp effect
var _subs = global.subs;
if (subs_display != _subs) {
	// depending on how fast you want the display val to catch up
	var _new_subs_display = round(lerp(subs_display, _subs, subs_display_strength));

	// if the increment is large enough to make a difference, use the newly calculated val
	// otherwise, move the display val 1 unit closer towards the actual val
	if (_new_subs_display != subs_display) {
		subs_display = _new_subs_display;
	} else {
		subs_display += sign(_subs - subs_display);
	}
}
#endregion

#region handle affecting rings notification behaviour/values
if (ring_active) {
	ring_radius += 1;
	if (ring_radius > 100) {
		ring_alpha -= ring_speed;
	}
	if (ring_alpha <= 0) {
		ring_active = false;
		ring_radius = 0;
		ring_alpha = 1;
	}
}
if (ring_active_2) {
	ring_radius_2 += 1;
	if (ring_radius_2 > 100) {
		ring_alpha_2 -= ring_speed;
	}
	if (ring_alpha_2 <= 0) {
		ring_active_2 = false;
		ring_radius_2 = 0;
		ring_alpha_2 = 1;
	}
}
#endregion