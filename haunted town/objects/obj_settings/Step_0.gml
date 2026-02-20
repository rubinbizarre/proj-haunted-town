if (keyboard_check_pressed(vk_escape)) {
	instance_destroy();
}

if (keyboard_check_pressed(vk_left)) {
	switch (menu_index) {
		case 0: {
			if (global.mode_index > 0) {
				global.mode_index--;
			} else {
				global.mode_index = 2;
			}
		} break;
		case 1: {
			if (global.res_index > 0) {
				global.res_index--;
			} else {
				global.res_index = 4;
			}
		} break;
	}
}
if (keyboard_check_pressed(vk_right)) {
	switch (menu_index) {
		case 0: {
			if (global.mode_index < 2) {
				global.mode_index++;
			} else {
				global.mode_index = 0;
			}
		} break;
		case 1: {
			if (global.res_index < 4) {
				global.res_index++;
			} else {
				global.res_index = 0;
			}
		} break;
	}
}
if (keyboard_check_pressed(vk_up)) {
	if (menu_index > 0) {
		menu_index--;
	} else {
		menu_index = 1;
	}
}
if (keyboard_check_pressed(vk_down)) {
	if (menu_index < 1) {
		menu_index++;
	} else {
		menu_index = 0;
	}
}

var _current_res_index = global.res_index;

res_name = string(res_options[_current_res_index].w) + "x" + string(res_options[_current_res_index].h);

if (keyboard_check_pressed(vk_enter)) or (keyboard_check_pressed(vk_space)) {
	// confirm resolution choice:
	// if resolution choice is not the same as before
	// or if display mode choice is not the same as before
	// call adjust resolution function with these parameters
	if (_current_res_index != prev_res_index) or (global.mode_index != prev_mode_index) {
		show_debug_message("obj_settings STEP: called scr_adjust_resolution with:\nDisplayMode: "+string(mode_options[global.mode_index])+"\nResolution: "+res_name);
		scr_adjust_resolution(res_options[_current_res_index].w, res_options[_current_res_index].h, global.mode_index);
		prev_res_index = _current_res_index;
		prev_mode_index = global.mode_index;
	}
}

