//if (global.paused && array_length(stack) > 0) {
//    ui_register("pause_block", 0, 0, display_get_gui_width(), display_get_gui_height(), UI_Z_PAUSE_BLOCK);
//    var _n = array_length(stack[array_length(stack)-1].items);
//    for (var i = 0; i < _n; i++)
//        ui_register("pause_item_" + string(i), 60, 300 + i * 56, 460, 300 + i * 56 + 48, UI_Z_PAUSE_ITEM);
//}
if (global.paused && array_length(stack) > 0) {
    ui_register("pause_block", 0, 0, display_get_gui_width(), display_get_gui_height(), UI_Z_PAUSE_BLOCK);
    var item_count = array_length(stack[array_length(stack) - 1].items);
    for (var item_index = 0; item_index < item_count; item_index++) {
        var row_top_y = list_top_y + item_index * item_spacing;
        ui_register("pause_item_" + string(item_index),
                    list_left_x, row_top_y, list_right_x, row_top_y + item_height,
                    UI_Z_PAUSE_ITEM);
    }
}