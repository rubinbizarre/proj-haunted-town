tab_border = 6;
shift_max = (display_get_gui_width() * 0.3) + tab_border;
shift = 0;
shift_speed = 10;
shift_active = false;
display_active = true;
shift_lerp_strength = 0.02;//0.1;
podcast_surface = -1;

// for lerp 'tick up/down' effect
subs_display = 0;
subs_display_strength = 0.01;

// animcurve for slide
ac_channel_slide = animcurve_get_channel(anim_podcast_box_slide, 0);
ac_time_slide = 1;
ac_speed_slide = 0.05;

// rings notification
ring_active = false;
ring_radius = 0;
ring_alpha = 1;
ring_active_2 = false;
ring_radius_2 = 0;
ring_alpha_2 = 1;
ring_speed = 0.1;//0.05;

tab_hover = false;
tab_press = false;
tab_confirm = false;

function toggle_display() {
	display_active = !display_active;
	shift_active = true;
	create_podcast_surface();
}

function instant_hide() {
	display_active = false;
	shift_active = false;
	shift = shift_max;
}

function destroy_podcast_surface() {
	// free paused surface from memory
	if (surface_exists(podcast_surface)) {
		surface_free(podcast_surface);
		podcast_surface = -1;
	}
}
function create_podcast_surface() {
	// capture surface before deactivating all instances
	if (!surface_exists(podcast_surface)) {
		podcast_surface = surface_create(display_get_gui_width(), display_get_gui_height());
		surface_copy(podcast_surface, 0, 0, application_surface);
	}
}

function activate_rings_notif() {
	ring_active = false;
	ring_radius = 0;
	ring_alpha = 1;
	ring_active_2 = false;
	ring_radius_2 = 0;
	ring_alpha_2 = 1;
	
	// play sound (notif alert sound)
	//...
	
	// trigger draw second circle
	alarm[0] = game_get_speed(gamespeed_fps) * 0.33;
	
	// draw ding circle 1
	ring_active = true;
}