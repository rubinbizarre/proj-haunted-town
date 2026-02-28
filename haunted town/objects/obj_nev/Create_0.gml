move_speed = 0.85;
move_speed_init = move_speed;

scale_init = image_xscale;

return_van_x = 0;
return_van_y = 0;
return_path_x = 0;
return_path_y = 0;

target_x = 0;
target_y = 0;

current_state = "LEAVING_VAN"; // also "APPROACH_POI", "SURVEY_POI"

dest_x = 0;
dest_y = 0;

// animcurve for bobbing whilst moving
ac_channel_bob = animcurve_get_channel(anim_npc_bob, 0);
ac_time_bob = 0;
ac_speed_bob = 0.08;//0.1;

glance_counter = 0;
glance_delay = 0.8;

my_path = path_add();

// after short delay make him glance the other way before looking back
alarm[0] = game_get_speed(gamespeed_fps) * glance_delay;

gear_tier = 0;
gear = instance_create_layer(x + 8, y - 26, "Instances", obj_nev_gear);
gear.depth = depth - 1;
gear.image_index = gear_tier;

detect_radius = 200;
todo_queue = [];
current_target = noone;
// for detecting currently haunted things at any point while nev is outside, within detect_radius
check_timer = irandom(60);
check_interval = 60;

/*
function determine_destination() {
	var _target_inst = noone;
	// target_inst could either be a haunted building, hauntable world object or scary object
	// how likely one is chosen as the target is based on weighted probability tied to the object's infamy stat
	// an object with no infamy is not considered
	// 
	
	// use a do...until to prevent target pos being inside a collision obj, which results in nev not moving
	do {
		target_x = _target_inst.x + irandom_range(-_target_inst.haunt_radius, _target_inst.haunt_radius);
		target_y = _target_inst.y + irandom_range(-_target_inst.haunt_radius, _target_inst.haunt_radius);
	} until (!place_meeting(target_x, target_y, obj_collision));
	// add this point to path
	path_add_point(my_path, target_x, target_y, 100);
	// start moving along path obeying the mp_grid
	if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
		path_start(my_path, move_speed, path_action_stop, true);
	}
}
*/

function check_for_haunted_things() {
	#region unfit code taken from obj_par_world_objects check_for_npcs() (commented)
	/*
	// note:	this was taken from obj_par_world_objects check_for_npcs()
	
	var r = haunt_radius;
	
	if (!ds_exists(list_of_places_to_go, ds_type_list)) {
		list_of_places_to_go = ds_list_create();
	}
	if (!ds_exists(last_list, ds_type_list)) {
		last_list = ds_list_create();
	}
	
	// 1 // clear the current list and find who is inside now
	ds_list_clear(list_of_places_to_go);
	var _num = collision_circle_list(x, y, r, obj_par_world_objects, false, true, list_of_places_to_go, false);

	// 2 // find 'new entries' (in list_of_places_to_go ONLY, not in last_list)
	for (var i = 0; i < ds_list_size(list_of_places_to_go); i++) {
	    var _inst = list_of_places_to_go[| i];
    
	    // if they weren't here last frame, they just ENTERED
	    if (ds_list_find_index(last_list, _inst) == -1) {
			show_debug_message("obj_nev CREATE: check_for_haunted_things(): "+string(_inst)+" entered!");
	    }
	}
	
	//// 3 // find 'exits' (in last_list ONLY, not in current_list)
	//for (var i = 0; i < ds_list_size(last_list); i++) {
	//    var _inst = last_list[| i];
	//    // if they were here last frame but aren't now, they just LEFT
	//    if (ds_list_find_index(current_list, _inst) == -1) {
	//        if (instance_exists(_inst)) {
	//            //_inst.spooked = false; // reset the trigger
	//            show_debug_message("obj_nev CREATE: check_for_haunted_things(): "+string(_inst)+" left!");
	//        }
	//    }
	//}
	
	// 4 // update the memory for the next frame
	ds_list_copy(last_list, current_list);
	*/
	#endregion
	
	
}