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