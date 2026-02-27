sub_count = 0; // nev's actual sub count (realtime)

sub_gain_amount = 1000;
sub_loss_amount = sub_gain_amount/2;

daily_sub_bonus = 100; // subs gained per day regardless of events
daily_sub_gain = 0; // total subs gained in a day
daily_sub_loss = 0; // total subs lost in a day

/* this would probably belong in a function pertaining to gaining subs
switch (obj_nev.gear_tier) {
	case 0: sub_gain_amount = 1000;	break; // camera
	case 1: sub_gain_amount = 10000; break; // vcr videocam
	case 2: sub_gain_amount = 50000; break; // pro tv cam
	case 3: sub_gain_amount = 100000; break; // emf monitor
	case 4: sub_gain_amount = 100000; break; // poltergust: needs playtesting
	default: show_debug_message("obj_manager_nev CREATE: gear_tier value not recognised: "+string(obj_nev.gear_tier));
}
*/