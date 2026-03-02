if (!instance_exists(obj_master)) {
	instance_create_layer(0, 0, "Master", obj_master);
}
if (!instance_exists(obj_camera)) {
	instance_create_layer(0, 1, "Master", obj_camera);
}