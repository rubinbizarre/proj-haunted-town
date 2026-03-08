// store the camera ID for later
cam = view_camera[0];

// storing mouse coords for panning
mouse_prev_x = 0;
mouse_prev_y = 0;

// affects strength of panning motion
pan_scale_factor = 0.1;

// flag for whether to update camera pos every frame with mouse movement (pan)
camera_panning = false;

/*

initial setup in room-editor
-----------------------------
cam		x 640	y 280
cam		w 640	h 360
viewp	w 1920	h 1080

room	w 1920  h 1080

*/

zoom_level = 2; // 1-3 currently

cam_w_1 = 1920;
cam_h_1 = 1080;
cam_w_2 = 640;
cam_h_2 = 360;
cam_w_3 = 320;//240;//
cam_h_3 = 180;//135;//

zoom_current_w = cam_w_2;
zoom_current_h = cam_h_2;