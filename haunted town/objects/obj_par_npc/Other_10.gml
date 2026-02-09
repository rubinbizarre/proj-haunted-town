///@desc the routine brain

// get the current schedule based on the NPC's type
var _schedule = variable_struct_get(global.routines, routine_type);
var _time = global.current_time_; 

// find which part of the routine we are currently in
var _new_state = "";
for (var i = 0; i < array_length(_schedule); i++) {
    var _entry = _schedule[i];
    if (_time >= _entry.start && _time < _entry.dest) {
        _new_state = _entry.state;
        break;
    }
}

// if our state has changed, find a new destination
if (_new_state != current_state) {
    current_state = _new_state;
    
    // determine target coordinates based on state
    switch (current_state) {
        case "AT_HOME": {
            target_x = home_id.x;
            target_y = home_id.y;
            visible = false; // "enter" the house
		} break;
        case "PLAY_PARK": {
            visible = true;
            target_x = obj_park_node.x + irandom_range(-32, 32);
            target_y = obj_park_node.y + irandom_range(-32, 32);
		} break;
        case "WANDER_TOWN": {
            visible = true;
            // pick a random building that isn't their home
            //var _dest = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			//while (_dest == home_id) {
			//	_dest = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			//}
            //target_x = _dest.x;
            //target_y = _dest.y;
			
			dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			while (dest_id == home_id) {
				dest_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1));
			}
            target_x = dest_id.x;
            target_y = dest_id.y; //- (dest_id.sprite_height/4);
			
			//visible = false; // "enter" the house // this does not work as intended
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