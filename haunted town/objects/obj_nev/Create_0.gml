move_speed = 0.85;
move_speed_init = move_speed;

scale_init = image_xscale;

return_pos_x = 0;
return_pos_y = 0;

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
glance_delay = 1;

my_path = path_add();

// after short delay make him glance the other way before looking back
alarm[0] = game_get_speed(gamespeed_fps) * glance_delay;

gear_tier = 0;
gear = instance_create_layer(x + 8, y - 26, "Instances", obj_nev_gear);
gear.depth = depth - 1;
gear.image_index = gear_tier;

detect_radius = 200;