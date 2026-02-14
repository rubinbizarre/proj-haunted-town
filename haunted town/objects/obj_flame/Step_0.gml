// destroy self after reaching the last frame of extinguish anim
if (sprite_index == spr_exting_A) or (sprite_index == spr_exting_B) or (sprite_index == spr_exting_C) {
	if (image_index >= image_number - 1) {
		//show_message("gonna destroy flame inst now");
		instance_destroy();
	}
}