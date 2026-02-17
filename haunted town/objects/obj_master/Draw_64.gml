var _x = 0;
var _y = 0;
var _ysep = 0;

switch (room) {
	case rm_main: {
		#region PAUSED
		if (global.paused) {
			if (surface_exists(paused_surface)) {
				draw_clear_alpha(c_black, 0);
				surface_set_target(paused_surface);
				//draw_clear_alpha(c_black, 0);
		
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				draw_set_color(c_fuchsia);
				draw_set_font(font_main);
				draw_text_transformed(room_width/2, room_height/2, "[NOT] PAUSED", 2, 2, 0);
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				draw_set_color(c_white);
				draw_set_font(font_default);
		
				surface_reset_target();
				draw_surface(paused_surface, 0, 0);
			} else {
				show_message("obj_master DRAW_GUI: paused_surface does not exist, creating it now...");
				paused_surface = surface_create(room_width, room_height);
				surface_copy(paused_surface, 0, 0, application_surface);
			}
		}
		#endregion

		#region DEBUG
		if (global.debug) {
			draw_set_color(c_lime);
			_x = 16;
			_y = 16;
			_ysep = 40;
	
			draw_text_transformed(_x, _y, "current_time: "+string(global.current_time_)+"/"+string(global.total_cycle_minutes), 2, 2, 0); _y += _ysep;
			if (instance_exists(obj_manager_time)) draw_text_transformed(_x, _y, "time_speed: "+string(obj_manager_time.time_speed_actual), 2, 2, 0); _y += _ysep;
			// display controls for time speed manipulation
			draw_set_halign(fa_center); draw_text_transformed(room_width/2, room_height-40, "left = decrease time spd | down = reset time spd | right = increase time spd", 2, 2, 0); _y += _ysep; draw_set_halign(fa_left);
			draw_set_halign(fa_right);
			draw_text_transformed(room_width - _x, 16, "fps:"+string(fps), 2, 2, 0);
			draw_set_halign(fa_left);
			draw_set_color(c_white);
		}
		#endregion

		#region HUD
		if (global.hud) {
			draw_set_halign(fa_center);
			_x = room_width/2;
			_y = 16;
			_ysep = 40;

			draw_text_transformed(_x, _y, "HAUNT POINTS: "+string(global.haunt_points), 2, 2, 0); _y += _ysep;
			draw_text_transformed(_x, _y, "WEEK "+string(global.week_counter), 2, 2, 0); _y += _ysep;
			draw_text_transformed(_x, _y, scr_date_and_time(global.current_time_), 2, 2, 0); _y += _ysep; // draw time in format "Monday 20:32" include toggle for 12 hr time in settings "Monday 8:32 PM"
			draw_set_halign(fa_left);
		}

		if (global.menu_haunt_active) {
			draw_set_halign(fa_center);
			_x = room_width/4;
			_y = room_height/4;
			_ysep = 40;
			draw_set_color(c_dkgray);
			draw_rectangle(_x - 400, _y - 50, _x + 400, _y + 400, false);
			draw_set_color(c_white);
			draw_text_transformed(_x, _y, "HAUNT THIS BUILDING?", 2, 2, 0); _y += _ysep;
			draw_text_transformed(_x, _y, "spend Haunt Points to Attempt Haunting", 2, 2, 0); _y += _ysep;
			draw_text_transformed(_x, _y, "HP required: "+string(global.tracked_building.stats.haunt_requirement), 2, 2, 0); _y += _ysep;
			_y += _ysep;
			draw_text_transformed(_x, _y, "HP offered: "+string(global.offered_haunt_points), 2, 2, 0); _y += _ysep;
			_y += _ysep;
			if (global.haunt_difficulty > 0) {
				// convert haunt_difficulty into meaningful percentage for player
				//var _result = round((1 - global.haunt_difficulty) * 100); // rounded
				var _result = (1 - global.haunt_difficulty) * 100;
				var _diff_display = string(_result) + "%";
				draw_text_transformed(_x, _y, "difficulty: "+_diff_display, 2, 2, 0);
			}
			_y += _ysep;
			_y += _ysep;
			draw_text_transformed(_x, _y, "press ENTER to Haunt", 2, 2, 0); _y += _ysep;
			draw_set_halign(fa_left);
		}

		#endregion
	} break;
}