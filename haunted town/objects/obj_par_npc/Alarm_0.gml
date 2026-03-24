///@desc disable spooked status OR go inside while enticed

//if (spooked) {
//	spooked = false;
//	ac_time_spook = 0;
//	image_index = 0;
//	image_xscale = prev_xscale; // face the same way as before being spooked
	
//	my_path = my_path_duplicate;
//	if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
//		path_start(my_path, move_speed, path_action_stop, true);
//	}

//	//show_debug_message("obj_par_npc ALARM[0]: "+string(id)+" recovered from being spooked");
//}

//if (current_state == "ENTICED") {
//	image_index = 0;
	
//	var _start_x = x;
//	var _start_y = y;
	
//	//var _hbuilding = instance_nearest(x, y, obj_par_building);
//	//target_x = _hbuilding.x;
//	//target_y = _hbuilding.y;
	
//	if (!path_exists(my_path)) {
//		my_path = path_add();
//		path_set_kind(my_path, 0);
//		path_set_closed(my_path, false);
//	}
	
//	path_add_point(my_path, _start_x, _start_y, 100);
//	path_add_point(my_path, target_x, target_y, 100);
	
//	if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
//		path_start(my_path, move_speed, path_action_stop, true);
//	}
//}