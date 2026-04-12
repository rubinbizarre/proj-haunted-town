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
				"Interiors",
				obj_interior
			) {
				depth = _inst.depth - 1;
			}
			//show_message("obj_master room_start: _inst.interior_obj:"+string(_inst.interior_obj));
			
			// choose interior sprite depending on building sprite
			var _interior_obj = _inst.interior_obj;
			switch (_inst.sprite_index) {
				case spr_building_0_shack: _interior_obj.sprite_index = spr_interior_0_shack; break;
				case spr_building_1_house: _interior_obj.sprite_index = spr_interior_1_house; break;
				case spr_building_2_manor: _interior_obj.sprite_index = spr_interior_2_manor; break;
				case spr_building_church: _interior_obj.sprite_index = spr_interior_church; break;
				case spr_building_hotel: _interior_obj.sprite_index = spr_interior_hotel; break;
				default: _interior_obj.sprite_index = spr_interior_0_shack; break;
			}
			
			_inst.spawn_scary_objects();
			//show_debug_message("obj_master ROOM_START: assigned building "+string(_inst.id)+" with building_index "+string(i)+". its interior_x: "+string(_inst.interior_x));
		}
		
		global.summary_box = instance_create_layer(0, 0, "Master", obj_summary_box);
		
		#region create possess/kill npc buttons (commented - moved to obj_par_npc step)
		////var _x = ...
		////var _y = ...
		//var _btn_possess = instance_create_layer(903, 312, "Master", obj_btn_npc_options);
		//var _btn_kill = instance_create_layer(929, 312, "Master", obj_btn_npc_options);
		//_btn_possess.btn_kill = _btn_kill;
		////_btn_possess.npc = ...
		//_btn_possess.sprite_index = spr_btn_npc_possess;
		//_btn_kill.btn_possess = _btn_possess;
		////_btn_kill.npc = ...
		//_btn_kill.sprite_index = spr_btn_npc_kill;
		#endregion
		
		//show_message(string(depth));
	} break;
}