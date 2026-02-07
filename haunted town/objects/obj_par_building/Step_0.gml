// check if mouse is hovering over building
mouse_hover = point_in_rectangle(
	mouse_x, mouse_y, 
    bbox_left, bbox_top, bbox_right, bbox_bottom
);

if (ac_time_hover < 1) {
	ac_time_hover += ac_speed_hover;
}

if (mouse_hover) {
	if (ac_time_hover < 1) {
		ac_time_hover += ac_speed_hover;
	}
	
	// apply animcurve values to scale
	image_xscale = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
	image_yscale = animcurve_channel_evaluate(ac_channel_hover, ac_time_hover);
} else {
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

if (mouse_hover) and (device_mouse_check_button_pressed(0, mb_left)) {
	// play sound (building pressed/clicked)
	//...
	mouse_clicked = true;
}

if (mouse_hover) and (mouse_clicked) and (device_mouse_check_button_released(0, mb_left)) {
	mouse_clicked = false;
	mouse_hover = false;
	// play sound (building released/confirmed)
	//...
	mouse_confirmed = true;
}

if (mouse_confirmed) {
	switch (sprite_index) {
		case obj_building_0_shack.sprite_index: {
			show_message("obj_par_building STEP:\nPlayer confirmed obj_building_0_shack with id: "+string(id));
		} break;
		case obj_building_1_house.sprite_index: {
			show_message("obj_par_building STEP:\nPlayer confirmed obj_building_1_house with id: "+string(id));
		} break;
		case obj_building_2_manor.sprite_index: {
			show_message("obj_par_building STEP:\nPlayer confirmed obj_building_2_manor with id: "+string(id));
		} break;
		default: {
			show_message("obj_par_building STEP:\nDefault");
		} break;
	}
	mouse_confirmed = false;
}