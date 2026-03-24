//ascend
y -= (ascent_speed * obj_manager_time.time_speed_normalised);

////determine color
//if (amount == 100) {
//	c = c_aqua;
//} else {
//	c = c_yellow;
//}

//fade out
if (fading) {
	if (alpha > 0) {
		alpha -= (fade_speed * obj_manager_time.time_speed_normalised);
	} else {
		instance_destroy();
	}
}

#region handle decrementing timer_start_fading
if (timer_start_fading_cur > 0) {
	timer_start_fading_cur -= (delta_time / 1000000) * obj_manager_time.time_speed_normalised;

	if (timer_start_fading_cur <= 0) {
	    timer_start_fading_cur = -1;
	    #region --- alarm[0] code ---
		// enable fading
		// ------------------------------------------
		fading = true;
		#endregion
	}
}
#endregion