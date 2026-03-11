var _x = 0;
var _y = 0;
var _ysep = 0;

switch (room) {
	case rm_title: {
		_x = room_width/2;
		_y = 32;
		var _prev_font = draw_get_font();
		draw_set_font(font_main);
		draw_set_halign(fa_center);
		//draw_set_color(c_fuchsia);
		draw_text_transformed(_x, _y, "work in progress", 1, 1, 0);
		//draw_set_color(c_white);
		_y = room_height - 32;
		draw_set_valign(fa_bottom);
		draw_text_transformed(_x, _y, "a game by rubinbizarre", 1, 1, 0);
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		draw_set_font(font_default);
	} break;
	case rm_main: {
		_x = 0;
		_y = 0;
		
		#region END OF DAY DISPLAY: PODCAST & BREAKDOWN
		if (global.display_end_of_day) {
			if (surface_exists(paused_surface)) {
				draw_clear_alpha(c_black, 0);
				surface_set_target(paused_surface);
				
				// draw rectangle background or label
				draw_set_color(#333333);
				var _label_w = 400;
				draw_rectangle(960 - _label_w, 60, 960 + _label_w, 960, false);
				
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				draw_set_color(global.c_haunt);
				draw_set_font(font_main);
				
				// draw 'end of [...]day, week [x]' title header
				// determine what _day_name to output based on _day_counter
				var _day_name = "XXXday";
				switch (global.day_counter) {
					case 0: _day_name = "Monday"; break;
					case 1: _day_name = "Tuesday"; break;
					case 2: _day_name = "Wednesday"; break;
					case 3: _day_name = "Thursday"; break;
					case 4: _day_name = "Friday"; break;
					case 5: _day_name = "Saturday"; break;
					case 6: _day_name = "Sunday"; break;
					default: _day_name = "ZZZday"; break;
				}
				_day_name = string_upper(_day_name);
				var _week_number = string(global.week_counter);
				_x = room_width/2;
				
				draw_text_transformed(_x, 150, "END OF "+_day_name, 2, 2, 0);
				draw_text_transformed(_x, 220, "-- WEEK "+_week_number+" --", 1, 1, 0);
				
				if (global.display_podcast) {
					draw_set_color(c_white);
					draw_text_transformed(_x, 310, "receiving transmission...", 1, 1, 0);
					draw_set_color(global.c_haunt);
					draw_text_transformed(_x, 400, "Nev's World Podcast", 1, 1, 0);
					draw_text_transformed(_x, 440, "Episode #"+string(global.podcast_episode_counter), 1, 1, 0);
				
					var _podcast_body = "Nerr-herr! Greetings, my fellow\nNev-Heads! Do you smell that? No, it\nisnt the stench of a rotting poltergeist";//, though there’s plenty of that in this dump of a town. It is the sweet, digital aroma of SUCCESS! We just hit 10,000 SUBSCRIBERS! My mom said I was just 'loitering in a minivan' but she’s clearly a sleeper agent for the PARANORMAL ENTITIES! Nerr. Today was a gold mine. I caught some highly suspicious activity near that old oak tree—totally a GHOST, DEMON or NEFARIOUS PRESENCE! I see believers in chat, the subscribers are pouring in, which means... I’M UPGRADING! Goodbye, crappy thrift-store camera! Tomorrow, I’m rolling out with a VCR VIDEOCAM! Now I can capture all the ectoplasmic nonsense in glorious, grainy 240p! You can run, you translucent freaks, but you can't hide from my new autofocus! Nerr-herr-herr! Stay vigilant, Nev-Heads. The truth is out there, and it’s probably haunting your bins!";
					draw_text_transformed(_x, (440+720)/2, _podcast_body, 1, 1, 0);
				
					draw_set_color(c_white);
					draw_text_transformed(_x, 750, "end of transmission.", 1, 1, 0);
					draw_text_transformed(_x, 850, "press ENTER to continue", 1, 1, 0);
				}
				
				if (global.display_breakdown) {
					draw_set_color(c_white);
					draw_text_transformed(_x, 310, "DAILY EVENTS BREAKDOWN", 1, 1, 0);
					draw_text_transformed(_x, 850, "press ENTER to start next day", 1, 1, 0);
				}
				
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
		
		#region PAUSED
		if (global.paused) {
			if (surface_exists(paused_surface)) {
				draw_clear_alpha(c_black, 0);
				surface_set_target(paused_surface);
				//draw_clear_alpha(c_black, 0);
		
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				draw_set_color(global.c_haunt);
				draw_set_font(font_main);
				// draw 'PAUSED' title header
				_x = room_width/2;
				draw_text_transformed(_x, room_height/2, "[NOT] PAUSED", 2, 2, 0);
				// draw pause menu text options: resume, settings, quit
				_ysep = 100;
				_y = room_height/2+160;
				var _c1 = global.c_haunt;
				var _c2 = global.c_haunt;
				var _c3 = global.c_haunt;
				// switch colour if pause_menu_select is matching
				switch (pause_menu_select) {
					case 0: _c1 = c_white; break;
					case 1: _c2 = c_white; break;
					case 2: _c3 = c_white; break;
				}
				draw_text_transformed_colour(_x, _y, "resume", 1, 1, 0, _c1, _c1, _c1, _c1, 1); _y += _ysep;
				draw_text_transformed_colour(_x, _y, "settings", 1, 1, 0, _c2, _c2, _c2, _c2, 1); _y += _ysep;
				draw_text_transformed_colour(_x, _y, "quit", 1, 1, 0, _c3, _c3, _c3, _c3, 1); _y += _ysep;
				
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
			_y = 16;
			draw_text_transformed(room_width - _x, _y, "fps:"+string(fps), 2, 2, 0); _y += _ysep;
			draw_text_transformed(room_width - _x, _y, "mouse_x:"+string(mouse_x), 2, 2, 0); _y += _ysep;
			draw_text_transformed(room_width - _x, _y, "mouse_y:"+string(mouse_y), 2, 2, 0); _y += _ysep;
			_y += _ysep;
			draw_text_transformed(room_width - _x, _y, "s_gain_events:"+string(global.daily_sub_gain_event_counter), 2, 2, 0); _y += _ysep;
			draw_text_transformed(room_width - _x, _y, "s_loss_events:"+string(global.daily_sub_gain_event_counter), 2, 2, 0); _y += _ysep;
			draw_set_halign(fa_left);
			draw_set_color(c_white);
		}
		#endregion
		
		#region HUD
		if (global.hud) and (!global.display_end_of_day) {
			draw_set_halign(fa_center);
			_x = room_width/2;
			_y = 16;
			_ysep = 40;

			draw_text_transformed(_x, _y, "HAUNT POINTS: "+string(global.haunt_points), 2, 2, 0); _y += _ysep;
			draw_text_transformed(_x, _y, "WEEK "+string(global.week_counter), 2, 2, 0); _y += _ysep;
			draw_text_transformed(_x, _y, scr_date_and_time(global.current_time_), 2, 2, 0); _y += _ysep; // draw time in format "Monday 20:32" include toggle for 12 hr time in settings "Monday 8:32 PM"
			draw_set_halign(fa_left);
		}
		
		#region deprecated menu_haunt_active display for haunting buildings (commented)
		//if (global.menu_haunt_active) {
		//	draw_set_halign(fa_center);
		//	_x = room_width/4;
		//	_y = room_height/4;
		//	_ysep = 40;
		//	draw_set_color(c_dkgray);
		//	draw_rectangle(_x - 400, _y - 50, _x + 400, _y + 400, false);
		//	draw_set_color(c_white);
		//	draw_text_transformed(_x, _y, "HAUNT THIS BUILDING?", 2, 2, 0); _y += _ysep;
		//	draw_text_transformed(_x, _y, "spend Haunt Points to Attempt Haunting", 2, 2, 0); _y += _ysep;
		//	draw_text_transformed(_x, _y, "HP required: "+string(global.tracked_building.stats.cost), 2, 2, 0); _y += _ysep;
		//	_y += _ysep;
		//	draw_text_transformed(_x, _y, "HP offered: "+string(global.offered_haunt_points), 2, 2, 0); _y += _ysep;
		//	_y += _ysep;
		//	if (global.haunt_difficulty > 0) {
		//		// convert haunt_difficulty into meaningful percentage for player
		//		//var _result = round((1 - global.haunt_difficulty) * 100); // rounded
		//		var _result = (1 - global.haunt_difficulty) * 100;
		//		var _diff_display = string(_result) + "%";
		//		draw_text_transformed(_x, _y, "difficulty: "+_diff_display, 2, 2, 0);
		//	}
		//	_y += _ysep;
		//	_y += _ysep;
		//	draw_text_transformed(_x, _y, "press ENTER to Haunt", 2, 2, 0); _y += _ysep;
		//	draw_set_halign(fa_left);
		//}
		#endregion

		#endregion
	} break;
}