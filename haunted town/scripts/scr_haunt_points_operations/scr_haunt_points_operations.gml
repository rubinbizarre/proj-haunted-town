function add_haunt_points(hp = 1) {
	global.haunt_points += hp;
	// also increment lifetime counter ONLY IF super-haunt is not available or active
	if (!global.super_haunt_ready) {
		global.lifetime_haunt_points += hp;
	}
	// check to see if eligible for SUPER HAUNT
	if (global.lifetime_haunt_points == 10) {
		global.super_haunt_ready = true;
	}
}