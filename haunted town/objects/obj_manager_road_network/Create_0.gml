global.intersections = [];

function map_road_network() {
    with (obj_node_road) {
        connections = []; // Reset connections
        
        var _me = id;
        var _nearest_up = noone, _dist_up = infinity;
        var _nearest_down = noone, _dist_down = infinity;
        var _nearest_left = noone, _dist_left = infinity;
        var _nearest_right = noone, _dist_right = infinity;

        with (obj_node_road) {
            if (id == _me) continue; // don't check yourself (as in, this obj_node_road inst)

            var _dist = point_distance(_me.x, _me.y, x, y);

            // 1. check vertical alignment (same X)
            if (x == _me.x) {
                if (y < _me.y && _dist < _dist_up) { _nearest_up = id; _dist_up = _dist; }
                if (y > _me.y && _dist < _dist_down) { _nearest_down = id; _dist_down = _dist; }
            }

            // 2. check horizontal alignment (same Y)
            if (y == _me.y) {
                if (x < _me.x && _dist < _dist_left) { _nearest_left = id; _dist_left = _dist; }
                if (x > _me.x && _dist < _dist_right) { _nearest_right = id; _dist_right = _dist; }
            }
        }

        // 3. final verification: can we actually see these neighbors?
        var _candidates = [_nearest_up, _nearest_down, _nearest_left, _nearest_right];
        for (var i = 0; i < 4; i++) {
            var _target = _candidates[i];
            if (_target != noone) {
                // check if a building is blocking the road between these two nodes
                if (!collision_line(_me.x, _me.y, _target.x, _target.y, obj_par_building, false, true)) {
                    array_push(_me.connections, _target);
					//show_debug_message("obj_manager_road_network ROOM_START: pushed a connection to node "+string(_me.node_id)+": "+string(_target.node_id));
                }
            }
        }
		
		//if (is_intersection) {
		//	array_push(global.intersections, id);
		//	show_debug_message("pushed "+string(id)+"to global.intersections[]");
		//}
		//global.intersections = [];
		
    }
	
	//var _total_nodes = instance_number(obj_node_road);
	//show_debug_message("--- NODE DIAGNOSTIC START ---");
	//show_debug_message("Total obj_node_road found in room: " + string(_total_nodes));

	//with (obj_node_road) {
	//	// Check if the variable even exists on this specific instance
	//	if (variable_instance_exists(id, "is_intersection")) {
	//	    var _val = is_intersection;
	//	    show_debug_message("Node " + string(id) + " at (" + string(x) + "," + string(y) + ") has is_intersection = " + string(_val));
        
	//	    if (_val == true) {
	//	        array_push(global.intersections, id);
	//	    }
	//	} else {
	//	    show_debug_message("Node " + string(id) + " DOES NOT HAVE the variable is_intersection at all!");
	//	}
	//}

	//show_debug_message("Total intersections pushed to array: " + string(array_length(global.intersections)));
	//show_debug_message("--- NODE DIAGNOSTIC END ---");
}