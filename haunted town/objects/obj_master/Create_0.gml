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
global.haunt_points = 50;
global.tracked_building = noone;
global.menu_haunt_active = false;
global.tracked_npc = noone;
global.menu_npc_active = false;
global.haunt_difficulty = 0;
global.offered_haunt_points = 0;

font_default = draw_get_font();
paused_surface = -1;
pause_menu_select = 0;

function abort_haunt_process() {
	if (global.menu_haunt_active) {
		global.menu_haunt_active = false;
		global.tracked_building = noone;
		global.offered_haunt_points = 0;
		if (instance_exists(obj_skillcheck)) instance_destroy(obj_skillcheck);
	}
}

function custom_pause() {
	if (!global.paused) {
		global.paused = true;
		
		pause_menu_select = 0;
		
		// capture surface before deactivating all instances
		if (!surface_exists(paused_surface)) {
			paused_surface = surface_create(room_width, room_height);
			surface_copy(paused_surface, 0, 0, application_surface);
		}
		
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
		//show_debug_message("obj_master CREATE: custom_pause(): created obj_btn instance at x:"+string(_x)+" y:"+string(_y));
		
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