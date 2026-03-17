global.subs = 0; // nev's actual sub count (realtime)
global.daily_sub_gain_event_counter = 0;
global.daily_sub_loss_event_counter = 0;

global.nev_detect_radius = 200;
global.nev_todo_queue = [];
global.nev_current_target = noone;

sub_gain_amount = 1000;
sub_loss_amount = sub_gain_amount/2;

daily_sub_bonus = 100; // subs gained per day regardless of events
daily_sub_gain = 0; // total subs gained in the day
daily_sub_loss = 0; // total subs lost in the day

/*
// this would probably belong in a function pertaining to gaining subs
switch (obj_nev.gear_tier) {
	case 0: sub_gain_amount = 1000;	break; // camera
	case 1: sub_gain_amount = 10000; break; // vcr videocam
	case 2: sub_gain_amount = 50000; break; // pro tv cam
	case 3: sub_gain_amount = 100000; break; // emf monitor
	case 4: sub_gain_amount = 100000; break; // poltergust: needs playtesting
	default: show_debug_message("obj_manager_nev CREATE: gear_tier value not recognised: "+string(obj_nev.gear_tier));
}
*/

function gain_subs() {
	var _gain_amount = 0;
	switch (obj_nev.gear_tier) {
		case 0: _gain_amount = 1000; break; // camera
		case 1: _gain_amount = 10000; break; // vcr videocam
		case 2: _gain_amount = 50000; break; // pro tv cam
		case 3: _gain_amount = 100000; break; // emf monitor
		case 4: _gain_amount = 100000; break; // poltergust: needs playtesting
		default: {
			show_debug_message("obj_manager_nev CREATE: gear_tier value not recognised: "+string(obj_nev.gear_tier));
		} break;
	}
	global.subs += _gain_amount;
}