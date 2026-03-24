#region mouse hover and click/release functionality
//// if not haunted and mouse hovering/not hovering
//if (mouse_hover) and (!haunted) {
//	// when hovering over
//	if (image_index != 1) image_index = 1;
//} else if (!mouse_hover) and (!haunted) {
//	// when not hovering over
//	if (image_index != 0) image_index = 0;
//	// disable clicked if it was active
//	if (clicked) clicked = false;
//}

//// if haunted and mouse hovering/not hovering
//if (mouse_hover) and (haunted) {
//	//...
//} else if (!mouse_hover) and (haunted) {
//	// disable clicked if it was active
//	if (clicked) clicked = false;
//}

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
	//if (!haunted) {
	//	//sprite_index = sprite_haunted;
	//	//haunted = true;
	//	activate();
	//} else {
	//	//sprite_index = sprite_normal;
	//	//haunted = false;
	//	deactivate();
	//}
	//btn_confirmed = false;
	
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
}
#endregion

#region handle decrementing the cooldown/deactivate timers when active
// also resetting it when reaching zero
if (cooldown_active) {
	cooldown_timer--;
	if (cooldown_timer <= 0) {
		// cooldown complete. 
		cooldown_active = false;
		cooldown_timer = cooldown_timer_init;
	}
}
if (deactivate_active) {
	deactivate_timer--;
	if (deactivate_timer <= 0) {
		// deactivate complete.
		deactivate_active = false;
		deactivate_timer = deactivate_timer_init;
		
		sprite_index = sprite_normal;
		image_index = 0;
		haunted = false;
		infamy = 0;
		with (current_building) {
			haunted = false;
			infamy = 0;
		}
		
		// avoid memory leaks; forget all ids which entered/left while haunted
		ds_list_destroy(current_list);
		
		// now start cooldown.
		cooldown_active = true;
	}
}
#endregion

#region handle regular checking for NPCs entering and leaving haunt_radius
if (haunted) {
	// periodic check for collisions whilst haunted
	if (check_timer-- <= 0) {
	    check_timer = check_interval;
	    check_for_npcs();
	}
}
#endregion