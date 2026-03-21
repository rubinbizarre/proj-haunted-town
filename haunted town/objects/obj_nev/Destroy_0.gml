if (gear != noone) {
	if (instance_exists(gear)) instance_destroy(gear);
}

if (ps_subs != noone) {
	if (instance_exists(ps_subs)) instance_destroy(ps_subs);
}