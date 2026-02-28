///@desc delayed reset, or deactivate

deactivate();

// start cooldown period
cooldown_active = true;
//alarm[0] = game_get_speed(gamespeed_fps) * cooldown_timer;

show_debug_message("obj_par_world_objects ALARM[0]: "+string(id)+" deactivated. started cooldown period");