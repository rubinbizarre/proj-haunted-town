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
//global.hour_progress_multiplier = 100 / 60; // used in script for finding date and time to convert hour_progression to actual_minutes
global.tracked_building = noone; // not used?
global.menu_haunt_active = false; // not used?
global.tracked_npc = noone; // not used?
global.menu_npc_active = false; // not used
global.haunt_difficulty = 0; // not used? used by obj_skillcheck
global.offered_haunt_points = 0; // not used? used by obj_skillcheck

global.haunt_points = 30;
global.lifetime_haunt_points = 0;
global.super_haunt_ready = false;
global.super_haunt_active = false;
global.super_haunt_threshold_index = 0;
global.super_haunt_threshold = [
	50,
	100,
	200,
	999
];

global.display_end_of_day = false;
global.display_podcast = false;
global.display_breakdown = false;

global.building_view_inside = false;

global.total_paranormal_events = 0;
global.total_possessions = 0;
global.total_kills = 0;

global.active_haunts = 0;

global.total_buildings_purchased = 0;
global.total_buildings_available = 24;
global.total_wo_unlocked = 0;
global.total_so_unlocked = 0;

//global.tb = noone;
global.summary_box = noone; // see room start

// initialise cursor
window_set_cursor(cr_none);
//cursor_sprite = spr_cursor_default;
global.my_cursor_sprite = spr_cursor_default;

// for virtual cursor / controller
global.vcursor_room_x = 0;
global.vcursor_room_y = 0;
global.vcursor_gui_x = display_get_gui_width() / 2;
global.vcursor_gui_y = display_get_gui_height() / 2;
global.using_gamepad_cursor = false; // tracks which input last moved the cursor
global.last_mouse_x = mouse_x;
global.last_mouse_y = mouse_y;

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

objective = "Spook Nev"; // "Earn a Super Haunt"; "Spook Nev"; "Haunt the Town";

// --- SUPER HAUNT TIMER
timer_super_haunt_max = 0.5;//1; // determines length of time between lifetime hp decrements
timer_super_haunt_cur = -1;

// --- SUPER HAUNT PULSATE EFFECT (see draw gui event)
sh_alpha = 0;
sh_rect_offset = 0;
sh_rect_rate = 3;

sh_lock_list = [];

//areas_unlocked = 1;

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
	global.my_cursor_sprite = spr_cursor_default;
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
	
function disable_super_haunt() {
	global.super_haunt_active = false;
	// deactivate all currently haunted world- and scary-objects
	// right now it just deactivates all of the instances even if they are not active?
	for (var _i = 0; _i < instance_number(obj_par_world_objects); _i++) {
		var _inst = instance_find(obj_par_world_objects, _i);
		if (_inst.haunted) _inst.deactivate();
	}
	for (var _i = 0; _i < instance_number(obj_par_scary_objects); _i++) {
		var _inst = instance_find(obj_par_scary_objects, _i);
		if (_inst.haunted) _inst.deactivate();
	}
	// lock objects that were temporarily unlocked for the superhaunt
	for (var _i = 0; _i < array_length(sh_lock_list); _i++) {
		var _inst = array_get(sh_lock_list, _i);
		_inst.locked = true;
		_inst.ps_owned.stop();
		//show_debug_message("obj_master STEP: locked "+string(id)+" from sh_lock_list[]");
	}
	// now make nev return to normal:
	// copy key values to pass over
	var _x, _y, _depth, _return_van_x, _return_van_y, _return_path_x, _return_path_y;
	if (instance_exists(obj_nev_scared)) {
		_x = obj_nev_scared.x;
		_y = obj_nev_scared.y;
		_depth = obj_nev_scared.depth;
		_return_van_x = obj_nev_scared.return_van_x;
		_return_van_y = obj_nev_scared.return_van_y;
		_return_path_x = obj_nev_scared.return_path_x;
		_return_path_y = obj_nev_scared.return_path_y;
		// destroying nev_scared also destroys ps_scared
		instance_destroy(obj_nev_scared);
	}
	// clear todo queue
	var _arr = global.nev_todo_queue;
	var _n = array_length(_arr);
	array_delete(_arr, 0, _n);
	// create nev inst that is sure to return to van
	with instance_create_depth(_x, _y, _depth, obj_nev) {
		// target nearest path node to travel to first
		var _target = instance_nearest(x, y, obj_node_circuit);
		target_x = _target.x;
		target_y = _target.y;
		// assign variable values passed from nev_scared
		return_van_x = _return_van_x;
		return_van_y = _return_van_y;
		return_path_x = _return_path_x;
		return_path_y = _return_path_y;
		// assign state
		current_state = "SURVEY_POI";
		// ensure correct behaviour
		finished_surveying = true;
		timer_glance_cur = -1; // turn this timer off. by default it is activated in nev's create event, and causes the glance to occur which resets the return_path_x,y values
	}
}