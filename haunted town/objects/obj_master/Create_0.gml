//randomise();

// master
global.debug = true;
global.hud = true;
global.paused = false;

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
		
		// deactivate instances except this one
		instance_deactivate_all(true);
		
		//instance_activate_object(obj_settings);
	} else {
		global.paused = false;
		instance_activate_all();
		destroy_paused_surface();
		//if (instance_exists(obj_button_blank)) {
		//	instance_destroy(obj_button_blank);
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