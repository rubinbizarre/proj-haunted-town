if (image_index >= image_number - 1) {
	instance_destroy();
}

#region move when camera moves to simulate stationary placement on world (commented)
//// note:	this seems too complex to deal with right now. an alternative solution would be to
////		merely create the click instance in the room space, as opposed to the GUI space,
////		but would also result in different scales at different zoom levels...
//if (camera_get_view_x(cam) != init_cam_x) or
//	(camera_get_view_y(cam) != init_cam_y)
//{
//	new_cam_x = camera_get_view_x(cam);
//	new_cam_y = camera_get_view_y(cam);

//	var _dx = new_cam_x - init_cam_x;
//	var _dy = new_cam_y - init_cam_y;
	
//	x = xstart + _dx;
//	y = ystart + _dy;
//}
#endregion