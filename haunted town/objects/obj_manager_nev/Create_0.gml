global.subs = 0; // nev's actual sub count (realtime)
global.daily_sub_gain_event_counter = 0;
global.daily_sub_loss_event_counter = 0;
global.daily_passive_growth = 50;
// initialise daily tracking arrays and counters at the start of each day
global.daily_events = []; // array of structs, one per event
global.subs_at_day_start = global.subs; // this is unused?
global.nev_gear_at_day_start = 0;

global.nev_detect_radius = 200;
global.nev_todo_queue = [];
global.nev_current_target = noone;

global.nev_gear_tier = 0;

global.nev_home = noone; // see room_start

sub_gain_amount = 1000;
sub_loss_amount = sub_gain_amount/2;

daily_sub_bonus = 100; // subs gained per day regardless of events
daily_sub_gain = 0; // total subs gained in the day
daily_sub_loss = 0; // total subs lost in the day

/*
// this would probably belong in a function pertaining to gaining subs
switch (global.nev_gear_tier) {
	case 0: sub_gain_amount = 1000;	break; // camera
	case 1: sub_gain_amount = 10000; break; // vcr videocam
	case 2: sub_gain_amount = 50000; break; // pro tv cam
	case 3: sub_gain_amount = 100000; break; // emf monitor
	case 4: sub_gain_amount = 100000; break; // ectoextractor: needs playtesting
	default: show_debug_message("obj_manager_nev CREATE: gear_tier value not recognised: "+string(global.nev_gear_tier));
}
*/

//function gain_subs() {
//	var _gain_amount = 0;
//	switch (global.nev_gear_tier) {
//		case 0: _gain_amount = 1000; break; // camera
//		case 1: _gain_amount = 10000; break; // vcr videocam
//		case 2: _gain_amount = 50000; break; // pro tv cam
//		case 3: _gain_amount = 100000; break; // emf monitor
//		case 4: _gain_amount = 100000; break; // ectoextractor: needs playtesting
//		default: {
//			show_debug_message("obj_manager_nev CREATE: gain_subs(): gear_tier value not recognised: "+string(global.nev_gear_tier));
//		} break;
//	}
//	global.subs += _gain_amount;
//	global.daily_sub_gain_event_counter++;
//}

//function lose_subs() {
//	var _loss_amount = 0;
//	switch (global.nev_gear_tier) {
//		case 0: _loss_amount = 500; break; // camera
//		case 1: _loss_amount = 5000; break; // vcr videocam
//		case 2: _loss_amount = 25000; break; // pro tv cam
//		case 3: _loss_amount = 50000; break; // emf monitor
//		case 4: _loss_amount = 50000; break; // ectoextractor: needs playtesting
//		default: {
//			show_debug_message("obj_manager_nev CREATE: lose_subs(): gear_tier value not recognised: "+string(global.nev_gear_tier));
//		} break;
//	}
//	global.subs -= _loss_amount;
//	if (global.subs < 0) global.subs = 0;
//	global.daily_sub_loss_event_counter++;
//}

function gain_subs(_object_name, _note) {
    var _gain_amount = 0;
    switch (global.nev_gear_tier) {
        case 0: _gain_amount = 1000;   break; // camera
        case 1: _gain_amount = 10000;  break; // vcr videocam
        case 2: _gain_amount = 50000;  break; // pro tv cam
        case 3: _gain_amount = 100000; break; // emf monitor
        case 4: _gain_amount = 100000; break; // ectoextractor: needs playtesting
        default: {
            show_debug_message("gain_subs(): gear_tier not recognised: " + string(global.nev_gear_tier));
        } break;
    }
    global.subs += _gain_amount;
    global.daily_sub_gain_event_counter++;

    // log the event for the end-of-day summary
    array_push(global.daily_events, {
        //label      : "Recorded Event: " + _object_name,
		label      : "CREDIT: " + _object_name,
        sub_change : _gain_amount,
        note       : _note, //"insert note here",    // optionally pass a note as a second argument
        //confirmed  : true,
    });
	
	var _ps = obj_nev.ps_subs;
	if (_ps != noone) _ps.start_gain();
	obj_podcast_box.activate_rings_notif();
}

function lose_subs(_object_name, _note) {
    var _loss_amount = 0;
    switch (global.nev_gear_tier) {
        case 0: _loss_amount = 500;   break; // camera
        case 1: _loss_amount = 5000;  break; // vcr videocam
        case 2: _loss_amount = 25000; break; // pro tv cam
        case 3: _loss_amount = 50000; break; // emf monitor
        case 4: _loss_amount = 50000; break; // ectoextractor: needs playtesting
        default: {
            show_debug_message("lose_subs(): gear_tier not recognised: " + string(global.nev_gear_tier));
        } break;
    }
    global.subs -= _loss_amount;
    if (global.subs < 0) global.subs = 0;
    global.daily_sub_loss_event_counter++;

    // log the event — label mirrors the screenshot's "Discredited:" prefix
    array_push(global.daily_events, {
        label      : "DISCREDIT: " + _object_name,
        sub_change : -_loss_amount,
        note       : _note, //"insert note here",
        //confirmed  : false,
    });
	
	var _ps = obj_nev.ps_subs;
	if (_ps != noone) _ps.start_loss();
	obj_podcast_box.activate_rings_notif();
}