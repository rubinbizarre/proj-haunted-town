//if (mouse_check_button_pressed(mb_left)) {
//    click_handled = false;
    
    //// sort GUI elements by depth (lower depth = drawn on top)
    //array_sort(gui_elements, function(a, b) {
    //    return a.depth - b.depth;
    //});
    
    //// check each element in order
    //for (var i = 0; i < array_length(gui_elements); i++) {
    //    var element = gui_elements[i];
    //    if (instance_exists(element)) {
    //        // call the element's click check method
	//        if (element.visible and element.check_gui_click()) {
	//            click_handled = true;
	//			show_debug_message("obj_gui_manager STEP: click handled! "+string(element.id));
	//            break; // stop checking other elements
	//        }
    //    } else {
	//		// Clean up dead references
    //        array_delete(gui_elements, i, 1);
    //        i--; // Adjust index since we removed an element
	//	}
    //}
//}

// makes me think that the manually drawn gui elements in obj_master (x2 btn, podcast tab btn)
// need to be changed into actual objects so that they can be grouped with all other instances,
// sorted by depth and then checked in order via for loop