var _x = 0;
var _y = 0;
var _ysep = 0;

switch (room) {
	case rm_title: {
		_x = room_width/2;
		_y = 32;
		var _prev_font = draw_get_font();
		draw_set_font(font_main_body);
		draw_set_halign(fa_center);
		//draw_set_color(c_fuchsia);
		draw_text_transformed(_x, _y, "work in progress", 1, 1, 0);
		//draw_set_color(c_white);
		_y = room_height - 32;
		draw_set_valign(fa_bottom);
		draw_text_transformed(_x, _y, "a game by rubinbizarre", 1, 1, 0);
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		draw_set_font(global.font_default);
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
				draw_set_font(font_main_body);
				
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
				draw_set_font(global.font_default);
				
				surface_reset_target();
				draw_surface(paused_surface, 0, 0);
			} else {
				if (global.debug) show_debug_message("obj_master DRAW_GUI: paused_surface does not exist, creating it now...");
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
				draw_set_font(font_main_body);
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
				draw_set_font(global.font_default);
		
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
			#region old time/day/week/hauntpoints display (top middle) (commented)
			////draw_set_font(font_main_header);
			//draw_set_halign(fa_center);
			//_x = room_width/2;
			//_y = 16;
			//_ysep = 40;

			//draw_text_transformed(_x, _y, "HAUNT POINTS: "+string(global.haunt_points), 2, 2, 0); _y += _ysep;
			//draw_text_transformed(_x, _y, "WEEK "+string(global.week_counter), 2, 2, 0); _y += _ysep;
			//draw_set_font(font_main_body);
			//draw_text_transformed(_x, _y, scr_date_and_time(global.current_time_), 2, 2, 0); _y += _ysep; // draw time in format "Monday 20:32" include toggle for 12 hr time in settings "Monday 8:32 PM"
			//draw_set_halign(fa_left);
			////draw_set_font(global.font_default);
			#endregion
			
			#region new time/day/week display (lower left)
			draw_set_halign(fa_center);
			_x = room_width * 0.1;
			var _y_header = room_height * 0.8;
			var _y_body = room_height * 0.9;
			
			var _time = get_current_time(global.current_time_);
			var _day_name = get_current_day();
			//var _day_name_length = string_length(_day_name);
			var _xoffset = 72;
			var _week_no = "Week "+string(global.week_counter);
			//var _week_no_length = string_length(_week_no);
			//var _overall_length = _day_name_length + _xoffset + _week_no_length;
			//var _xoffset_time = _overall_length / 2;
			
			// draw current time, header
			draw_set_font(font_main_header);
			draw_text(_x, _y_header, _time);
			
			// draw separator line
			var _xoffset_multiplier = 1.8;
			var _line_height = 2;
			var _x1 = _x - _xoffset * _xoffset_multiplier;
			var _x2 = _x + _xoffset * _xoffset_multiplier;
			var _y1 = ((_y_header + _y_body) / 1.93) - _line_height;
			var _y2 = ((_y_header + _y_body) / 1.93) + _line_height;
			draw_rectangle(_x1, _y1, _x2, _y2, false);
			
			// draw day name, followed by week #, body
			draw_set_font(font_main_body);
			var _x_day = _x - _xoffset;
			var _w_day = 50;
			var _h_day = 40;
			_x1 = _x_day - (_w_day + 12);
			_x2 = _x_day + _w_day;
			_y1 = _y_body - 5;
			_y2 = _y_body + 50;
			var _r = 12;
			//draw_set_colour(global.c_haunt);
			draw_set_colour(#5c4769);
			draw_roundrect_ext(_x1, _y1, _x2, _y2, _r, _r, false);
			draw_set_colour(global.c_haunt);
			//draw_set_colour(c_white);
			draw_text(_x_day, _y_body, _day_name);
			draw_set_colour(c_white);
			draw_text(_x + _xoffset, _y_body, _week_no);
			
			// cleanup
			draw_set_halign(fa_left);
			draw_set_font(global.font_default);
			#endregion
			
			#region new HAUNT POINTS display (upper left)
			draw_set_font(font_main_body);
			_x = 40;
			_y = 35;
			
			var _hp_text = "HAUNT POINTS: ";
			var _hp_text_len = string_width(_hp_text);
			var _hp_amount = string(hp_display);
			
			draw_set_colour(c_white);
			draw_text(_x, _y, _hp_text);
			
			// draw rounded rectangle label behind amount
			draw_set_font(font_main_header);
			var _x_label = _x + _hp_text_len + (string_width(_hp_amount)/2);
			var _y_label = (_y - 10) + (string_height(_hp_amount)/2);
			var _r_label = 12;
			var _w_label = string_width(_hp_amount)/1.33;
			var _h_label = 28;
			draw_set_color(global.c_haunt);
			draw_roundrect_ext(
				_x_label - _w_label,
				_y_label - _h_label,
				_x_label + _w_label,
				_y_label + _h_label,
				_r_label,
				_r_label,
				false
			);
			
			draw_set_colour(#333333);
			draw_text(_x + _hp_text_len, _y - 10, _hp_amount);
			
			// cleanup
			draw_set_colour(c_white);
			draw_set_font(global.font_default);
			#endregion
			
			#region display current objective (upper middle)
			var _obj_upper = "- CURRENT OBJECTIVE -";
			var _obj_lower = objective;
			_x = room_width/2;
			_y = 35;
			draw_set_halign(fa_center);
			draw_set_font(font_main_sub);
			draw_text_transformed(_x, _y, _obj_upper, 2, 2, 0);
			_y += 35;
			draw_set_font(font_main_body);
			draw_text(_x, _y, _obj_lower);
			// cleanup
			draw_set_halign(fa_left);
			draw_set_font(global.font_default);
			#endregion
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