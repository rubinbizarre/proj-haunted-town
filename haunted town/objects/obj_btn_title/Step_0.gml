if (mouse_hover) {
	if (image_index != 1) image_index = 1;
} else {
	if (image_index != 0) image_index = 0;
	if (image_xscale != 1) image_xscale = 1;
	if (image_yscale != 1) image_yscale = 1;
	// disable clicked if it was active
	if (clicked) clicked = false;
}

if (mouse_hover) and (device_mouse_check_button_pressed(0, mb_left)) {
	clicked = true;
	// play sound (mouse click button)
	//...
	image_xscale = 0.95;
	image_yscale = 0.95;
}

if (mouse_hover) and (clicked) and (device_mouse_check_button_released(0, mb_left)) {
	clicked = false;
	mouse_hover = false;
	// play sound (button released/confirmed)
	//...
	btn_confirmed = true;
	image_xscale = 1;
	image_yscale = 1;
}

if (btn_confirmed) {
	switch (sprite_index) {
		case spr_btn_play: {
			// start playing
			room_goto(rm_main);
		} break;
		case spr_btn_settings: {
			// open settings menu
			//...
		} break;
		case spr_btn_quit: {
			// end or exit the game
			game_end(); // this function only works on desktop environments, not HTML5 or mobile
		} break;
	}
	btn_confirmed = false;
}