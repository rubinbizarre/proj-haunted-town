switch (room) {
	case rm_main: {
		for (var i = 0; i < instance_number(obj_node_circuit); i++) {
			var _inst = instance_find(obj_node_circuit, i);
			_inst.node_id = i;
			//_inst.visible = true;
		}
	} break;
}