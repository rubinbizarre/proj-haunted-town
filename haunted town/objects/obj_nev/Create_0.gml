move_speed = 1.6*2;//0.85;
move_speed_init = move_speed;

//move_speed_rush = 1.6;

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
ac_speed_bob = 0.08/2;//0.1;

glance_counter = 0;
glance_delay = 0.3;//0.4;//0.8;

my_path = path_add();

// after short delay make him glance the other way before looking back
alarm[0] = game_get_speed(gamespeed_fps) * glance_delay;

gear = instance_create_layer(x + 8, y - 26, "Master", obj_nev_gear);
gear.depth = depth - 1;
//gear.image_index = global.nev_gear_tier; // gear sets its own image_index now

//detect_radius = 200;
//todo_queue = [];
//current_target = noone;

// for detecting currently haunted things at any point while nev is outside, within detect_radius
check_timer = irandom(60);
check_interval = 60;

following = false;

current_building = noone;
is_inside = false;

off_path = false;

survey_timer = 2; // seconds
finished_surveying = false;

ps_subs = instance_create_layer(x, y - sprite_get_height(sprite_index), layer, obj_ps_sub_feedback);

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
	
function sort_todo_queue_by_distance() {
    //// 1. capture Nev's current position in local variables
    //var _nx = x;
    //var _ny = y;

    // 2. sort the global array
    array_sort(global.nev_todo_queue, function(_element_a, _element_b) {
        // safety check: ensure both instances still exist
        if (!instance_exists(_element_a)) return 1;
        if (!instance_exists(_element_b)) return -1;

        // calculate distances
        var _dist_a = point_distance(x, y, _element_a.x, _element_a.y);
        var _dist_b = point_distance(x, y, _element_b.x, _element_b.y);

        // return: 
        // negative if A is closer (moves A toward the start)
        // positive if B is closer (moves B toward the start)
        return _dist_a - _dist_b;
    });
}

function check_for_paranormal_nev() {
	#region check for all detectable objects
	var _list = ds_list_create();
	var _num = collision_circle_list(x, y, global.nev_detect_radius, obj_par_detectable, false, true, _list, false);
		
	for (var i = 0; i < _num; i++) {
		var _inst = _list[| i];
		var _should_add = false;
			
		// now determine if the detected object should be added to the todo_queue
			
		// check for haunted world-objects
		if (object_is_ancestor(_inst.object_index, obj_par_world_objects)) {
			if (variable_instance_exists(_inst, "haunted")) {
				if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (!_inst.locked) {
					_should_add = true;
					show_debug_message("obj_nev CREATE: check_for_paranormal_nev(): "+current_state+": adding haunted world-object: "+string(_inst.id));
				}
			}
		}
		// check for haunted buildings
		if (object_is_ancestor(_inst.object_index, obj_par_building)) {
			if (variable_instance_exists(_inst, "haunted")) {
				if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (_inst.stats.owned) {
					_should_add = true;
					show_debug_message("obj_nev CREATE: check_for_paranormal_nev(): "+current_state+": adding haunted building: "+string(_inst.id));
				}
			}
		}
		// check for haunted scary-objects
		if (object_is_ancestor(_inst.object_index, obj_par_scary_objects)) {
			if (variable_instance_exists(_inst, "haunted")) {
				if (_inst.haunted) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) and (!_inst.locked) {
					_should_add = true;
					
					alarm[2] = -1; // found POI so cancel auto-leave: for when nothing is actively haunted inside
					
					current_state = "APPROACH_POI";
					var _xoffset = 30/1.5;
					var _yoffset = 30/3;
					target_x = _inst.x + irandom_range(-_xoffset, _xoffset);
					target_y = _inst.y + irandom_range(_inst.y, _yoffset);
					path_clear_points(my_path);
		            path_add_point(my_path, x, y, 100);
		            path_add_point(my_path, target_x, target_y, 100);
		            path_start(my_path, move_speed, path_action_stop, true);
					
					show_debug_message("obj_nev CREATE: check_for_paranormal_nev(): "+current_state+": adding haunted scary-object: "+string(_inst.id));
					show_debug_message("obj_nev CREATE: check_for_paranormal_nev(): "+current_state+": started path moving towards scary-object: "+string(_inst.id));
				}
			}
		}
		// check for possessed npcs
		if (object_is_ancestor(_inst.object_index, obj_par_npc)) {
			if (variable_instance_exists(_inst, "possessed")) {
				if (_inst.possessed) and (!array_contains(global.nev_todo_queue, _inst)) and (_inst != global.nev_current_target) {
					_should_add = true;
					show_debug_message("obj_nev CREATE: check_for_paranormal_nev(): "+current_state+": adding possessed npc: "+string(_inst.id));
				}
			}
		}
			
		/// if should add this object inst to the todo_queue, add it
		if (_should_add) {
			array_push(global.nev_todo_queue, _inst);
			show_debug_message("obj_nev CREATE: check_for_paranormal_nev(): "+current_state+": pushed inst to todo_queue ("+string(array_length(global.nev_todo_queue))+" total): "+string(_inst.id));
		}
	}
	ds_list_destroy(_list);
	#endregion
}

function move_along_path_to_target(_target) {
	#region move nev to target while obeying collision
	// first determine what xoffset and yoffset should be
	var _xoffset = 0;
	var _yoffset = 0;
	if (object_is_ancestor(_target.object_index, obj_par_npc)) {
		// if the target is an npc, don't bother with the do...until
		following = true;
		target_x = _target.x;
		target_y = _target.y;
	} else if (object_is_ancestor(_target.object_index, obj_par_building)) {
		target_x = _target.x;
		target_y = _target.y;
	} else if (object_is_ancestor(_target.object_index, obj_par_scary_objects)) {
		_xoffset = 30/1.5;
		_yoffset = 30/3;
		target_x = _target.x + irandom_range(-_xoffset, _xoffset);
		target_y = _target.y + irandom_range(-_yoffset, _yoffset);
	} else if (object_is_ancestor(_target.object_index, obj_par_world_objects)) {
		//_xoffset = _target.haunt_radius/1.5;
		//_yoffset = _target.haunt_radius/3;
		
		var _path_node = instance_nearest(_target.x, _target.y, obj_node_circuit);
		target_x = _path_node.x;
		target_y = _path_node.y;
	} else {
		//_xoffset = 0;
		//_yoffset = 0;
		////do {
		//    target_x = _target.x + irandom_range(-_xoffset, _xoffset);
		//    target_y = _target.y + irandom_range(-_yoffset, _yoffset);
		////} until (!place_meeting(target_x, target_y, obj_collision));
		
		show_debug_message("obj_nev CREATE: move_along_path_to_target(): weird target...");
	}
	
	path_clear_points(my_path);
	//path_add_point(my_path, x, y, 100);
	//path_add_point(my_path, target_x, target_y, 100);
	
	if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
	    path_start(my_path, move_speed, path_action_stop, true);
	}
	show_debug_message("obj_nev CREATE: move_along_path_to_target(): "+current_state+": finished executing move_along_path_to_target()");
	#endregion
}

function enter_building() {
	var _b = instance_nearest(x, y, obj_par_building);
	
	// register with the building
	array_push(_b.occupants, id);
	
	current_building = _b;
	is_inside = true;
	//can_move_inside = true;
	off_path = true;
	
	path_end();
	
	prev_town_x = x;
	prev_town_y = y;
	
	// teleport to the void interior entrance for this building specifically: works
	x = _b.interior_x + (_b.interior_width / 2);
	y = _b.interior_y + 85 + (sprite_get_height(spr_interior_0_shack)/2);
	
	//// temporarily place NPCs in random places inside obj_interior collision mask
	//var _margin = sprite_get_width(spr_npc_elderly)/2;
	//var _isprite_w = sprite_get_width(_b.interior_obj.sprite_index)/2;
	//var _isprite_h = sprite_get_height(_b.interior_obj.sprite_index)/2;
	//var _x = irandom_range(
	//	_b.interior_obj.x - (_isprite_w - _margin),
	//	_b.interior_obj.x + (_isprite_w - _margin)
	//);
	//var _y = irandom_range(
	//	_b.interior_obj.y,
	//	_b.interior_obj.y + (_isprite_h - 5)
	//);
	//x = _x;
	//y = _y;
	/*
		also valid option: (which replaces the above block with vars entirely)
		var _i = _b.interior_obj;
		var _x = irandom_range(_i.bbox_left, _i.bbox_right);
		var _y = irandom_range(_i.bbox_top, _i.bbox_bottom);
	*/
	
	alarm[2] = game_get_speed(gamespeed_fps) * 2; // leave after 2 secs if nothing is haunted
}

function leave_building() {
	// remove self from the building's occupants array
    for (var i = 0; i < array_length(current_building.occupants); i++) {
        if (current_building.occupants[i] == id) {
            array_delete(current_building.occupants, i, 1);
            break;
        }
    }
	
    // teleport back to the town from whence npc came
    x = prev_town_x;
    y = prev_town_y;
	
    // cleanup variables
    is_inside = false;
    current_building = noone;
	//can_move_inside = false;
	//target_x = 0;
	//target_y = 0;
	//target_obj = noone;
	
	//// check routine and do it
	//event_user(1);
}

function survey_action() {
	#region nev's survey action / animation
	//show_debug_message("obj_nev CREATE: survey_action(): "+current_state+": now switching to surveying the POI.");
    current_state = "SURVEY_POI";
	
	finished_surveying = false;
	
	if (following) following = false;
			
    // make sure nev's sprite and gear faces the POI
	if (x > global.nev_current_target.x) {
		image_xscale = -1;
		gear.x = x - 8;
		gear.image_xscale = -1;
	} else {
		image_xscale = 1;
		gear.x = x + 8;
		gear.image_xscale = 1;
	}
			
    // gear use logic
	switch (global.nev_gear_tier) {
		case 0: {
	        with instance_create_layer(gear.x, gear.y, "Master", obj_gear_anim) { 
	            depth = other.gear.depth - 1; 
	        }
			// play sound (camera in use)
			//...
		} break;
		//...
    }
	
	alarm[3] = game_get_speed(gamespeed_fps) * survey_timer;
	
	show_debug_message("obj_nev CREATE: survey_action(): "+current_state+": now surveying the POI.");
	#endregion
}