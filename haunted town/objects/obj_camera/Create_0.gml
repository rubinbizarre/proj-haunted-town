// store the camera ID for later
cam = view_camera[0];

// storing mouse coords for panning
mouse_prev_x = 0;
mouse_prev_y = 0;

// affects strength of panning motion
pan_scale_factor = 0.25;

// flag for whether to update camera pos every frame with mouse movement (pan)
camera_panning = false;

/*
	initial setup in room-editor
	-----------------------------
		cam		x 640	y 280
		cam		w 640	h 360
		viewp	w 1920	h 1080
	
	
*/