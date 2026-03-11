// check if mouse is hovering over building
mouse_hover = point_in_rectangle(
	mouse_x, mouse_y, 
    bbox_left, bbox_top, bbox_right, bbox_bottom
);

//if (ac_time_hover < 1) {
//	ac_time_hover += ac_speed_hover;
//}

#region handle mouse hover effect and enabling interaction for A) haunted buildings and B) normal buildings
// if building is haunted have unique hover effect
if (mouse_hover) and (stats.owned) {
//if (mouse_hover) {
	if (ac_time_hover < 1) {
		ac_time_hover += ac_speed_hover;
	}
	// apply animcurve values to scale
	image_xscale = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
	image_yscale = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
} else if (!mouse_hover) and (stats.owned) {
	// when not hovering over,
	// shrink down to regular size at constant rate
	if (image_xscale > 1) {
		image_xscale -= shrink_speed;
	} else {
		if (image_xscale != 1) image_xscale = 1;
	}
	if (image_yscale > 1) {
		image_yscale -= shrink_speed;
	} else {
		if (image_yscale != 1) image_yscale = 1;
	}
	// reset animcurve time
	ac_time_hover = 0;
	// disable clicked if it was active
	if (mouse_clicked) mouse_clicked = false;
}

// if building is NOT owned, slightly zoom
if ((mouse_hover) and (!stats.owned)) or (global.tracked_building == id) {
	// make scale slightly larger instantly
	image_xscale = 1.1;
	image_yscale = 1.1;
} else if (!mouse_hover) and (!stats.owned) {
	// when not hovering over,
	// shrink down to regular size at constant rate
	if (image_xscale > 1) {
		image_xscale -= shrink_speed;
	} else {
		if (image_xscale != 1) image_xscale = 1;
	}
	if (image_yscale > 1) {
		image_yscale -= shrink_speed;
	} else {
		if (image_yscale != 1) image_yscale = 1;
	}
	// disable clicked if it was active
	if (mouse_clicked) mouse_clicked = false;
}
#endregion

if (mouse_hover) and (device_mouse_check_button_pressed(0, mb_left)) {
	// play sound (building pressed/clicked)
	//...
	mouse_clicked = true;
	//show_debug_message("obj_par_building STEP: "+string(id)+" mouse_clicked whilst hovering");
}

if (mouse_hover) and (mouse_clicked) and (device_mouse_check_button_released(0, mb_left)) {
	mouse_clicked = false;
	mouse_hover = false;
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
			global.haunt_points -= stats.cost;
			stats.owned = true;
			// play sound (unlocked/success)
			//...
			// display hp cost notification
			var _cost = stats.cost;
			with instance_create_layer(x, y - (sprite_height), "Master", obj_notif) {
				amount = "-"+string(_cost);
				//depth = other.depth - 1;
			}
			exit;
		} else { // if player cannot afford to purchase this
			// play sound (locked/fail)
			//...
		}
	}
}

#region handle enticing NPCs
if (stats.owned) and (mouse_check_button_pressed(mb_left)) and
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
				alarm[0] = game_get_speed(gamespeed_fps) * 1.5;
			}
	    }
	}
	ds_list_destroy(_temp_list);
}
#endregion