switch (room) {
	case rm_main: {
		// reposition the camera
		// in future this should be set to x,y coords that are stored when going to rm_inside
		camera_set_view_pos(cam, 640, 280);
		camera_set_view_size(cam, 640, 360);
		show_debug_message("obj_camera ROOM_START: resized and repositioned camera");
	} break;
	case rm_inside: {
		// not entirely necessary to put here but fuck it
		camera_set_view_pos(cam, 0, 0);
		camera_set_view_size(cam, 320, 180);
		show_debug_message("obj_camera ROOM_START: resized and repositioned camera");
	} break;
}