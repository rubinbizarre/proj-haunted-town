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
				with instance_create_layer(x, y - sprite_get_height(sprite_index), "Master", obj_notif) {
					amount = "-"+string(_cost);
					depth = other.depth;
				}
				// trigger implode after delay
				alarm[0] = game_get_speed(gamespeed_fps) * 1;
				// stop draining fear and cancel alarm
				npc.fear_drain = false;
				npc.alarm[3] = -1;
			} else { // player doesn't have enough hp to possess
				// play sound (fail)
				//...
				// display notification to player indicating that they 'need more HP' / 'not enough HP'
				with instance_create_layer(x, y - sprite_get_height(sprite_index), "Master", obj_notif) {
					amount = "X";
					depth = other.depth;
				}
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
			// trigger implode after delay
			alarm[0] = game_get_speed(gamespeed_fps) * 1;
			// stop draining fear and cancel alarm
			npc.fear_drain = false;
			npc.alarm[3] = -1;
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
				if (instance_exists(npc)) npc.alarm[4] = game_get_speed(gamespeed_fps) * 1;
			} break;
			case spr_btn_npc_kill: {
				if (instance_exists(npc)) npc.alarm[5] = game_get_speed(gamespeed_fps) * 1;
			} break;
		}
		// destroy button inst
		instance_destroy();
	}
}