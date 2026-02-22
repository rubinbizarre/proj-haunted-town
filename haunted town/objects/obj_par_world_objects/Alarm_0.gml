///@desc delayed reset to normal

// reset to normal
sprite_index = sprite_normal;
haunted = false;
// start cooldown period
cooldown_active = true;
alarm[0] = game_get_speed(gamespeed_fps) * cooldown_timer;

show_debug_message("obj_par_world_objects ALARM[1]: "+string(id)+" started cooldown period");