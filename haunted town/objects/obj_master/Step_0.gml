switch (room) {
	case rm_main: {
		#region handle input whilst haunting a house (whilst haunt menu is active)
		if (global.menu_haunt_active) {
			global.haunt_difficulty = global.offered_haunt_points / (global.offered_haunt_points + global.tracked_building.stats.cost);
	
			// decrement offered HP. no less than zero
			if (keyboard_check_pressed(vk_down)) {
				if (global.offered_haunt_points > 0) {
					global.offered_haunt_points -= 1;
					//show_debug_message("obj_master STEP: decremented offered HP");
				}
			}
			// increment offered HP. cap to amount of HP owned
			if (keyboard_check_pressed(vk_up)) {
				if (global.offered_haunt_points < global.haunt_points) {
					global.offered_haunt_points += 1;
					//show_debug_message("obj_master STEP: incremented offered HP");
				}
			}
	
			// confirm input
			if (keyboard_check_pressed(vk_enter)) {
				// validate input:
				// proceed: player entered at least minimum amount HP required
				if (global.offered_haunt_points >= global.tracked_building.stats.cost) {
					// start haunt process
					if (instance_exists(obj_skillcheck)) {
						obj_skillcheck.trigger();
					}
				} else { // abort: player did not enter the minimum amount of HP required
					show_message("HAUNT ABORTED\nYou need to spend at least "+string(global.tracked_building.stats.cost)+" Haunt Points to Haunt this building.");
					abort_haunt_process();
				}
			}
		}
		#endregion
	
		#region handle pause activation/deactivation
		if (keyboard_check_pressed(ord("P"))) {
			custom_pause();
		}
		#endregion
		
		#region handle input while paused
		if (global.paused) {
			// keyboard: switching pause menu options
			if (keyboard_check_pressed(vk_down)) {
				if (pause_menu_select < 2) {
					pause_menu_select++;
				} else {
					pause_menu_select = 0;
				}
			}
			if (keyboard_check_pressed(vk_up)) {
				if (pause_menu_select > 0) {
					pause_menu_select--;
				} else {
					pause_menu_select = 2;
				}
			}
			// keyboard: confirming pause menu option
			if (keyboard_check_pressed(vk_space) or keyboard_check_pressed(vk_enter)) {
				switch (pause_menu_select) {
					case 0: { // resume
						custom_pause();
					} break;
					case 1: { // settings
						instance_create_layer(0, 0, "Master", obj_settings);
					} break;
					case 2: { // quit (return to title)
						room_goto(rm_title);
					} break;
				}
			}
			// mouse hover: switching pause menu options
			var _cam = camera_get_active();
			var _xx = camera_get_view_x(_cam) + (camera_get_view_width(_cam)/2);
			var _yy = camera_get_view_y(_cam) + (camera_get_view_height(_cam)/2) + 160;
			var _btn_w = 100;
			var _btn_h = 30;
			var _btn_ysep = 100;
			var _x1 = _xx - _btn_w;
			var _y1 = _yy - _btn_h;
			var _x2 = _xx + _btn_w;
			var _y2 = _yy + _btn_h;
			// resume
			if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x1, _y1, _x2, _y2)) {
				if (pause_menu_select != 0) pause_menu_select = 0;
				// confirm
				if (mouse_check_button_released(mb_left)) {
					custom_pause();
				}
			}
			_y1 += _btn_ysep;
			_y2 += _btn_ysep;
			// settings
			if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x1, _y1, _x2, _y2)) {
				if (pause_menu_select != 1) pause_menu_select = 1;
				// confirm
				if (mouse_check_button_released(mb_left)) {
					instance_create_layer(0, 0, "Master", obj_settings);
				}
			}
			_y1 += _btn_ysep;
			_y2 += _btn_ysep;
			// quit (return to title)
			if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x1, _y1, _x2, _y2)) {
				if (pause_menu_select != 2) pause_menu_select = 2;
				// confirm
				if (mouse_check_button_released(mb_left)) {
					room_goto(rm_title);
				}
			}
		}
		#endregion
	} break;
}