if (btn_chosen != id) {
	if (mouse_hover) {
		if (image_index != 1) image_index = 1;
	} else {
		if (image_index != 0) image_index = 0;
	
		if (image_xscale != 1) image_xscale = 1;
		if (image_yscale != 1) image_yscale = 1;
	
		// disable clicked if it was active
		if (clicked) clicked = false;
	}
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
	
	
}

if (btn_confirmed) {
	switch (sprite_index) {
		case spr_btn_npc_possess: {
			// subtract haunt points (hp)
			var _cost = 5; // cost may differ with different npc types ?
			// does player have enough haunt points (hp) to possess
			if (global.haunt_points >= _cost) {
				btn_chosen = id;
				image_xscale = 1.05;
				image_yscale = 1.05;
				image_index = 2;
				btn_kill.fading_away = true;
				// play sound (possess success)
				//...
				// subtract haunt points (hp)
				global.haunt_points -= _cost;
				// display cost notification
				//...
				// trigger implode after delay
				alarm[0] = game_get_speed(gamespeed_fps) * 2;
			} else {
				// play sound (fail)
				//...
				// display notification to player indicating that they 'need more HP' / 'not enough HP'
				//...
			}
		} break;
		case spr_btn_npc_kill: {
			btn_chosen = id;
			image_xscale = 1.05;
			image_yscale = 1.05;
			image_index = 2;
			btn_possess.fading_away = true;
			// play sound (kill success)
			//...
			// award haunt points (hp)
			var _hp = 10;
			global.haunt_points += _hp;
			// display hp awarded notification
			//...
			// trigger implode after delay
			alarm[0] = game_get_speed(gamespeed_fps) * 2;
		} break;
	}
	btn_confirmed = false;
}

if (fading_away) {
	image_alpha -= fade_speed;
	//y -= fade_speed; // float up
	if (image_alpha <= 0) {
		instance_destroy();
	}
}

if (btn_chosen == id) {
	y -= fade_speed;
}

if (implode) {
	image_xscale *= 0.5;
	if (image_xscale <= 0.2) {
		// affect npc; refer to npc with var 'npc'
		switch (sprite_index) {
			case spr_btn_npc_possess: {
				// possess npc
				//...
			} break;
			case spr_btn_npc_kill: {
				// kill npc
				//...
			} break;
		}
		// destroy button inst
		instance_destroy();
	}
}