if (global.tracked_building != noone) {
	//var _tx = global.camera_tracking_inst.x;
	//var _ty = global.camera_tracking_inst.y;
	//// set the correct zoom level if not already
	//if (zoom_current_w != zoom_3_w) {
	//	zoom_current_w = zoom_3_w;
	//	zoom_current_h = zoom_3_h;
	//}
	//// apply the correct zoom level if not already
	//if (camera_get_view_width(cam) != zoom_current_w) camera_set_view_size(cam, zoom_current_w, zoom_current_h);
	//// track constantly with slight follow delay
	//camera_set_view_pos(cam,
    //    lerp(camera_get_view_x(cam), _tx - camera_get_view_width(cam)/2, 0.1),
    //    lerp(camera_get_view_y(cam), _ty - camera_get_view_height(cam)/2, 0.1)
    //);
} else if (global.tracked_npc != noone) {
	//...
} else {
	if (room != rm_inside) {
		#region manual camera panning with mouse
		// if middle mouse is pressed while panning is false
		// make panning true and store mouse gui pos to start panning
		if (mouse_check_button_pressed(mb_middle)) and (!camera_panning) {
			camera_panning = true;
			mouse_prev_x = device_mouse_x_to_gui(0);
			mouse_prev_y = device_mouse_y_to_gui(0);
			//cursor_sprite = spr_cursor_pan;
		}
	
		// if middle mouse is released and panning is true
		// make panning false to stop panning
		if (mouse_check_button_released(mb_middle)) and (camera_panning) {
			camera_panning = false;
			//cursor_sprite = spr_cursor_default;
		}

		// while panning is true, update camera pos every frame
		if (camera_panning) {
			// store current mouse gui pos
			var mx = device_mouse_x_to_gui(0);
			var my = device_mouse_y_to_gui(0);
	
			// calculate the difference between mouse gui pos one frame previous to current frame
			var dx = mx - mouse_prev_x;
			var dy = my - mouse_prev_y;
		
			// determine current camera width
			var vw = camera_get_view_width(cam);
	
			// scale factor based on base zoom (level 0)
			//var speed_factor = zoom_0_w / vw; // useful when different camera sizes are used
			var speed_factor = 1; // we only have one camera size currently
		
			dx *= speed_factor;
			dy *= speed_factor;
		
			dx *= pan_scale_factor;
			dy *= pan_scale_factor;

			// Get current camera position
			var cam_x = camera_get_view_x(cam);
			var cam_y = camera_get_view_y(cam);

			// Apply scaled camera movement in the opposite direction of drag
			camera_set_view_pos(cam, cam_x - dx, cam_y - dy);

			// Update previous mouse pos
			mouse_prev_x = mx;
			mouse_prev_y = my;
		}
		#endregion	
	
		#region switch zoom level with mouse wheel when not in rm_inside
		if (room != rm_inside) {
			if mouse_wheel_up() {
				if (zoom_level < 3) zoom_level += 1;
			}
			if mouse_wheel_down() {
				if (zoom_level > 0) zoom_level -= 1;
			}
		}
		#endregion
	
		#region watch to update camera zoom with current zoom level while tracked_inst is unassigned
		if (camera_get_view_width(cam) != zoom_current_w) {
			// get centre of previous camera zoom
			// camera needs to be centred on room position at centre
			var _center_x = camera_get_view_x(cam) + camera_get_view_width(cam) / 2;
			var _center_y = camera_get_view_y(cam) + camera_get_view_height(cam) / 2;
			// set new camera zoom level
			camera_set_view_size(cam, zoom_current_w, zoom_current_h);
			// position camera correctly, centred at same point as before
			camera_set_view_pos(cam, _center_x - zoom_current_w/2, _center_y - zoom_current_h/2);
		}
		#endregion
	}
}

#region handle changing current camera zoom values
// handle changing current camera zoom depending on zoom_level
switch (zoom_level) {
	//case 0: {
	//	if (zoom_current_w != zoom_0_w) zoom_current_w = zoom_0_w;
	//	if (zoom_current_h != zoom_0_h) zoom_current_h = zoom_0_h;
	//} break;
	case 1: {
		if (zoom_current_w != cam_w_1) zoom_current_w = cam_w_1;
		if (zoom_current_h != cam_h_1) zoom_current_h = cam_h_1;
	} break;
	case 2: {
		if (zoom_current_w != cam_w_2) zoom_current_w = cam_w_2;
		if (zoom_current_h != cam_h_2) zoom_current_h = cam_h_2;
	} break;
	case 3: {
		if (zoom_current_w != cam_w_3) zoom_current_w = cam_w_3;
		if (zoom_current_h != cam_h_3) zoom_current_h = cam_h_3;
	} break;
}
#endregion