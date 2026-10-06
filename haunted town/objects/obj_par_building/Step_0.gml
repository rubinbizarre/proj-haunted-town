//// check if mouse is hovering over building
//mouse_hover = point_in_rectangle(
//	mouse_x, mouse_y, 
//    bbox_left, bbox_top, bbox_right, bbox_bottom
//);

//if (ac_time_hover < 1) {
//	ac_time_hover += ac_speed_hover;
//}

#region (commented but working) handle mouse hover effect and enabling interaction for A) haunted buildings and B) normal buildings
//// if building is haunted have unique hover effect
//if (mouse_hover) and (stats.owned) {
////if (mouse_hover) {
//	if (ac_time_hover < 1) {
//		ac_time_hover += ac_speed_hover;
//	}
//	// apply animcurve values to scale
//	image_xscale = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
//	image_yscale = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
//} else if (!mouse_hover) and (stats.owned) {
//	// when not hovering over,
//	// shrink down to regular size at constant rate
//	if (image_xscale > 1) {
//		image_xscale -= shrink_speed;
//	} else {
//		if (image_xscale != 1) image_xscale = 1;
//	}
//	if (image_yscale > 1) {
//		image_yscale -= shrink_speed;
//	} else {
//		if (image_yscale != 1) image_yscale = 1;
//	}
//	// reset animcurve time
//	ac_time_hover = 0;
//	// disable clicked if it was active
//	if (mouse_clicked) mouse_clicked = false;
//}

//// if building is NOT owned, slightly zoom
//if ((mouse_hover) and (!stats.owned)) or (global.tracked_building == id) {
//	// make scale slightly larger instantly
//	image_xscale = 1.05;
//	image_yscale = 1.05;
//} else if (!mouse_hover) and (!stats.owned) {
//	// when not hovering over,
//	// shrink down to regular size at constant rate
//	if (image_xscale > 1) {
//		image_xscale -= shrink_speed;
//	} else {
//		if (image_xscale != 1) image_xscale = 1;
//	}
//	if (image_yscale > 1) {
//		image_yscale -= shrink_speed;
//	} else {
//		if (image_yscale != 1) image_yscale = 1;
//	}
//	// disable clicked if it was active
//	if (mouse_clicked) mouse_clicked = false;
//}
#endregion

#region (refactor): handle mouse hover effect and enabling interaction for A) owned buildings and B) unowned buildings
// hover effects are frozen while the game is paused
if (!global.paused) {
	// when not hovering over, disable clicked if it was active and reset animcurve time
	if (!mouse_hover) {
		mouse_clicked = false;
		ac_time_hover = 0;
	} else if (stats.owned and (ac_time_hover < 1)) {
		ac_time_hover += ac_speed_hover;
	}

	// unowned buildings (or the tracked building) slightly zoom
	var _zoomed = (mouse_hover and !stats.owned) or (global.tracked_building == id);

	if (_zoomed) {
		// make scale slightly larger instantly
		image_xscale = 1.05;
		image_yscale = 1.05;
	} else if (stats.owned and mouse_hover) {
		// owned buildings have a unique hover effect:
		// apply animcurve values to scale
		var _scale = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
		image_xscale = _scale;
		image_yscale = _scale;
	} else {
		// when not hovering over,
		// shrink down to regular size at constant rate
		image_xscale = max(1, image_xscale - shrink_speed);
		image_yscale = max(1, image_yscale - shrink_speed);
	}
}
#endregion

if (mouse_hover) and ui_click_pressed() and !ui_over_any() {
	// play sound (building pressed/clicked)
	//...
	mouse_clicked = true;
	//show_debug_message("obj_par_building STEP: "+string(id)+" mouse_clicked whilst hovering");
}

if (mouse_hover) and (mouse_clicked) and ui_click_released() {
	mouse_clicked = false;
	//mouse_hover = false;
	// play sound (building released/confirmed)
	//...
	mouse_confirmed = true;
	//show_debug_message("obj_par_building STEP: "+string(id)+" mouse_confirmed upon releasing");
}

if (mouse_confirmed) {
	//switch (sprite_index) {
	//	case obj_building_0_shack.sprite_index: {
	//		//show_message("obj_par_building STEP:\nPlayer confirmed obj_building_0_shack with id: "+string(id));
	//	} break;
	//	case obj_building_1_house.sprite_index: {
	//		//show_message("obj_par_building STEP:\nPlayer confirmed obj_building_1_house with id: "+string(id));
	//	} break;
	//	case obj_building_2_manor.sprite_index: {
	//		//show_message("obj_par_building STEP:\nPlayer confirmed obj_building_2_manor with id: "+string(id));
	//	} break;
	//	default: {
	//		show_message("obj_par_building STEP:\nDefault response");
	//	} break;
	//}
	
	//// old haunt skillcheck system:
	//global.menu_haunt_active = true;
	//global.tracked_building = id;
	//global.offered_haunt_points = 0;
	//instance_create_layer(0, 0, "Master", obj_skillcheck);
	
	mouse_confirmed = false;
	
	if (stats.owned) {
		//// need to store all npc location and path data and then reload it when coming back
		////...
		//// go to rm_inside, go inside the house
		//room_goto(rm_inside);
		
		/*
		display obj_inside which will load/display the necessary elements
			- interior (background sprite) matches the building
			- NPCs currently 'inside' displayed
			- scary object(s) assigned to building displayed in their assigned locations
				- do scary objects stay activated when player leaves inside view while scary objects are active?
		and will also manage reducing player awareness
			- other sounds from overworld are dulled or muted entirely
			- camera does not pan or zoom out/in
		*/
		
		// play sound (go inside/open door)
		//...
		
		//with instance_create_layer(960, 237, "Master", obj_inside_view) {
		//	depth = obj_master.depth;
		//}
		
		obj_master.toggle_view_inside(id);
	} else {
		// if player can afford to purchase this
		if (global.haunt_points >= stats.cost) {
			//global.haunt_points -= stats.cost;
			lose_haunt_points(stats.cost);
			stats.owned = true;
			sprite_index = sprite_haunted;
			// play sound (unlocked/success)
			//...
			// display hp cost notification
			var _cost = stats.cost;
			with instance_create_layer(x, y - (sprite_height), "Master", obj_notif) {
				amount = "-"+string(_cost);
				//depth = other.depth - 1;
			}
			
			// increment total_buildings_purchased
			global.total_buildings_purchased += 1;
			
			exit;
			
		} else { // if player cannot afford to purchase this
			// play sound (locked/fail)
			//...
		}
	}
}

#region handle enticing NPCs
if (stats.owned) and ui_click_pressed() and !ui_over_any() and 
	(point_in_circle(mouse_x, mouse_y, x, y, entice_radius))
{
	//show_debug_message("obj_par_building STEP: "+string(id)+": click detected");
	
	var _temp_list = ds_list_create();
	var _num = collision_circle_list(x, y, entice_radius, obj_par_npc, false, true, _temp_list, false);
    
	for (var i = 0; i < _num; i++) {
	    var _inst = _temp_list[| i];
		// if mouse is clicking on this npc inst whilst inside entice_radius
	    if (point_in_rectangle(mouse_x, mouse_y,
			_inst.x - abs(_inst.sprite_width/2) - 4,
			_inst.y - _inst.sprite_height - 4,
			_inst.x + abs(_inst.sprite_width/2) + 4,
			_inst.y + 4
		)) {
			//show_debug_message("obj_par_building STEP: "+string(id)+": clicked on npc "+string(_inst.id));
			with (_inst) {
				// store npc path
				if (path_exists(my_path)) {
					my_path_duplicate = path_duplicate(my_path);
				}
				// make npc stop
				path_end();
				
				// change npc state - block routine checks while in this state
				current_state = "ENTICED";
				
				// make this building inst the npc's new target
				target_obj = other;
				target_x = other.x;
				target_y = other.y;
				//show_debug_message("obj_par_building STEP: "+string(id)+": assigned npc target as tx:"+string(other.x)+", ty:"+string(other.y));
				
				// if npc is within multiple haunted obj_par_buildings' entice_radii, target the closest inst to npc
				//	- here is where you would push this buildings id to a list within npc,
				//	- then npc must determine which inst is closest itself
				//  - do this instead of assigning targetx,y prematurely ^^^
				
				// make npc sprite shocked/spooked
				image_index = 1;
				// make npc 'shiver'
				//...
				// play sound
				//...
				
				// delayed trigger to actually move to the target
				//alarm[0] = game_get_speed(gamespeed_fps) * 1.5;
				timer_move_enticed_cur = timer_move_enticed_max;
			}
	    }
	}
	ds_list_destroy(_temp_list);
}
#endregion

#region handle controlling the visual entice rings
// detect entries
var _list = ds_list_create();
var _n = collision_circle_list(x, y, entice_radius, obj_par_npc, false, true, _list, false);
var _now = [];
for (var i = 0; i < _n; i++) {
    var _v = _list[| i];
    array_push(_now, _v);
    if (!array_contains(inside, _v)) {
        array_push(pulses, { t: 0 });   // villager just entered: spawn pulse
    }
}
ds_list_destroy(_list);
inside = _now;

// advance pulses (respects delta_time and game time speed)
var _dt = (delta_time / 1000000) * obj_manager_time.time_speed_normalised;
for (var i = array_length(pulses) - 1; i >= 0; i--) {
    pulses[i].t += _dt / pulse_duration;
    if (pulses[i].t >= 1) array_delete(pulses, i, 1);
}
#endregion