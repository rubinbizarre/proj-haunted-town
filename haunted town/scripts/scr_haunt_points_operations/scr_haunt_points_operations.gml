function add_haunt_points(hp = 1) {
	//// add to haunt points wallet
	//global.haunt_points += hp;
	
	var _threshold = global.super_haunt_threshold[global.super_haunt_threshold_index];
	// check to see whether hp earned will go over the current threshold
	if ((global.haunt_points + hp) > _threshold) {
		// cap earnings to super haunt threshold
		global.haunt_points = _threshold;
	} else {
		// add to haunt points wallet
		global.haunt_points += hp;
	}
	
	//// increment lifetime hp ONLY if super-haunt is not available
	//if (!global.super_haunt_ready) {
	//	global.lifetime_haunt_points += hp;
	//	show_message("incremented lifetime HP");
	//}
	
	// add to lifetime hp counter
	// check to see whether hp earned will go over the current threshold
	if ((global.lifetime_haunt_points + hp) > _threshold) {
		// cap earnings to super haunt threshold
		global.lifetime_haunt_points = _threshold;
	} else {
		// add to haunt points wallet
		global.lifetime_haunt_points += hp;
	}
	
	// check to see if eligible for SUPER HAUNT
	// lifetime hp should not be more than threshold
	if (global.lifetime_haunt_points >= _threshold) {
		global.super_haunt_ready = true;
	}
}

function lose_haunt_points(hp = 1) {
	// remove amount from hp wallet
	global.haunt_points -= hp;
}