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
		
		if (instance_exists(obj_camera)) {
			instance_destroy(obj_camera);
		}
		if (instance_exists(obj_manager_time)) {
			instance_destroy(obj_manager_time);
		}
	} break;
	case rm_main: {
		// assign node_id var to each obj_node_circuit inst
		for (var i = 0; i < instance_number(obj_node_circuit); i++) {
			var _inst = instance_find(obj_node_circuit, i);
			_inst.node_id = i;
		}
		
		// assign node_id var to each obj_node_nev_van inst
		for (var i = 0; i < instance_number(obj_node_road); i++) {
			var _inst = instance_find(obj_node_road, i);
			_inst.node_id = i;
		}
		
		// assign building_index, interior_x vars to each building inst
		for (var i = 0; i < instance_number(obj_par_building); i++) {
			var _inst = instance_find(obj_par_building, i);
			_inst.building_index = i;
			_inst.interior_x = 20000 + (i * 2000);
			_inst.interior_obj = instance_create_layer(
				_inst.interior_x + (_inst.interior_width/2),
				_inst.interior_y + 90,
				"Collision",
				obj_interior
			) {
				depth = _inst.depth - 1;
			}
			_inst.spawn_scary_objects();
			//show_debug_message("obj_master ROOM_START: assigned building "+string(_inst.id)+" with building_index "+string(i)+". its interior_x: "+string(_inst.interior_x));
		}
		
		//show_message(string(depth));
	} break;
}