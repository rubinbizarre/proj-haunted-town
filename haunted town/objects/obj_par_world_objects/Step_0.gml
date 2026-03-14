#region mouse hover and click/release functionality
// while locked
if (locked) {
	if (mouse_hover) {
		// make scale slightly larger instantly
		image_xscale = 1.1;
		image_yscale = 1.1;
	} else {
		// when not hovering over,
		// shrink down to regular size at constant rate
		if (image_xscale > 1) {
			image_xscale -= 0.05;
		} else {
			if (image_xscale != 1) image_xscale = 1;
		}
		if (image_yscale > 1) {
			image_yscale -= 0.05;
		} else {
			if (image_yscale != 1) image_yscale = 1;
		}
		// disable clicked if it was active
		if (clicked) clicked = false;
	}
} else { // while not locked
	// while not haunted
	if (!haunted) {
		if (mouse_hover) {
			// when hovering over, set image index to 1
			if (image_index != 1) image_index = 1;
		} else {
			// when not hovering over
			if (image_index != 0) image_index = 0;
			// disable clicked if it was active
			if (clicked) clicked = false;
		}
	} else { // while haunted
		if (mouse_hover) {
			//nothing
		} else {
			// disable clicked if it was active
			if (clicked) clicked = false;
		}
	}
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
	if (locked) { // if clicked and was locked
		if (global.haunt_points >= cost) { // if player has enough HP to unlock this
			// make unlocked and subtract cost from hp wallet
			locked = false;
			global.haunt_points -= cost;
			// play sound (unlock/purchase/success)
			//...
			// visual feedback
			//...
			// display hp cost notification
			with instance_create_layer(x, bbox_top - 10, "Master", obj_notif) {
				amount = "-"+string(other.cost);
				//depth = other.depth - 1;
			}
		} else { // if player cant afford to unlock this
			// play sound (fail/blocked/error)
			//...
			// visual feedback
			//...
		}
		btn_confirmed = false;
	} else { // if clicked and was not locked
		if (!haunted) { // if clicked and was not haunted
			// make object become haunted / activated
			activate();
		} else { // if clicked and was haunted
			// trigger delayed deactivation
			deactivate_active = true;
		
			show_debug_message("obj_par_world_objects STEP: "+string(id)+" started delayed reset / deactivate");
		}
		btn_confirmed = false;
	}
	//btn_confirmed = false;
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
			// display HP notification
			with instance_create_layer(x, y - sprite_get_height(sprite_index), "Master", obj_notif) {
				amount = "+"+string(other.escrow);
			}
			escrow = 0;
		}
		// reset infamy upon deactivation
		infamy = 0;
		// now start cooldown.
		cooldown_active = true;
	}
}
#endregion

#region handle regular checking for NPCs entering and leaving haunt_radius
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

#region handle displaying escrow with tick up ? down ? lerp effect
// primarily needed for when Nev empties the escrow

//if (escrow_display == obj_wo_trashcan.escrow) return; // no need to update the display val if it's already the same as actual val
				
if (escrow_display != escrow) {
	// depending on how fast you want the display val to catch up
	var new_escrow_display = round(lerp(escrow_display, escrow, escrow_display_strength));

	// if the increment is large enough to make a difference, use the newly calculated val
	// otherwise, move the display val 1 unit closer towards the actual val
	if (new_escrow_display != escrow_display) {
		escrow_display = new_escrow_display;
		/*
		if (escrow_stolen) escrow_stolen = false;
		*/
	} else {
		//escrow_display += sign(escrow - escrow_display);
		escrow_display += sign(escrow - escrow_display);
	}
}
#endregion