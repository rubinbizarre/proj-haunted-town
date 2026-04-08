//randomise();

// master
global.debug = true;
global.hud = true;
global.paused = false;
global.c_haunt = #cb73ff;

// settings
global.mute_music = false;
global.mute_sfx = false;
global.res_index = 2;
global.mode_index = 0;

// in-game
global.hour_progress_multiplier = 100 / 60; // used in script for finding date and time to convert hour_progression to actual_minutes
global.haunt_points = 30;
global.tracked_building = noone;
global.menu_haunt_active = false;
global.tracked_npc = noone;
global.menu_npc_active = false;
global.haunt_difficulty = 0;
global.offered_haunt_points = 0;

global.display_end_of_day = false;
global.display_podcast = false;
global.display_breakdown = false;

global.building_view_inside = false;

global.total_paranormal_events = 0;
global.total_possessions = 0;
global.total_kills = 0;

global.active_haunts = 0;

//global.tb = noone;
global.summary_box = noone; // see room start

// initialise cursor
window_set_cursor(cr_none);
cursor_sprite = spr_cursor_default;

depth = -10000;

global.font_default = draw_get_font();
paused_surface = -1;
pause_menu_select = 0;

prev_cam_x = 0;
prev_cam_y = 0;
prev_cam_w = 0;
prev_cam_h = 0;
prev_cam_zoom = 0;

hp_display = 0;
hp_display_strength = 0.01;

objective = "Haunt the Town";

function abort_haunt_process() {
	if (global.menu_haunt_active) {
		global.menu_haunt_active = false;
		global.tracked_building = noone;
		global.offered_haunt_points = 0;
		if (instance_exists(obj_skillcheck)) instance_destroy(obj_skillcheck);
	}
}

function toggle_pause() {
	if (!global.paused) {
		global.paused = true;
		
		pause_menu_select = 0;
		
		create_paused_surface();
		
		// modify certain values of objects to prevent any pause cheesing
		// e.g. reset charge value to zero when paused
		//if (instance_exists(obj_player)) {
			// ...
		//}
		
		// create resume button
		//var _cam = obj_camera.cam;
		//var _vx = camera_get_view_x(_cam);
		//var _vy = camera_get_view_y(_cam);
		//var _vw = camera_get_view_width(_cam);
		//var _vh = camera_get_view_height(_cam);
		//var _x = _vx + (_vw/2);
		//var _y = _vy + (_vy/2);
		//with instance_create_layer(_x, _y, "Instances", obj_btn) {
		//	//depth = obj_master.depth - 1000;
		//	sprite_index = spr_btn_resume;
		//}
		//show_debug_message("obj_master CREATE: toggle_pause(): created obj_btn instance at x:"+string(_x)+" y:"+string(_y));
		
		// deactivate all instances except this one
		instance_deactivate_all(true);
		
		//// reactivate button object
		//instance_activate_object(obj_btn);
		
	} else {
		global.paused = false;
		instance_activate_all();
		destroy_paused_surface();
		//// destroy any buttons if they exist
		//if (instance_exists(obj_btn)) {
		//	instance_destroy(obj_btn);
		//}
	}
}
function destroy_paused_surface() {
	// free paused surface from memory
	if (surface_exists(paused_surface)) {
		surface_free(paused_surface);
		paused_surface = -1;
	}
}
function create_paused_surface() {
	// stop panning
	obj_camera.camera_panning = false;
	cursor_sprite = spr_cursor_default;
	// capture surface before deactivating all instances
	if (!surface_exists(paused_surface)) {
		paused_surface = surface_create(display_get_gui_width(), display_get_gui_height());
		surface_copy(paused_surface, 0, 0, application_surface);
	}
}

function toggle_display_end_of_day() {
	if (!global.display_end_of_day) {
		global.display_end_of_day = true;
		global.display_podcast = true;
		obj_podcast_box.instant_hide();
		create_paused_surface();
		instance_deactivate_all(true);
	} else {
		global.display_end_of_day = false;
		
		// reset daily events and subs at day start
		global.daily_events = [];
		global.subs_at_day_start = global.subs; // this is unused?
		global.nev_gear_at_day_start = global.nev_gear_tier;
		
		// reset daily sub gain/loss counters
		global.daily_sub_gain_event_counter = 0;
		global.daily_sub_loss_event_counter = 0;
		
		instance_activate_all();
		destroy_paused_surface();
	}
}

function enter_building_view(building) {
	// disable outside camera movement & world input
	//global.camera_locked = true;
	global.building_view_inside = true;
	
	// save the cam pos to move it back later
	prev_cam_x = camera_get_view_x(view_camera[0]);
	prev_cam_y = camera_get_view_y(view_camera[0]);
	
	// snap the camera to the building's interior coordinates in the void
	var _b = building_to_view;
	camera_set_view_pos(view_camera[0], _b.interior_x, _b.interior_y);
}

function toggle_view_inside(building = noone) {
	if (!global.building_view_inside) {
		// disable outside camera movement & world input
		//global.camera_locked = true;
		global.building_view_inside = true;
	
		// save the cam pos to move it back later
		prev_cam_x = camera_get_view_x(view_camera[0]);
		prev_cam_y = camera_get_view_y(view_camera[0]);
		//// save current zoom setting
		//prev_cam_zoom = obj_camera.zoom_level;
		prev_cam_w = camera_get_view_width(view_camera[0]);
		prev_cam_h = camera_get_view_height(view_camera[0]);
	
		// snap the camera to the building's interior coordinates in the void
		var _b = building;
		camera_set_view_pos(view_camera[0], _b.interior_x, _b.interior_y);
		//// set high zoom level
		//obj_camera.zoom_level = 3;
		camera_set_view_size(view_camera[0], 320, 180);
		
		show_debug_message("obj_master CREATE: toggle_view_inside(): moved cam to x:"+string(_b.interior_x)+", y: "+string(_b.interior_y));
	} else {
		global.building_view_inside = false;

		// snap camera back to the previous cam pos & zoom setting
		camera_set_view_size(view_camera[0], prev_cam_w, prev_cam_h);
		camera_set_view_pos(view_camera[0], prev_cam_x, prev_cam_y);
		//obj_camera.zoom_level = prev_cam_zoom;
		
		// reset prev_cam vars
		prev_cam_x = 0;
		prev_cam_y = 0;
		prev_cam_zoom = 0;
	}
}