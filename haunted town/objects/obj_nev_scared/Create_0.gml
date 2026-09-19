//move_speed = 1.6*2;
// nev's usual speed is 3.2
// when scared, he moves faster?

sprite_idle = spr_nev_scared_idle;
sprite_spooked = spr_nev_scared_spook;

move_speed = 4;
move_speed_init = move_speed;

//move_speed_rush = 1.6;

// to pass to nev inst when done
return_van_x = 0;
return_van_y = 0;
return_path_x = 0;
return_path_y = 0;

fear = 0.0; // ranges from 0-1
fear_gain = 0.1;

prev_xscale = 1; // used when being spooked to face the spooking object
scale_init = image_xscale;

#region //-- ANIMCURVES --//
// animcurve for bobbing whilst moving
ac_channel_bob = animcurve_get_channel(anim_npc_bob, 0);
ac_time_bob = 0;
ac_speed_bob = 0.08/2;
// animcurve for shivering
ac_channel_shiver = animcurve_get_channel(anim_nev_shiver, 0);
ac_time_shiver = 0;
ac_speed_shiver = 0.1;
// animcurve for being spooked
ac_channel_spook = animcurve_get_channel(anim_npc_spook, 0);
ac_time_spook = 0;
ac_speed_spook = 0.05;
#endregion

//glance_counter = 0;
//timer_glance_max = 0.3; // secs of game-world-time
//timer_glance_cur = -1; // -1 = inactive
//timer_glance_end_max = timer_glance_max * 2;
//timer_glance_end_cur = -1;
timer_leave_building_max = 2;
timer_leave_building_cur = -1;

////after short delay glance the other way before looking back
//timer_glance_cur = timer_glance_max; // set the glance timer

my_path = path_add();

is_inside = false;
off_path = false;
spooked = false;

current_building = noone;

// create our scared particle system inst
ps_scared = instance_create_layer(x, y - (sprite_get_height(sprite_index)/2), "Master", obj_ps_nev_scared);
ps_scared.depth = depth - 10;
ps_scared.start_sweat();

// immediately:
// path to nearest circuit node from van, without obeying mp_grid
// --------------------------------------------------------------
path_add_point(my_path, x, y, 100);
// find nearest path circuit node to nev
var _node = instance_nearest(x, y, obj_node_circuit);
// add this nearest path circuit node pos to path
target_x = _node.x;
target_y = _node.y;
// store this for later to pass on to normal nev
return_path_x = _node.x;
return_path_y = _node.y;

path_add_point(my_path, target_x, target_y, 100);
// modify path properties
path_set_closed(my_path, false);
path_set_kind(my_path, 0);
// start moving along the path
path_start(my_path, move_speed, path_action_stop, true);

function enter_building() {
	var _b = instance_nearest(x, y, obj_par_building);
	
	// register with the building
	array_push(_b.occupants, id);
	
	current_building = _b;
	is_inside = true;
	//can_move_inside = true;
	off_path = true;
	
	path_end();
	
	prev_town_x = x;
	prev_town_y = y;
	
	// teleport to the void interior entrance for this building specifically: works
	x = _b.interior_x + (_b.interior_width / 2);
	y = _b.interior_y + 85 + (sprite_get_height(spr_interior_0_shack)/2);
	
	//// temporarily place NPCs in random places inside obj_interior collision mask
	//var _margin = sprite_get_width(spr_npc_elderly)/2;
	//var _isprite_w = sprite_get_width(_b.interior_obj.sprite_index)/2;
	//var _isprite_h = sprite_get_height(_b.interior_obj.sprite_index)/2;
	//var _x = irandom_range(
	//	_b.interior_obj.x - (_isprite_w - _margin),
	//	_b.interior_obj.x + (_isprite_w - _margin)
	//);
	//var _y = irandom_range(
	//	_b.interior_obj.y,
	//	_b.interior_obj.y + (_isprite_h - 5)
	//);
	//x = _x;
	//y = _y;
	/*
		also valid option: (which replaces the above block with vars entirely)
		var _i = _b.interior_obj;
		var _x = irandom_range(_i.bbox_left, _i.bbox_right);
		var _y = irandom_range(_i.bbox_top, _i.bbox_bottom);
	*/
	
	//alarm[2] = game_get_speed(gamespeed_fps) * 2; // leave after 2 secs if nothing is haunted
	timer_leave_building_cur = timer_leave_building_max;
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
	
    // cleanup variables
    is_inside = false;
    current_building = noone;
	//can_move_inside = false;
	//target_x = 0;
	//target_y = 0;
	//target_obj = noone;
	
	//// check routine and do it
	//event_user(1);
}