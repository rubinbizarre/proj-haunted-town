switch (room) {
	case rm_main: {
		#region handle input whilst haunting a house (whilst haunt menu is active) (commented)
		//if (global.menu_haunt_active) {
		//	global.haunt_difficulty = global.offered_haunt_points / (global.offered_haunt_points + global.tracked_building.stats.cost);
	
		//	// decrement offered HP. no less than zero
		//	if (keyboard_check_pressed(vk_down)) {
		//		if (global.offered_haunt_points > 0) {
		//			global.offered_haunt_points -= 1;
		//			//show_debug_message("obj_master STEP: decremented offered HP");
		//		}
		//	}
		//	// increment offered HP. cap to amount of HP owned
		//	if (keyboard_check_pressed(vk_up)) {
		//		if (global.offered_haunt_points < global.haunt_points) {
		//			global.offered_haunt_points += 1;
		//			//show_debug_message("obj_master STEP: incremented offered HP");
		//		}
		//	}
	
		//	// confirm input
		//	if (keyboard_check_pressed(vk_enter)) {
		//		// validate input:
		//		// proceed: player entered at least minimum amount HP required
		//		if (global.offered_haunt_points >= global.tracked_building.stats.cost) {
		//			// start haunt process
		//			if (instance_exists(obj_skillcheck)) {
		//				obj_skillcheck.trigger();
		//			}
		//		} else { // abort: player did not enter the minimum amount of HP required
		//			show_message("HAUNT ABORTED\nYou need to spend at least "+string(global.tracked_building.stats.cost)+" Haunt Points to Haunt this building.");
		//			abort_haunt_process();
		//		}
		//	}
		//}
		#endregion
	
		#region handle pause activation/deactivation
		if (keyboard_check_pressed(ord("P"))) {
			toggle_pause();
		}
		#endregion
		
		#region handle input while paused
		if (global.paused) {
			// keyboard: switching pause menu options
			if (!instance_exists(obj_settings)) {
				if (keyboard_check_pressed(vk_down)) {
					if (pause_menu_select < 2) {
						pause_menu_select++;
					} else {
						pause_menu_select = 0;
					}
				}
				if (keyboard_check_pressed(vk_up)) {
					if (pause_menu_select > 0) {
						pause_menu_select--;
					} else {
						pause_menu_select = 2;
					}
				}
			}
			// keyboard: confirming pause menu option
			if (keyboard_check_pressed(vk_space) or keyboard_check_pressed(vk_enter)) {
				switch (pause_menu_select) {
					case 0: { // resume
						toggle_pause();
					} break;
					case 1: { // settings
						instance_create_layer(0, 0, "Master", obj_settings);
					} break;
					case 2: { // quit (return to title)
						room_goto(rm_title);
					} break;
				}
			}
			// mouse hover: switching pause menu options
			var _cam = camera_get_active();
			var _xx = camera_get_view_x(_cam) + (camera_get_view_width(_cam)/2);
			var _yy = camera_get_view_y(_cam) + (camera_get_view_height(_cam)/2) + 160;
			var _btn_w = 100;
			var _btn_h = 30;
			var _btn_ysep = 100;
			var _x1 = _xx - _btn_w;
			var _y1 = _yy - _btn_h;
			var _x2 = _xx + _btn_w;
			var _y2 = _yy + _btn_h;
			if (!instance_exists(obj_settings)) {
				// resume
				if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x1, _y1, _x2, _y2)) {
					if (pause_menu_select != 0) pause_menu_select = 0;
					// confirm
					if (mouse_check_button_released(mb_left)) {
						toggle_pause();
					}
				}
				_y1 += _btn_ysep;
				_y2 += _btn_ysep;
				// settings
				if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x1, _y1, _x2, _y2)) {
					if (pause_menu_select != 1) pause_menu_select = 1;
					// confirm
					if (mouse_check_button_released(mb_left)) {
						instance_create_layer(0, 0, "Master", obj_settings);
					}
				}
				_y1 += _btn_ysep;
				_y2 += _btn_ysep;
				// quit (return to title)
				if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x1, _y1, _x2, _y2)) {
					if (pause_menu_select != 2) pause_menu_select = 2;
					// confirm
					if (mouse_check_button_released(mb_left)) {
						room_goto(rm_title);
					}
				}
			}
		}
		#endregion
		
		#region handle input while podcast is displayed
		if (global.display_end_of_day) {
			if (keyboard_check_pressed(vk_enter)) {
				if (global.display_podcast) {
					global.display_podcast = false;
					global.display_breakdown = true;
					
					#region create daily breakdown textbox
					//var _tb = instance_create_layer(0, 0, "Master", obj_textbox);

					//// lock it to read-only — no cursor, no input
					//_tb.config.read_only = true;
					////_tb.config.active    = false;

					//// build and inject the summary text
					//_tb.input_string = obj_textbox.build_summary_text();
					//_tb.rebuild_lines();

					//// store the reference so you can destroy it later
					//global.tb = _tb;
					
					//global.summary_box = instance_create_layer(0, 0, "Master", obj_summary_box);
					////global.summary_box.load();
					
					instance_activate_object(global.summary_box);
					global.summary_box.toggle_display();
					#endregion
					
				} else if (global.display_breakdown) {
					global.display_breakdown = false;
					
					// destroy breakdown textbox
					//instance_destroy(global.tb);
					//global.tb = noone;
					global.summary_box.toggle_display();
					
					toggle_display_end_of_day();
					
					// increment day
					obj_manager_time.increment_day_counter();
				}
			}
		}
		#endregion
		
		// while unpaused and not displaying daily summary
		if (!global.paused) and (!global.display_end_of_day) {
			
			#region create 'cursor click' inst effect
			if (mouse_check_button_pressed(mb_left)) or (gamepad_button_check_pressed(0, gp_face1)) {
				//var _x = device_mouse_x_to_gui(0);
				//var _y = device_mouse_y_to_gui(0);
				//instance_create_layer(_x, _y, "Master", obj_cursor_click_gui);
				
				//var _x = mouse_x;
				//var _y = mouse_y;
				var _x = cursor_x();
				var _y = cursor_y();
				instance_create_layer(_x, _y, "Master", obj_cursor_click);
				//if (!instance_exists(obj_nev_scared)) {
				//	instance_create_layer(_x, _y, "Master", obj_nev_scared);
				//}
				//show_debug_message("obj_master STEP: created obj_cursor_click");
			}
			#endregion
			
			#region handle displaying HAUNT POINTS w/ lerp effect
			// primarily needed for when Nev empties the escrow

			//if (escrow_display == obj_wo_trashcan.escrow) return; // no need to update the display val if it's already the same as actual val
			var _hp = global.haunt_points;
			if (hp_display != _hp) {
				// depending on how fast you want the display val to catch up
				var _new_hp_display = round(lerp(hp_display, _hp, hp_display_strength));

				// if the increment is large enough to make a difference, use the newly calculated val
				// otherwise, move the display val 1 unit closer towards the actual val
				if (_new_hp_display != hp_display) {
					hp_display = _new_hp_display;
				} else {
					hp_display += sign(_hp - hp_display);
				}
			}
			#endregion
			
			#region handle toggling HUD visibility
			if keyboard_check_pressed(ord("H")) {
				global.hud = !global.hud;
				//show_message("obj_master toggle hud");
			}
			#endregion
			
			#region handle SUPER HAUNT activation
			if (keyboard_check_pressed(vk_space)) and (global.super_haunt_ready) {
				global.super_haunt_ready = false;
				global.super_haunt_active = true;
				// start timer to decrement lifetime hp (super haunt meter)
				// "The Super Haunt Meter stores all the spooks you've earned so far"
				timer_super_haunt_cur = timer_super_haunt_max;
				
				// deactivate all currently haunted world- and scary-objects
				// right now it just deactivates all of the instances even if they are not active?
				for (var _i = 0; _i < instance_number(obj_par_world_objects); _i++) {
					var _inst = instance_find(obj_par_world_objects, _i);
					_inst.deactivate();
				}
				for (var _i = 0; _i < instance_number(obj_par_scary_objects); _i++) {
					var _inst = instance_find(obj_par_scary_objects, _i);
					_inst.deactivate();
				}
				
				//// reset lifetime hp
				//// this could instead decrease slowly and-
				//// be the indicator of how much time you have left
				//global.lifetime_haunt_points = 0;
				
				//// increment super haunt threshold - only when getting nev's fear maxed out
				//global.super_haunt_threshold_index ++;
				
				// deploy nev_scared
				if (instance_exists(obj_nev_van)) {
					obj_nev_van.deploy_nev_scared();
				}
			}
			#endregion
			
			#region handle SUPER HAUNT duration and end logic
			if (global.super_haunt_active) {
				if (timer_super_haunt_cur > 0) {
					timer_super_haunt_cur -= (delta_time / 1000000) * obj_manager_time.time_speed_normalised;

					if (timer_super_haunt_cur <= 0) {
					    timer_super_haunt_cur = -1;
					    #region --- alarm code ---
						if (global.lifetime_haunt_points > 0) {
							// drain lifetime hp by one
							global.lifetime_haunt_points -= 1;
							// reset sh_rect_offset to zero
							sh_rect_offset = 0;
							// trigger timer to go again
							timer_super_haunt_cur = timer_super_haunt_max;
						} else {
							// SUPER HAUNT has ran out of time and is finished
							global.super_haunt_active = false;
							// now make nev return to normal:
							// copy key values to pass over
							var _x, _y, _depth, _return_van_x, _return_van_y, _return_path_x, _return_path_y;
							if (instance_exists(obj_nev_scared)) {
								_x = obj_nev_scared.x;
								_y = obj_nev_scared.y;
								_depth = obj_nev_scared.depth;
								_return_van_x = obj_nev_scared.return_van_x;
								_return_van_y = obj_nev_scared.return_van_y;
								_return_path_x = obj_nev_scared.return_path_x;
								_return_path_y = obj_nev_scared.return_path_y;
								// destroying nev_scared also destroys ps_scared
								instance_destroy(obj_nev_scared);
							}
							// clear todo queue
							var _arr = global.nev_todo_queue;
							var _n = array_length(_arr);
							array_delete(_arr, 0, _n);
							// create nev inst that is sure to return to van
							with instance_create_depth(_x, _y, _depth, obj_nev) {
								// target nearest path node to travel to first
								var _target = instance_nearest(x, y, obj_node_circuit);
								target_x = _target.x;
								target_y = _target.y;
								// assign variable values passed from nev_scared
								return_van_x = _return_van_x;
								return_van_y = _return_van_y;
								return_path_x = _return_path_x;
								return_path_y = _return_path_y;
								// assign state
								current_state = "SURVEY_POI";
								// ensure correct behaviour
								finished_surveying = true;
								timer_glance_cur = -1; // turn this timer off. by default it is activated in nev's create event, and causes the glance to occur which resets the return_path_x,y values
							}
						}
						#endregion
					}
				}
					
				// increment sh_rect_offset for pulsate effect
				sh_rect_offset += sh_rect_rate;
				
				// link sh_alpha to timer progression
				sh_alpha = timer_super_haunt_cur/timer_super_haunt_max;
			}
			#endregion
		}
		
		#region handle WIN condition(s)
		if (global.total_buildings_purchased == global.total_buildings_available) {
			show_message("YOU WON! Nev's fate is sealed...");
			game_restart();
		}
		#endregion
		
		#region handle LOSE condition(s)
		// if the player has run out of HP and
		// theres no more ways for the player to get HP
		// or theres no way the player could possibly earn HP
		/*
		and if player does not own any world objects
		(global.total_wo_unlocked <= 0)
		and if player does not own any scary objects
		(global.total_so_unlocked <= 0)
		and if there are no possessed npcs
		(global.active_haunts <= 0)
		*/
		//if (global.haunt_points <= 0) {
		if (global.haunt_points <= 0) and
		(global.active_haunts <= 0) and
		(global.total_so_unlocked <= 0) and
		(global.total_wo_unlocked <= 0) {
			show_message("YOU LOSE! Nev has bested you. Try again.");
			game_restart();
			// could give player the option to continue regardless,
			// kinda like choosing to go bankrupt or not in Monopoly
		}
		#endregion
		
		#region handle unlocking new areas (commented)
		//switch (areas_unlocked) {
		//	case 1: {
		//		if (global.total_buildings_purchased >= 5) and (areas_unlocked != 2) {
		//			areas_unlocked = 2;
		//			global.total_buildings_available = 11;
		//			if (instance_exists(obj_area_cloud_2)) {
		//				obj_area_cloud_2.fade_active = true;
		//			}
		//		}
		//	} break;
		//	case 2: {
		//		if (global.total_buildings_purchased >= 11) and (areas_unlocked != 3) {
		//			areas_unlocked = 3;
		//			global.total_buildings_available = 24;
		//			if (instance_exists(obj_area_cloud_3)) {
		//				obj_area_cloud_3.fade_active = true;
		//			}
		//		}
		//	} break;
		//}
		#endregion
	} break;
}