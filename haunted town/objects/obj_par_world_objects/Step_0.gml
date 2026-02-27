#region mouse hover and click/release functionality
// if not haunted and mouse hovering/not hovering
if (mouse_hover) and (!haunted) {
	// when hovering over, set image index to 1
	if (image_index != 1) image_index = 1;
	//// if we are the streetlamp, set flag to draw haunt outline as extra sprite underneath
	//if (sprite_index == spr_wo_streetlamp) and (!draw_haunt_outline) {
	//	draw_haunt_outline = true;
	//}
} else if (!mouse_hover) and (!haunted) {
	// when not hovering over
	if (image_index != 0) image_index = 0;
	//// if we are the streetlamp, stop drawing haunt outline
	//if (sprite_index == spr_wo_streetlamp) and (draw_haunt_outline) {
	//	draw_haunt_outline = false;
	//}
	
	// disable clicked if it was active
	if (clicked) clicked = false;
}

// if haunted and mouse hovering/not hovering
if (mouse_hover) and (haunted) {
	//...
} else if (!mouse_hover) and (haunted) {
	// disable clicked if it was active
	if (clicked) clicked = false;
}

if (mouse_hover) and (device_mouse_check_button_pressed(0, mb_left)) {
	clicked = true;
	// play sound (mouse click button)
	//...
}

if (mouse_hover) and (clicked) and (device_mouse_check_button_released(0, mb_left)) {
	clicked = false;
	//mouse_hover = false;
	// play sound (button released/confirmed)
	//...
	btn_confirmed = true;
}

if (btn_confirmed) {
	// if clicked and was not haunted
	if (!haunted) {
		//// stop drawing the haunt outline (extra sprite underneath) if it is being drawn
		//if (draw_haunt_outline) draw_haunt_outline = false;
		
		// make the clicked world object haunted
		sprite_index = sprite_haunted;
		haunted = true;
	} else {
		// if clicked and was haunted
		// trigger delayed deactivation
		
		//// moved to alarm[1] for delayed reset
		//// reset to normal
		//sprite_index = sprite_normal;
		//haunted = false;
		//// start cooldown period
		//cooldown_active = true;
		//alarm[0] = game_get_speed(gamespeed_fps) * cooldown_timer;
		
		//// delayed reset to normal
		//alarm[0] = game_get_speed(gamespeed_fps) * 3;
		
		deactivate_active = true;
		
		show_debug_message("obj_par_world_objects STEP: "+string(id)+" started delayed reset / deactivate");
	}
	
	btn_confirmed = false;
}
#endregion

#region handle decrementing the cooldown/deactivate timers when active
// also resetting it when reaching zero
if (cooldown_active) {
	cooldown_timer--;
	if (cooldown_timer <= 0) {
		cooldown_active = false;
		cooldown_timer = cooldown_timer_init;
		// cooldown complete. 
	}
}
if (deactivate_active) {
	deactivate_timer--;
	if (deactivate_timer <= 0) {
		deactivate_active = false;
		deactivate_timer = deactivate_timer_init;
		// deactivate complete.
		sprite_index = sprite_normal;
		haunted = false;
		// avoid memory leaks; forget all ids which entered/left while haunted
		ds_list_destroy(current_list);
		ds_list_destroy(last_list);
		// escrow can now be transferred to player
		// (should also be shown visually)
		if (escrow > 0) {
			global.haunt_points += escrow;
			escrow = 0;
		}
		// now start cooldown.
		cooldown_active = true;
	}
}
#endregion

#region handle NPC entering haunt_radius
if (haunted) {
	#region attempts at checking collision inside haunt_radius (commented)
	//var npcs_inside = [0];
	//for (var i = 0; i < instance_number(obj_par_npc); i++) {
	//	var _inst = instance_find(obj_par_npc, i);
	//	for (var j = 0; j <= array_length(npcs_inside); j++) {
	//		// if current inst has not already been spooked inside this radius
	//		if (_inst.id != npcs_inside[j]) {
	//		}
	//	}
	//	if (point_in_circle(_inst.x, _inst.y, x, y, haunt_radius)) {
	//		_inst.spooked = true;
	//		array_push(npcs_inside, _inst.id); // push inst id to array to compare against
	//		//show_message("obj_par_world_objects STEP: npc found in haunt_radius");
	//	}
	//}
	
	//// THIS NEEDS FINISHING AND FINESSING
	//var _radius = haunt_radius; 
	//var _sx = x;
	//var _sy = y;
	//with (obj_par_npc) {
	//    // check if currently inside the r
	//    var _is_inside = point_in_circle(x, y, _sx, _sy, _radius);
	//    if (_is_inside) {
	//        // only trigger if it WASN'T inside last frame
	//        if (!was_in_range) {
	//            spooked = true;
	//            //show_debug_message("obj_par_world_objects STEP: "+string(id)+" entered the haunt_radius!");
            
	//            // set to true so it doesn't trigger again next frame
	//            was_in_range = true; 
	//        }
	//    } else {
	//        // if outside, reset the flag so it can be triggered again upon re-entry
	//        was_in_range = false;
	//    }
	//}
	#endregion
	
	// periodic check for collisions whilst haunted
	if (check_timer-- <= 0) {
	    check_timer = check_interval;
	    check_for_npcs();
	}
}
#endregion
