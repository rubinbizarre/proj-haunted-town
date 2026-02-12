///@desc the routine brain

// get the current schedule based on the NPC's type
var _schedule = variable_struct_get(global.routines, routine_type);		// e.g. global.routines.adult
var _time = global.current_time_;										// e.g. 480

// find which part of the routine we are currently in
var _new_state = "";
for (var i = 0; i < array_length(_schedule); i++) {						// loop through states for this routine type. arr_length of global.routines.adult (3 (0,1,2,3))
    var _entry = _schedule[i];											// _entry = global.routines.adult[0] (AT_HOME)
    if (_time >= _entry.start) and (_time < _entry.dest) {				// compares time to AT_HOME start and dest(end)
        _new_state = _entry.state;										// _new_state = AT_HOME state ("AT_HOME")
        break;
    }
}

// if our state has changed, find a new destination
if (_new_state != current_state) {
    current_state = _new_state;
    
    // determine target coordinates based on state
    switch (current_state) {
		case "INSIDE": {
			visible = false;
		} break;
        case "RETURN_HOME": {
			visible = true;
            target_x = home_id.x;
            target_y = home_id.y;
		} break;
        case "PLAY_PARK": {
            visible = true;
            target_x = obj_park_node.x + irandom_range(-obj_park_node.park_spawn_area, obj_park_node.park_spawn_area);
            target_y = obj_park_node.y + irandom_range(-obj_park_node.park_spawn_area, obj_park_node.park_spawn_area);
		} break;
        case "WANDER_TOWN": {
            visible = true;
            // pick a random building that isn't their home
            dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			while (dest_id == home_id) {
				dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			}
            target_x = dest_id.x;
            target_y = dest_id.y; //- (dest_id.sprite_height/4);
			
			//visible = false; // "enter" the house // this does not work as intended
		} break;
		case "WANDER_TOWN_AGAIN": {
            visible = true;
            // pick a random building that isn't their home
            dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			while (dest_id == home_id) {
				dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			}
            target_x = dest_id.x;
            target_y = dest_id.y;
		} break;
        case "VISIT_HAUNTED": {
            visible = true;
            // logic to find the nearest haunted building
            // ...
		} break;
    }
    
    // If we are visible, start moving to the target
    if (visible) {
        if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
            path_start(my_path, move_speed, path_action_stop, true);
        }
    } else {
        path_end();
        x = target_x; // Snap to home if invisible
        y = target_y;
    }
}