map_road_network();

//// establish which road nodes are marked as intersections (for random van destinations)
//with (obj_node_road) {
//    if (is_intersection) {
//		array_push(global.intersections, id);
//		show_debug_message("pushed "+string(id)+"to global.intersections[]");
//	}
//}