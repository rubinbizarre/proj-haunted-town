///@desc disable spooked status
spooked = false;
ac_time_spook = 0;
image_index = 0;
image_xscale = prev_xscale; // face the same way as before being spooked

my_path = my_path_duplicate;

if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
	path_start(my_path, move_speed, path_action_stop, true);
}

//show_debug_message("obj_par_npc ALARM[0]: "+string(id)+" recovered from being spooked");