switch (room) {
	case rm_main: {
		// reposition the camera
		// in future this should be set to x,y coords that are stored when going to rm_inside
		camera_set_view_pos(cam, 640, 280);
		camera_set_view_size(cam, 640, 360);
	} break;
	case rm_inside: {
		camera_set_view_pos(cam, 0, 0);
		camera_set_view_size(cam, 320, 180);
	} break;
}