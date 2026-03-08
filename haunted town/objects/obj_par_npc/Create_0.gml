// identity and key vars for pathing movement
routine_type = "adult"; // kid, adult, tourist, etc
move_speed = 1; //during testing. 1 or 2 might be optimal. //1; //0.5;//0.25;
move_speed_init = move_speed; // saves us from re-entering value of move_speed in step event
/* move_speed is affected tied to time_speed_actual. */

// home should not be a haunted building.
// technically game starts with zero haunted buildings so this is a non issue
// maybe the church and hotel should be excluded though
do {
	home_obj = instance_find(obj_par_building, irandom(instance_number(obj_par_building)-1)); // store the id of this npc's home
} until (
	(home_obj.sprite_index != spr_building_church) or
	(home_obj.sprite_index != spr_building_hotel)
);
//variable_struct_get(home_obj.stats, owned) == false);
//home_obj.stats.owned == false);

//target_obj = noone; // store the id of this npc's target/destination

// state and pathing vars
current_state = "INSIDE";
my_path = path_add();
path_set_kind(my_path, 0);
path_set_closed(my_path, false);
target_obj = noone;
target_x = 0;
target_y = 0;

scale_init = image_xscale;

// when created, set x,y to home_obj x,y
x = home_obj.x;
y = home_obj.y;

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

fear = 0.0; // ranges from 0-1
fear_gain = 0.1;
death = false;
spooked = false;
prev_xscale = 1;

prev_path_speed = 0;
prev_move_speed = 0;
hit_by_van = false;

my_path_duplicate = path_add();
iframes = false;

is_inside = false;
prev_town_x = 0;
prev_town_y = 0;
current_building = noone;
move_timer = 0;
move_inside = false;
can_move_inside = false;
routine_timer = 0;
inside_x = 0;
inside_y = 0;
wait_timer = choose(180, 240);
inside_range_min = 5;
inside_range_max = 15;
inside_dir = 0;
inside_dist = 0;

shake_init_pos_stored = false;
shake_init_x = 0;
shake_init_y = 0;
shake_intensity = 0.5;

fear_drain = false;
fear_drain_interval = 60;
fear_drain_timer = fear_drain_interval;

// FUNCTIONS

function increase_fear() {
	fear += fear_gain;
	fear = clamp(fear, 0, 1);
	if (image_index != 2) image_index = 2;
	if (alarm[3] != -1) alarm[3] = -1;
	if (fear_drain) fear_drain = false;
	
	if (fear >= 0.8) and (current_state != "SCARED_STIFF") {
		current_state = "SCARED_STIFF";
	}
	if (fear >= 1) {
		// start alarm timer which when triggered begins to drain fear
		// when fear reaches zero, change state to "inside" then check routine
		alarm[3] = game_get_speed(gamespeed_fps) * 7;
		
		show_debug_message("obj_par_npc: "+string(id)+" reached max fear - commencing fear_drain in 5 secs!");
	}
}

function decrease_fear() {
	fear -= fear_gain;
	fear = clamp(fear, 0, 1);
	if (fear <= 0) {
		image_index = 1;
		current_state = "INSIDE";
		
		fear = 0;
		fear_drain = false;
		fear_drain_timer = fear_drain_interval;
		
		// check routine and do it
		event_user(1);
	}
}

function kill() {
	//...
}

function possess() {
	//...
}

function enter_building() {
	var _b = instance_nearest(x, y, obj_par_building);
	
	// register with the building
	array_push(_b.occupants, id);
	
	current_building = _b;
	is_inside = true;
	can_move_inside = true;
	
	path_end();
	
	prev_town_x = x;
	prev_town_y = y;
	
	//// teleport to the void interior for this building specifically: works
	//x = _b.interior_x + (_b.interior_width / 2);
	//y = _b.interior_y + 85 + (sprite_get_height(spr_interior_0_shack)/2);
	
	// temporarily place NPCs in random places inside obj_interior collision mask
	var _margin = sprite_get_width(spr_npc_elderly)/2;
	var _isprite_w = sprite_get_width(_b.interior_obj.sprite_index)/2;
	var _isprite_h = sprite_get_height(_b.interior_obj.sprite_index)/2;
	var _x = irandom_range(
		_b.interior_obj.x - (_isprite_w - _margin),
		_b.interior_obj.x + (_isprite_w - _margin)
	);
	var _y = irandom_range(
		_b.interior_obj.y,
		_b.interior_obj.y + (_isprite_h - 5)
	);
	/*
		also valid option: (which replaces the above block with vars entirely)
		var _i = _b.interior_obj;
		var _x = irandom_range(_i.bbox_left, _i.bbox_right);
		var _y = irandom_range(_i.bbox_top, _i.bbox_bottom);
	*/
	
	x = _x;
	y = _y;
}

function leave_building() {
	// remove self from the building's occupants array
    for (var i = 0; i < array_length(current_building.occupants); i++) {
        if (current_building.occupants[i] == id) {
            array_delete(current_building.occupants, i, 1);
            break;
        }
    }

    // teleport back to the town from whence npc came
    x = prev_town_x;
    y = prev_town_y;
    
	// make npc not scared anymore; reset to normal
	image_index = 0;
	fear = 0;
	
    // cleanup variables
    is_inside = false;
    current_building = noone;
	can_move_inside = false;
	target_x = 0;
	target_y = 0;
	target_obj = noone;
	
	// check routine and do it
	event_user(1);
}