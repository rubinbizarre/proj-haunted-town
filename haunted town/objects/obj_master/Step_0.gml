switch (room) {
	case rm_main: {
		#region handle input whilst haunting a house (whilst haunt menu is active)
		if (global.menu_haunt_active) {
			global.haunt_difficulty = global.offered_haunt_points / (global.offered_haunt_points + global.tracked_building.stats.haunt_requirement);
	
			// decrement offered HP. no less than zero
			if (keyboard_check_pressed(vk_down)) {
				if (global.offered_haunt_points > 0) {
					global.offered_haunt_points -= 1;
					//show_debug_message("obj_master STEP: decremented offered HP");
				}
			}
			// increment offered HP. cap to amount of HP owned
			if (keyboard_check_pressed(vk_up)) {
				if (global.offered_haunt_points < global.haunt_points) {
					global.offered_haunt_points += 1;
					//show_debug_message("obj_master STEP: incremented offered HP");
				}
			}
	
			// confirm input
			if (keyboard_check_pressed(vk_enter)) {
				// validate input:
				// proceed: player entered at least minimum amount HP required
				if (global.offered_haunt_points >= global.tracked_building.stats.haunt_requirement) {
					// start haunt process
					if (instance_exists(obj_skillcheck)) {
						obj_skillcheck.trigger();
					}
				} else { // abort: player did not enter the minimum amount of HP required
					show_message("HAUNT ABORTED\nYou need to spend at least "+string(global.tracked_building.stats.haunt_requirement)+" Haunt Points to Haunt this building.");
					abort_haunt_process();
				}
			}
		}
		#endregion
	
		#region handle pause activation/deactivation
		if (keyboard_check_pressed(ord("P"))) {
			custom_pause();
		}
		#endregion
	} break;
}