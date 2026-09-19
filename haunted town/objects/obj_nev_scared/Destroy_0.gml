if (ps_scared != noone) {
	ps_scared.stop_sweat();
	ps_scared.stop_spirals();
	instance_destroy(ps_scared);
}