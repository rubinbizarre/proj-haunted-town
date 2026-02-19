#region mouse hover and click/release functionality
// if not haunted and mouse hovering/not hovering
if (mouse_hover) and (!haunted) {
	// when hovering over
	if (image_index != 1) image_index = 1;
} else if (!mouse_hover) and (!haunted) {
	// when not hovering over
	if (image_index != 0) image_index = 0;
	
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
	if (!haunted) {
		sprite_index = sprite_haunted;
		haunted = true;
	} else {
		sprite_index = sprite_normal;
		haunted = false;
		// start cooldown period
		cooldown_active = true;
		alarm[0] = game_get_speed(gamespeed_fps) * cooldown_timer;
	}
	
	btn_confirmed = false;
}
#endregion

if (cooldown_active) {
	cooldown_timer--;
	if (cooldown_timer <= 0) {
		cooldown_active = false;
		cooldown_timer = cooldown_timer_init;
	}
}

/*
if haunted
	if npc enters the haunt radius
		if npc has not entered this haunted objects radius before
			tell npc to store its previous state
			change npc state to spooked

(notes on npc spooked state):
if state == spooked
	stop moving
	jump in place
	play animcurve spook once, apply to yscale
	change sprite to show fear
	after short delay change state back to previous state
*/