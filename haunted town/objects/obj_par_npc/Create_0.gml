// identity and key vars for pathing movement
routine_type = "adult"; // kid, adult, tourist, etc
move_speed = 1; //during testing. 1 or 2 might be optimal. //1; //0.5;//0.25;
move_speed_init = move_speed; // saves us from re-entering value of move_speed in step event
/* move_speed is affected tied to time_speed_actual. */

// home should not be a haunted building.
// technically game starts with zero haunted buildings so this is a non issue
// maybe the church and hotel should be excluded though
do {
	home_id = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1)); // store the id of this npc's home
} until (
	(home_id.sprite_index != spr_building_church) or
	(home_id.sprite_index != spr_building_hotel)
);
//variable_struct_get(home_id.stats, is_haunted) == false);
//home_id.stats.is_haunted == false);

//target_id = noone; // store the id of this npc's target/destination

// state and pathing vars
current_state = "INSIDE";
my_path = path_add();
path_set_kind(my_path, 0);
dest_id = noone;
target_x = 0;
target_y = 0;

scale_init = image_xscale;

// when created, set x,y to home_id x,y
x = home_id.x;
y = home_id.y;

//visible = false;

// optimisation
check_timer = irandom(60);//30); // stagger initial checks so npcs don't all think/execute logic at once
check_interval = 60; // check routine every 1 sec at 60 fps

// animcurve for bobbing whilst moving
ac_channel_bob = animcurve_get_channel(anim_npc_bob, 0);
ac_time_bob = 0;
ac_speed_bob = 0.08;//0.1;

// animcurve for being spooked
ac_channel_spook = animcurve_get_channel(anim_npc_spook, 0);
ac_time_spook = 0;
ac_speed_spook = 0.05;

fear = 0.0;
death = false;
spooked = false;
prev_path_speed = 0;

// FUNCTIONS

function increase_fear() {
	//...
}

function kill() {
	//...
}

function possess() {
	//...
}