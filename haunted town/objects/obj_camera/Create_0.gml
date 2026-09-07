// store the camera ID for later
cam = view_camera[0];

// storing mouse coords for panning
mouse_prev_x = 0;
mouse_prev_y = 0;

// affects strength of panning motion
pan_scale_factor = 0.1;

// flag for whether to update camera pos every frame with mouse movement (pan)
camera_panning = false;

stick_pan_speed = 5;

/*

initial setup in room-editor
-----------------------------
cam		x 640	y 280
cam		w 640	h 360
viewp	w 1920	h 1080

room	w 1920  h 1080

*/


// starting cam x,y pos at 0 zoom:
// x = 90
// y = 720


cam_w_0 = 3840; cam_h_0 = 2160;
//cam_w_1 = 1920; cam_h_1 = 1080;
cam_w_1 = 1280; cam_h_1 = 720;
cam_w_2 = 640;  cam_h_2 = 360;
cam_w_3 = 320;//240;//
cam_h_3 = 180;//135;//

zoom_level = 0; // 0-3

zoom_target_w = cam_w_0;
zoom_target_h = cam_h_0;
zoom_current_w = zoom_target_w;
zoom_current_h = zoom_target_h;

zoom_lerp_rate = 0.12; // fraction closed per step, tune to taste
zoom_snap_eps  = 0.5;  // px distance below which to snap to exact target

function increase_zoom_level() {
	if (zoom_level < 3) zoom_level += 1;
}
function decrease_zoom_level() {
	if (zoom_level > 0) zoom_level -= 1;
}