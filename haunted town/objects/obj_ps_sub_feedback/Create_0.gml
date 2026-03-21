part_sys_gain = part_system_create(ps_subs_gain);
part_sys_loss = part_system_create(ps_subs_loss);

// Get system info (only once)
var info_gain = part_system_get_info(part_sys_gain);
var info_loss = part_system_get_info(part_sys_loss);

//var _readable = json_stringify(info, true);
//show_message(_readable);

// Store emitter + parttype
em_gain = info_gain.emitters[0].ind;               // this is @ref particle_emitter(0)
pt_gain = info_gain.emitters[0].parttype.ind;      // this is @ref particle_type(3)

em_loss = info_loss.emitters[0].ind;               // this is @ref particle_emitter(0)
pt_loss = info_loss.emitters[0].parttype.ind;

// Set initial position
part_system_position(part_sys_gain, 0, 0);
part_system_position(part_sys_loss, 0, 0);

// Start disabled (0 particles per step)
part_emitter_stream(part_sys_gain, em_gain, pt_gain, 0);
part_emitter_stream(part_sys_loss, em_loss, pt_loss, 0);

// start emitting
function start_gain() {
	part_emitter_stream(part_sys_gain, em_gain, pt_gain, 1);
}
function start_loss() {
	part_emitter_stream(part_sys_loss, em_loss, pt_loss, 1);
}

// stop emitting
function stop() {
    part_emitter_stream(part_sys_gain, em_gain, pt_gain, 0);
	part_emitter_stream(part_sys_loss, em_loss, pt_loss, 0);
}
