#region draw podcast box (non-surface version) - working (commented)
//var _gui_w = display_get_gui_width();
//var _gui_h = display_get_gui_height();

//// draw bg label for this podcast-box
//draw_set_colour(#333333);
//var _label_x1 = _gui_w * 0.7;
//var _label_x2 = _gui_w;
//var _label_y1 = 0;
//var _label_y2 = _gui_h;
//draw_rectangle(_label_x1, _label_y1, _label_x2, _label_y2, false);

//// draw 'Nev's World' logo
//var _logo_x = (_label_x1 + _label_x2) / 2;
//var _logo_y = _gui_h * 0.1;
//draw_sprite_ext(spr_podcast_logo, 0, _logo_x, _logo_y, 5, 5, 0, c_white, 1);

//// draw 'PODCAST' text beneath logo
//draw_set_halign(fa_center);
//draw_set_colour(#b4a4ff);
//draw_set_font(font_main_header);
//draw_text(_logo_x, _logo_y * 1.33, "PODCAST");

//draw_set_halign(fa_left);
//draw_set_font(font_main_body);
//var _str_subs_text = "SUBS:";
//var _str_subs_text_width = string_width(_str_subs_text) * 1.2;
//var _str_subs_amount = number_to_comma_string(global.subs, false);
//var _str_subs_x = _label_x1 * 1.065;
//var _str_subs_y = _logo_y * 2.2;
//var _str_subs_amount_length = string_length(_str_subs_amount);
//var _xscale = 1;
//var _xscale_upper = 1;
//var _xscale_lower = 0.8;
//var _xscale_diff = _xscale_upper - _xscale_lower;
//switch (_str_subs_amount_length) {
//	case 7: _xscale = _xscale_upper - (_xscale_diff * 0.33); break;
//	case 8: _xscale = _xscale_upper - (_xscale_diff * 0.66); break;
//	case 9: _xscale = _xscale_lower; break;
//	default: _xscale = _xscale_upper; break;
//}
//// draw "SUBS:"
//draw_text(_str_subs_x, _str_subs_y * 1.05, _str_subs_text);
//// draw actual subs value
//draw_set_font(font_main_header);
//draw_text_transformed(_str_subs_x + _str_subs_text_width, _str_subs_y, _str_subs_amount, _xscale, 1, 0);

//draw_set_font(font_main_body);
//var _str_goal_text = "GOAL:";
//var _str_goal_text_width = string_width(_str_goal_text) * 1.2;
//var _str_goal_x = _label_x1 * 1.065;
//var _str_goal_y = _str_subs_y * 1.33;
//var _str_goal_amount = "10,000";
//switch (global.nev_gear_tier) {
//	case 0: _str_goal_amount = "10,000"; break;
//	case 1: _str_goal_amount = "50,000"; break;
//	case 2: _str_goal_amount = "100,000"; break;
//	case 3: _str_goal_amount = "1,000,000"; break;
//	case 4: _str_goal_amount = "9,999,999"; break;
//}
//var _str_goal_amount_length = string_length(_str_goal_amount);
//// length is between 6 and 9, so xscale is affected when 7, 8, 9
//// as length increases, xscale decreases
//_xscale = 1;
//_xscale_upper = 1;
//_xscale_lower = 0.8;
//_xscale_diff = _xscale_upper - _xscale_lower;
//switch (_str_goal_amount_length) {
//	case 7: _xscale = _xscale_upper - (_xscale_diff * 0.33); break;
//	case 8: _xscale = _xscale_upper - (_xscale_diff * 0.66); break;
//	case 9: _xscale = _xscale_lower; break;
//	default: _xscale = _xscale_upper; break;
//}

//// draw "GOAL:"
//draw_text(_str_goal_x, _str_goal_y * 1.04, _str_goal_text);
//// draw actual sub goal value
//draw_set_font(font_main_header);
//draw_text_transformed(_str_goal_x + _str_goal_text_width, _str_goal_y, _str_goal_amount, _xscale, 1, 0);

//draw_set_font(font_main_body);
//var _str_help_me_get = "Help me get a new";
//var _str_next_gear = "unassigned";
//var _str_next_gear_y = _gui_h * 0.385;
//switch (global.nev_gear_tier) {
//	case 0: _str_next_gear = "VCR VIDEOCAM"; break;
//	case 1: _str_next_gear = "PRO TV CAMERA"; break;
//	case 2: _str_next_gear = "EMF MONITOR"; break;
//	case 3: _str_next_gear = "POLTERGUST"; break;
//	case 4: _str_next_gear = "All Evil Spirits!"; _str_help_me_get = "Watch me destroy";
//}
//// draw first line "Help me get a new"
//draw_text(_str_goal_x, _str_next_gear_y, _str_help_me_get);
//// draw second line e.g. "EMF MONITOR!"
//draw_text(_str_goal_x, _str_next_gear_y + 36, _str_next_gear + "!");

//var _bar_x = _logo_x;
//var _bar_y = _gui_h * 0.535;
//var _bar_w = _gui_w - (_logo_x * 1.04);
//var _bar_h = _gui_h * 0.04;
//draw_set_color(#222222);
//draw_rectangle(
//	_bar_x - _bar_w,
//	_bar_y - _bar_h,
//	_bar_x + _bar_w,
//	_bar_y + _bar_h,
//	false
//);
//var _int_goal_amount = 10000;
//switch (global.nev_gear_tier) {
//	case 0: _int_goal_amount = 10000; break;
//	case 1: _int_goal_amount = 50000; break;
//	case 2: _int_goal_amount = 100000; break;
//	case 3: _int_goal_amount = 1000000; break;
//	case 4: _int_goal_amount = 9999999; break;
//}
//var _goal_progress = global.subs / _int_goal_amount;
//var _bar_width = (_bar_x + _bar_w) - (_bar_x - _bar_w);
//draw_set_colour(#b4a4ff);
//draw_rectangle(
//	_bar_x - _bar_w,
//	_bar_y - _bar_h,
//	(_bar_x - _bar_w) + (_bar_width * _goal_progress),
//	_bar_y + _bar_h,
//	false
//);
//draw_set_font(font_main_body);
//draw_set_colour(c_white);
//draw_set_halign(fa_center);
//draw_set_valign(fa_middle);
//draw_text_transformed(_bar_x, _bar_y, _str_subs_amount+"/"+_str_goal_amount, _xscale, 1, 0);
////draw_text(_bar_x, _bar_y + 45, string(_goal_progress)); // debug

//// draw live chat bg label
//_label_y1 = _gui_h * 0.68;
//_label_y2 = _gui_h;
//var _label_border = 8;
//var _chat_header_h = 42;
//draw_set_colour(#666666);
//draw_rectangle(_label_x1, _label_y1 - _chat_header_h, _label_x2, _label_y2, false); // border
//draw_set_valign(fa_top);
//draw_set_halign(fa_left);
//draw_set_colour(#999999);
//draw_text(_label_x1 + (_label_border * 2.8), _label_y1 - (_chat_header_h - 3), "LIVE CHAT");
//draw_set_halign(fa_right);
//draw_set_colour(#888888);
//draw_text_transformed(_label_x2 - (_label_border * 2), _label_y1 - (_chat_header_h - 3), "nevs-world.com", 0.8, 1, 0);
//draw_set_colour(#444444);
//draw_rectangle(_label_x1 + _label_border, _label_y1 + _label_border, _label_x2 - _label_border, _label_y2 - _label_border, false); // border

//draw_set_halign(fa_left);
//draw_set_font(font_main_sub);
//var _chat_x = _label_x1 + (_label_border * 2.8);
//var _chat_y = _label_y2 - (_chat_header_h*2);
//var _chat_user = "admin"+": ";
//var _chat_user_width = string_width(_chat_user)*2;
//var _chat_msg = "Live chat is offline and\nunder maintenance."
//// draw "admin: "
//draw_set_colour(global.c_haunt);
//draw_text_transformed(_chat_x, _chat_y, _chat_user, 2, 2, 0);
//// draw "live chat under maintenance"
//draw_set_colour(#999999);
//draw_text_transformed(_chat_x + _chat_user_width, _chat_y, _chat_msg, 2, 2, 0);

//// cleanup
//draw_set_halign(fa_left);
//draw_set_valign(fa_top);
//draw_set_colour(c_white);
//draw_set_font(global.font_default);
#endregion

if (!global.paused) and (!global.display_end_of_day) {
	if (surface_exists(podcast_surface)) {
		//draw_clear_alpha(c_black, 0);
		surface_set_target(podcast_surface);
		draw_clear_alpha(c_black, 0);
	
		#region draw podcast box
		var _surf_w = surface_get_width(podcast_surface);
		var _surf_h = surface_get_height(podcast_surface);
	
		// draw clickable tab thingy
		var _tab_w = 128;
		var _tab_h = 128;
		var _tab_x2 = _surf_w * 0.72;
		var _tab_x1 = _tab_x2 - _tab_w;
		var _tab_y1 = 32;
		var _tab_y2 = _tab_y1 + _tab_h;
		var _tab_r = 16;
		var _tab_r_inner = _tab_r*0.8;
		//var _tab_border = 6;
		draw_set_colour(#b4a4ff);
		draw_roundrect_ext(_tab_x1, _tab_y1, _tab_x2, _tab_y2, _tab_r, _tab_r, false);
		draw_set_colour(#333333);
		draw_roundrect_ext(_tab_x1 + tab_border, _tab_y1 + tab_border, _tab_x2 - tab_border, _tab_y2 - tab_border, _tab_r_inner, _tab_r_inner, false);
		draw_set_colour(c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(font_main_header);
		//var _tab_char = "<";
		//if (display_active) _tab_char = ">";
		var _tab_char = (display_active) ? ">" : "<";
		var _tab_char_x = (_tab_x1 + _tab_x2)/2.02;
		var _tab_char_y = ((_tab_y1 +_tab_y2) / 2) - 8;
		draw_text(_tab_char_x, _tab_char_y, _tab_char);
		draw_set_font(font_main_sub);
		draw_set_colour(#dbdbdb);
		draw_text(_tab_char_x, _tab_char_y + 36, "[tab]");
		
		//// draw rings notification
		//var _rings_x = _tab_char_x;
		//var _rings_y = (_tab_y1 +_tab_y2) / 2;
		//if (ring_active) {
		//	draw_set_alpha(ring_alpha);
		//	draw_circle(_rings_x, _rings_y, ring_radius, true);
		//	draw_set_alpha(1);
		//}
		//if (ring_active_2) {
		//	draw_set_alpha(ring_alpha_2);
		//	draw_circle(_rings_x, _rings_y, ring_radius_2, true);
		//	draw_set_alpha(1);
		//}
		
		// draw bg label for this podcast-box
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_colour(#333333);
		var _label_x1 = _surf_w * 0.7;
		var _label_x2 = _surf_w;
		var _label_y1 = 0;
		var _label_y2 = _surf_h;
		draw_rectangle(_label_x1, _label_y1, _label_x2, _label_y2, false);
	
		// draw highlighted edge for this label
		draw_set_colour(#b4a4ff);
		draw_rectangle(_label_x1 - tab_border, _label_y1, _label_x1, _tab_y1 + tab_border, false);
		draw_rectangle(_label_x1 - tab_border, _tab_y2 - (tab_border - 1), _label_x1, _label_y2, false);
		
		// draw rings notification
		var _rings_x = _tab_char_x;
		var _rings_y = (_tab_y1 +_tab_y2) / 2;
		if (ring_active) {
			draw_set_alpha(ring_alpha);
			draw_circle(_rings_x, _rings_y, ring_radius, true);
			draw_set_alpha(1);
		}
		if (ring_active_2) {
			draw_set_alpha(ring_alpha_2);
			draw_circle(_rings_x, _rings_y, ring_radius_2, true);
			draw_set_alpha(1);
		}
		
		// draw 'Nev's World' logo
		var _logo_x = (_label_x1 + _label_x2) / 2;
		var _logo_y = _surf_h * 0.1;
		draw_sprite_ext(spr_podcast_logo, 0, _logo_x, _logo_y, 5, 5, 0, c_white, 1);

		// draw 'PODCAST' text beneath logo
		draw_set_halign(fa_center);
		draw_set_colour(#b4a4ff);
		draw_set_font(font_main_header);
		draw_text(_logo_x, _logo_y * 1.33, "PODCAST");
		
		draw_set_colour(#d7cfff);
		draw_set_halign(fa_left);
		draw_set_font(font_main_body);
		var _str_subs_text = "SUBS:";
		var _str_subs_text_width = string_width(_str_subs_text) * 1.2;
		var _str_subs_amount = number_to_comma_string(subs_display, false);
		var _str_subs_x = _label_x1 * 1.065;
		var _str_subs_y = _logo_y * 2.2;
		var _str_subs_amount_length = string_length(_str_subs_amount);
		var _xscale = 1;
		var _xscale_upper = 1;
		var _xscale_lower = 0.8;
		var _xscale_diff = _xscale_upper - _xscale_lower;
		switch (_str_subs_amount_length) {
			case 7: _xscale = _xscale_upper - (_xscale_diff * 0.33); break;
			case 8: _xscale = _xscale_upper - (_xscale_diff * 0.66); break;
			case 9: _xscale = _xscale_lower; break;
			default: _xscale = _xscale_upper; break;
		}
		// draw "SUBS:"
		draw_text(_str_subs_x, _str_subs_y * 1.05, _str_subs_text);
		// draw actual subs value
		draw_set_font(font_main_header);
		draw_text_transformed(_str_subs_x + _str_subs_text_width, _str_subs_y, _str_subs_amount, _xscale, 1, 0);

		draw_set_font(font_main_body);
		var _str_goal_text = "GOAL:";
		var _str_goal_text_width = string_width(_str_goal_text) * 1.2;
		var _str_goal_x = _label_x1 * 1.065;
		var _str_goal_y = _str_subs_y * 1.33;
		var _str_goal_amount = "10,000";
		switch (global.nev_gear_tier) {
			case 0: _str_goal_amount = "10,000"; break;
			case 1: _str_goal_amount = "50,000"; break;
			case 2: _str_goal_amount = "100,000"; break;
			case 3: _str_goal_amount = "1,000,000"; break;
			case 4: _str_goal_amount = "9,999,999"; break;
		}
		var _str_goal_amount_length = string_length(_str_goal_amount);
		// length is between 6 and 9, so xscale is affected when 7, 8, 9
		// as length increases, xscale decreases
		_xscale = 1;
		_xscale_upper = 1;
		_xscale_lower = 0.8;
		_xscale_diff = _xscale_upper - _xscale_lower;
		switch (_str_goal_amount_length) {
			case 7: _xscale = _xscale_upper - (_xscale_diff * 0.33); break;
			case 8: _xscale = _xscale_upper - (_xscale_diff * 0.66); break;
			case 9: _xscale = _xscale_lower; break;
			default: _xscale = _xscale_upper; break;
		}
		// draw "GOAL:"
		draw_text(_str_goal_x, _str_goal_y * 1.04, _str_goal_text);
		// draw actual sub goal value
		draw_set_font(font_main_header);
		draw_text_transformed(_str_goal_x + _str_goal_text_width, _str_goal_y, _str_goal_amount, _xscale, 1, 0);
		
		draw_set_colour(#b4a4ff);
		draw_set_font(font_main_body);
		var _str_help_me_get = "Help me get a new";
		var _str_next_gear = "unassigned";
		var _str_next_gear_y = _surf_h * 0.385;
		switch (global.nev_gear_at_day_start) {
			case 0: _str_next_gear = "VCR VIDEOCAM"; break;
			case 1: _str_next_gear = "PRO TV CAMERA"; break;
			case 2: _str_next_gear = "EMF MONITOR"; break;
			case 3: _str_next_gear = "POLTERGUST"; break;
			case 4: _str_next_gear = "All Evil Spirits!"; _str_help_me_get = "Watch me destroy";
		}
		// draw first line "Help me get a new"
		draw_text(_str_goal_x, _str_next_gear_y, _str_help_me_get);
		// draw second line e.g. "EMF MONITOR!"
		draw_text(_str_goal_x, _str_next_gear_y + 36, _str_next_gear + "!");

		var _bar_x = _logo_x;
		var _bar_y = _surf_h * 0.535;
		var _bar_w = _surf_w - (_logo_x * 1.04);
		var _bar_h = _surf_h * 0.04;
		draw_set_color(#222222);
		draw_rectangle(
			_bar_x - _bar_w,
			_bar_y - _bar_h,
			_bar_x + _bar_w,
			_bar_y + _bar_h,
			false
		);
		var _int_goal_amount = 10000;
		switch (global.nev_gear_at_day_start) {
			case 0: _int_goal_amount = 10000; break;
			case 1: _int_goal_amount = 50000; break;
			case 2: _int_goal_amount = 100000; break;
			case 3: _int_goal_amount = 1000000; break;
			case 4: _int_goal_amount = 9999999; break;
		}
		var _goal_progress = subs_display / _int_goal_amount;
		_goal_progress = clamp(_goal_progress, 0, 1);
		var _bar_width = (_bar_x + _bar_w) - (_bar_x - _bar_w);
		draw_set_font(font_main_body);
		draw_set_colour(c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		if (_goal_progress == 1) {
			draw_set_colour(#333333);
			draw_rectangle(
				_bar_x - _bar_w,
				_bar_y - _bar_h,
				(_bar_x - _bar_w) + (_bar_width * _goal_progress),
				_bar_y + _bar_h,
				false
			);
			draw_set_colour(c_white);
			draw_text(_bar_x, _bar_y-20, "GOAL REACHED!");
			draw_text_ext(_bar_x, _bar_y+40, "I will be upgrading\nmy gear tomorrow!!", 36, 999);
		} else {
			draw_set_colour(#b4a4ff);
			draw_rectangle(
				_bar_x - _bar_w,
				_bar_y - _bar_h,
				(_bar_x - _bar_w) + (_bar_width * _goal_progress),
				_bar_y + _bar_h,
				false
			);
			draw_set_colour(c_white);
			draw_text_transformed(_bar_x, _bar_y, _str_subs_amount+"/"+_str_goal_amount, _xscale, 1, 0);
		}
		//draw_text(_bar_x, _bar_y + 45, string(_goal_progress)); // debug

		// draw live chat bg label
		_label_y1 = _surf_h * 0.68;
		_label_y2 = _surf_h;
		var _label_border = 8;
		var _chat_header_h = 42;
		draw_set_colour(#666666);
		draw_rectangle(_label_x1, _label_y1 - _chat_header_h, _label_x2, _label_y2, false); // border
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		//draw_set_colour(#999999);
		draw_set_colour(#dbdbdb);
		draw_text(_label_x1 + (_label_border * 2.8), _label_y1 - (_chat_header_h - 3), "LIVE CHAT");
		draw_set_halign(fa_right);
		//draw_set_colour(#888888);
		draw_set_colour(#999999);
		draw_text_transformed(_label_x2 - (_label_border * 2), _label_y1 - (_chat_header_h - 3), "nevs-world.com", 0.8, 1, 0);
		draw_set_colour(#444444);
		draw_rectangle(_label_x1 + _label_border, _label_y1 + _label_border, _label_x2 - _label_border, _label_y2 - _label_border, false); // border

		draw_set_halign(fa_left);
		draw_set_font(font_main_sub);
		var _chat_x = _label_x1 + (_label_border * 2.8);
		var _chat_y = _label_y2 - (_chat_header_h*2);
		var _chat_user = "admin"+": ";
		var _chat_user_width = string_width(_chat_user)*2;
		var _chat_msg = "Live chat is offline and\nunder maintenance."
		// draw "admin: "
		draw_set_colour(global.c_haunt);
		draw_text_transformed(_chat_x, _chat_y, _chat_user, 2, 2, 0);
		// draw "live chat under maintenance"
		//draw_set_colour(#999999);
		draw_set_colour(#dbdbdb);
		draw_text_transformed(_chat_x + _chat_user_width, _chat_y, _chat_msg, 2, 2, 0);
	
		// cleanup
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_colour(c_white);
		draw_set_font(global.font_default);
		#endregion
				
		surface_reset_target();
		draw_surface(podcast_surface, shift, 0);
	} else {
		if (global.debug) show_debug_message("obj_master DRAW_GUI: podcast_surface does not exist, creating it now...");
		podcast_surface = surface_create(display_get_gui_width(), display_get_gui_height());
		surface_copy(podcast_surface, 0, 0, application_surface);
	}
	
	#region debug
	//var _gui_w = display_get_gui_width();
	//var _gui_h = display_get_gui_height();
	//draw_text_transformed(_gui_w/2, _gui_h/2, "display_active:"+string(display_active), 2, 2, 0);
	//draw_text_transformed(_gui_w/2, (_gui_h/2)+40, "tab_hover:"+string(tab_hover), 2, 2, 0);
	//draw_text_transformed(_gui_w/2, (_gui_h/2)+80, "tab_press:"+string(tab_press), 2, 2, 0);
	
	//// debug: draw area where tab_hover is measured
	//var _surf_w = surface_get_width(podcast_surface);
	//var _surf_h = surface_get_height(podcast_surface);
	//var _tab_w = 128;
	//var _tab_h = 128;
	//var _tab_x2 = (_surf_w * 0.72) ;
	//var _tab_x1 = (_tab_x2 - _tab_w);
	//var _tab_y1 = 32;
	//var _tab_y2 = _tab_y1 + _tab_h;
	//draw_set_alpha(0.5);
	//draw_set_colour(c_lime);
	//draw_rectangle(_tab_x1 + (shift), _tab_y1, _tab_x2 + (shift), _tab_y2, false);
	//// cleanup
	//draw_set_colour(c_white)
	//draw_set_alpha(1);
	#endregion
}