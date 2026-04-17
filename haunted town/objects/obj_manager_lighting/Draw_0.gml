if (!surface_exists(surf_lighting)) {
	var _cw = camera_get_view_width(view_camera[0]);
	var _ch = camera_get_view_height(view_camera[0]);
	surf_lighting = surface_create(_cw, _ch);
	surface_set_target(surf_lighting);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
} else {
	var _cw = camera_get_view_width(view_camera[0]);
	var _ch = camera_get_view_height(view_camera[0]);
	var _cx = camera_get_view_x(view_camera[0]);
	var _cy = camera_get_view_y(view_camera[0]);
	surface_set_target(surf_lighting);
	
	var _darkness_max = 0.5;
	var _darkness = _darkness_max * global.light_change_progress;
	
	#region notes on light_change_progress (commented)
	// light_change_progress is calculated by
	// new timer which is started at 0 at two set times / time period for total light change (3 hours)
	
	// e.g. from 0500 - 0800 darkness decreases from max to 0
	//		from 2000 - 2300 darkness increases from 0 to max
		// when decreasing, _darkness_max * 1-(light_change_progress)
		// when increasing, _darkness_max * light_change_progress
		// ideally this modification to light_change_progress will be handled elsewhere
	#endregion
	
	draw_clear_alpha(c_black, _darkness);
	
	// add conditional here which means that streetlamps are only active in a certain time threshold
	// streetlamps active between 2000 - 0800 (in current_time: 0 - 480 and 1200 - 1440)
	// revision: they should be active btwn 2100 and 0700
	//if ((global.current_time_ >= 0) and (global.current_time_ <= 480)) or
	//	((global.current_time_ >= 1200) and (global.current_time_ <= 1440)) {
	if (global.light_night) {
		gpu_set_blendmode(bm_subtract);
		with (obj_wo_streetlamp) {
			//var _sw = sprite_width/2;
			//var _sh = sprite_height/2;
			draw_sprite_ext(spr_light_1, 0, x - _cx, y - _cy, 1, 1, 0, c_white, 1);
		}
		gpu_set_blendmode(bm_subtract);
		with (obj_nev_van) {
			var _sprite;
			switch (sprite_index) {
				case spr_nev_van_side: {
					_sprite = spr_nev_van_side_lights;
				} break;
				case spr_nev_van_up: {
					_sprite = spr_nev_van_up_lights;
				} break;
				case spr_nev_van_down: {
					_sprite = spr_nev_van_down_lights;
				} break;
			}
			draw_sprite_ext(_sprite, 0, x - _cx, y - _cy, image_xscale, image_yscale, 0, c_white, 1);
		}
	}
	
	gpu_set_blendmode(bm_normal);
	draw_set_alpha(1);
	surface_reset_target();
	draw_surface(surf_lighting, _cx, _cy);
}