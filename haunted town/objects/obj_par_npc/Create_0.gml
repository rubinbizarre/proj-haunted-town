// identity and key vars for pathing movement
routine_type = "adult"; // kid, adult, tourist, etc
move_speed = 1; //during testing. 1 or 2 might be optimal. //1; //0.5;//0.25;
move_speed_init = move_speed; // saves us from re-entering value of move_speed in step event
/* move_speed should be tied to time_speed_actual. */
home_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1)); // store the id of this npc's home
//target_id = noone; // store the id of this npc's target/destination

// state and pathing vars
current_state = "INSIDE";
my_path = path_add();
path_set_kind(my_path, 0);
dest_id = noone;
target_x = 0;
target_y = 0;

scale_init = image_xscale;

x = home_id.x;
y = home_id.y;

//visible = false;

// optimisation
check_timer = irandom(30); // stagger initial checks so npcs don't all think/execute logic at once
check_interval = 60; // check routine every 1 sec at 60 fps

/* for using when npc's state changes
if (mp_grid_path(global.village_grid, my_path, x, y, target_x, target_y, true)) {
    path_start(my_path, walk_speed, path_action_stop, true);
}
*/

#region loosely copied from berry cow farm's obj_par_cow create event
//enum NPC_STATE {
//	IDLE,
//	WALKING,
//}

//npc_state = NPC_STATE.WALKING;

//delay_idle = 2;
//delay_walking = 3;

// parameters used in movement calculation
//x_end = 0;
//y_end = 0;
//dir = 0;
//dist = 0;

// movement ranges determine how far the npc moves when walking
// initialised here with default values but can be overwritten by each npc object individually
//x_range_min = 20; x_range_max = 50;
//y_range_min = 20; y_range_max = 50;

// set shadow parameters if drawing ellipse shadows in draw event
//shadow_width = 20;
//shadow_height = 5;

// set sprites for various states
// note: this may instead be changed to boolean flags, as it looks like
// most of the animation will be done with simple scale changes and tweens
//sprite_idle = sprite_index;
//sprite_walking = sprite_index;
#endregion