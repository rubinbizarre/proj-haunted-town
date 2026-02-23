///@desc delayed reset, or deactivate

// reset to normal, or deactivate
sprite_index = sprite_normal;
haunted = false;

// avoid memory leaks; forget all ids which entered/left while haunted
ds_list_destroy(current_list);
ds_list_destroy(last_list);

// start cooldown period
cooldown_active = true;
//alarm[0] = game_get_speed(gamespeed_fps) * cooldown_timer;

show_debug_message("obj_par_world_objects ALARM[0]: "+string(id)+" started cooldown period");