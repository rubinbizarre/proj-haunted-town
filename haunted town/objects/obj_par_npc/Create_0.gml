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

soul_flame = noone;
btn_possess = noone;
btn_kill = noone;

possessed = false;
possess_transition = false;
possess_timer = 180;
possess_timer_init = possess_timer;
possess_shake_intensity = 1.5;
possessed_radius = 40;
//possessed_building = noone; // store building id where npc was possessed so that 'remote-enticing' takes npcs to the same building
// ds lists for checking for npc collisions while possessed
current_list = ds_list_create();
last_list = ds_list_create();

dying = false;
dying_ascent_speed = 0.05;
dying_fade_speed = 0.01;

name_str = "unnamed-npc";
note_str_credit = "note-credit";
note_str_discredit = "note-discredit";

// FUNCTIONS

function increase_fear() {
	fear += fear_gain;
	fear = clamp(fear, 0, 1);
	if (image_index != 2) image_index = 2;
	if (alarm[3] != -1) alarm[3] = -1;
	if (fear_drain) fear_drain = false;
	
	// when fear is 0.8 or higher
	if (fear >= 0.8) and (current_state != "SCARED_STIFF") {
		// change state to scared_stiff
		current_state = "SCARED_STIFF";
		
		// create 'soul flame' instance
		var _ymod = sprite_get_height(sprite_index)/2;
		if (sprite_index == spr_npc_kid) _ymod = round(_ymod / 1.8);
		if (!instance_exists(soul_flame)) soul_flame = instance_create_depth(x, y - _ymod, depth-1, obj_flame_soul);
	}
	
	// start alarm timer which when triggered begins to drain fear
	// when fear reaches zero, change state to "inside" then check routine
	alarm[3] = game_get_speed(gamespeed_fps) * 7;
		
	//show_debug_message("obj_par_npc: "+string(id)+" reached max fear - commencing fear_drain in 5 secs!");
}

function decrease_fear() {
	fear -= fear_gain;
	fear = clamp(fear, 0, 1);
	
	// when fear is 0.7 or less, and destroy soul flame if exists
	if (fear <= 0.7) {
		if (instance_exists(soul_flame)) instance_destroy(soul_flame); soul_flame = noone;
		if (instance_exists(btn_possess)) instance_destroy(btn_possess); btn_possess = noone;
		if (instance_exists(btn_kill)) instance_destroy(btn_kill); btn_kill = noone;
	}
	
	// when fear returns to 0
	if (fear <= 0) {
		// change state to inside, appear normal
		image_index = 0;
		current_state = "INSIDE";
		
		// cleanup
		fear = 0;
		fear_drain = false;
		fear_drain_timer = fear_drain_interval;
		
		// check routine and do it
		event_user(1);
	}
}

function kill() {
	if (instance_exists(soul_flame)) instance_destroy(soul_flame); soul_flame = noone;
	image_index = 4; // set to death frame
	alarm[3] = -1; // cancel fear_drain alarm
	fear = 0; // set fear to zero so that bar is not visible
	dying = true; // start floating up and fading away
	
	// award haunt points (hp)
	var _hp = 10;
	global.haunt_points += _hp;
	// display hp awarded notification
	with instance_create_layer(x, y - sprite_get_height(sprite_index), "Master", obj_notif) {
		amount = "+"+string(_hp);
		//depth = other.depth;
	}
	
	//show_message(string(id)+"\nhas called kill()");
}

function possess() {
	// possession transition should take place, so only after a short delay
	// should the npc finally check their routine and (then likely) leave the building
	
	if (instance_exists(soul_flame)) instance_destroy(soul_flame); soul_flame = noone;
	alarm[3] = -1;
	fear = 0;
	possess_transition = true;
	
	// store the npc's initial pos before shaking so we can snap to it when finished shaking
	shake_init_pos_stored = false;
	if (!shake_init_pos_stored) {
		shake_init_x = x;
	    shake_init_y = y;
	    shake_init_pos_stored = true;
	}
}

function enter_building() {
	var _b = instance_nearest(x, y, obj_par_building);
	
	// register with the building
	array_push(_b.occupants, id);
	
	current_building = _b;
	is_inside = true;
	can_move_inside = true;
	
	if (current_state = "ENTICED") {
		// same alarm used when npc is 'scared' inside, with slightly longer delay
		// the purpose here is so that enticed npcs will eventually leave the house if left un-interacted-with
		
		// start alarm timer which when triggered begins to drain fear
		// when fear reaches zero, change state to "inside" then check routine
		alarm[3] = game_get_speed(gamespeed_fps) * 8.5;
	}
	
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
    
	// if not possessed, make npc not scared anymore; reset to normal sprite
	if (!possessed) {
		image_index = 0;
		fear = 0;
	}
	
	// destroy possess/kill buttons if they exist
	if (instance_exists(soul_flame)) instance_destroy(soul_flame); soul_flame = noone;
	if (instance_exists(btn_possess)) instance_destroy(btn_possess); btn_possess = noone;
	if (instance_exists(btn_kill)) instance_destroy(btn_kill); btn_kill = noone;
	
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

function check_for_npcs() {
	
	var r = possessed_radius;
	
	if (!ds_exists(current_list, ds_type_list)) {
		current_list = ds_list_create();
	}
	if (!ds_exists(last_list, ds_type_list)) {
		last_list = ds_list_create();
	}
	
	// 1 // clear the current list and find who is inside now
	ds_list_clear(current_list);
	
	var _num = collision_circle_list(x, y, r, obj_par_npc, false, true, current_list, false);

	// 2 // find 'new entries' (in current_list ONLY, not in last_list)
	for (var i = 0; i < ds_list_size(current_list); i++) {
	    var _inst = current_list[| i];
    
	    // if they weren't here last frame, they just ENTERED
	    if (ds_list_find_index(last_list, _inst) == -1) {
			// spook the npc if they are visible, i.e. not inside a building
			if (_inst.visible) and (!_inst.possessed) and (!_inst.possess_transition) {
		        _inst.spooked = true;
				// store npc current xscale
				_inst.prev_xscale = image_xscale;
				// make npc face the object
				if (_inst.x > x) {
					_inst.image_xscale = -1;
				} else {
					_inst.image_xscale = 1;
				}
				
				//// increment our world object's escrow (+1 HP)
				//escrow++;
				//// this world object gains infamy
				//gain_infamy();
				
				global.haunt_points++;
				
				// display HP notification
				with instance_create_layer(x, y - sprite_get_height(sprite_index), "Master", obj_notif) {
					amount = "+1";
				}
				
				//show_debug_message("Target " + string(_inst) + " Entered!");
			}
	    }
	}
	
	// 3 // find 'exits' (in last_list ONLY, not in current_list)
	for (var i = 0; i < ds_list_size(last_list); i++) {
	    var _inst = last_list[| i];
		
	    // if they were here last frame but aren't now, they just LEFT
	    if (ds_list_find_index(current_list, _inst) == -1) {
	        if (instance_exists(_inst)) {
	            //_inst.spooked = false; // reset the trigger
	            //show_debug_message("Target " + string(_inst) + " Left!");
	        }
	    }
	}
	
	// 4 // update the memory for the next frame
	ds_list_copy(last_list, current_list);
}

function remove_possession() {
	// reset to normal, or deactivate
	image_index = 0;
	possessed = false;

	// avoid memory leaks; forget all ids which entered/left while possessed
	ds_list_destroy(current_list);
	ds_list_destroy(last_list);
	
	// play sound (npc deactivated / possession removed)
	//...
	// visual feedback
	spooked = true; // will play sound, change to spooked face for short time
	
	show_debug_message("obj_par_npc CREATE: remove_possession(): "+string(id));
}