///@desc delayed recovery from hit by van

hit_by_van = false;
image_angle = 0;

//path_speed = prev_path_speed;
//prev_path_speed = 0;

//move_speed = prev_move_speed;
//prev_move_speed = 0;

my_path = my_path_duplicate;

if (mp_grid_path(global.town_grid, my_path, x, y, target_x, target_y, true)) {
	path_start(my_path, move_speed, path_action_stop, true);
}

show_debug_message("obj_par_npc ALARM[1]: "+string(id)+" recovered from hit_by_van");