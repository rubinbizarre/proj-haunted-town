switch (room) {
	case rm_title: {
		//var _x = 320;//room_width/2;
		//var _y = 180;//room_height/2;
		//var _btn_id = 0;
		//for (var i = 0; i < 2; i++) {
		//	with instance_create_layer(_x, _y, "Instances", obj_btn_blank) {
		//		btn_id = _btn_id;
		//	}
		//	_btn_id++;
		//	_y += 20;
		//	show_debug_message("obj_master ROOM_START: created obj_btn_blank "+string(_btn_id));
		//}
	} break;
	case rm_main: {
		// assign node_id var to each obj_node_circuit inst
		for (var i = 0; i < instance_number(obj_node_circuit); i++) {
			var _inst = instance_find(obj_node_circuit, i);
			_inst.node_id = i;
		}
	} break;
}