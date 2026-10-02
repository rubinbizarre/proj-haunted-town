//if (blend <= 0 || array_length(stack) == 0) exit;
//var ease = blend * blend * (3 - 2 * blend);
//var items = stack[array_length(stack)-1].items;
//var n = array_length(items);

//// selection bar that glides between items
//draw_set_alpha(0.25 * ease);
//draw_set_colour(make_colour_rgb(150, 90, 210));   // purple haunt accent
//draw_rectangle(60, sel_y, 460, sel_y + 48, false);
//draw_set_alpha(1);
//draw_set_font(font_main_body);

//for (var i = 0; i < n; i++) {
//    var it = items[i];
//    var t  = clamp(ease * 1.8 - i * 0.12, 0, 1); // stagger
//    var xx = lerp(-300, 80, t * t * (3 - 2 * t)) + it.hover * 14;
//    var yy = 300 + i * 56;
//    draw_set_alpha(t);
//    draw_set_colour(merge_colour(c_gray, c_white, it.hover));
//    draw_text_transformed(xx, yy + 8, it.label, 1 + it.hover * 0.08, 1 + it.hover * 0.08, 0);

//    if (it.type == 1) {              // slider
//        draw_rectangle(xx + 180, yy + 20, xx + 380, yy + 24, false);
//        draw_circle(xx + 180 + it.get() * 200, yy + 22, 6, false);
//    } else if (it.type == 2) {       // cycle
//        draw_text(xx + 180, yy + 8, "< " + it.options[it.get()] + " >");
//    }
//}

//draw_set_alpha(1);
//draw_set_colour(c_white);
//draw_set_font(global.font_default);

// ============================================================
// obj_pause_menu : Draw GUI
// Draws the sliding pause/settings menu on top of the blurred world.
// ============================================================

// Nothing to draw if the menu is fully faded out or has no menu open
if (blend <= 0 || array_length(stack) == 0) exit;

// vars specific to Draw GUI
var hover_nudge_px     = 10;    // how far a hovered item shifts right
var hover_scale_boost  = 0.08;  // how much a hovered item's text grows (8%)
var stagger_delay      = 0.12;  // delay between each item's slide-in, in menu progress units
var stagger_speed      = 1.8;   // how fast each item's slide completes relative to menu progress

// --- Menu open/close progress ---
var menu_progress = blend * blend * (3 - 2 * blend);

// --- The currently open menu (top of the menu stack) ---
var current_menu_items = stack[array_length(stack) - 1].items;
var item_count         = array_length(current_menu_items);

// --- Highlight bar behind the selected item ---
// `sel_y` is eased toward the selected item in Step, so the bar glides between items
draw_set_alpha(0.25 * menu_progress);                 // fades in with the menu
draw_set_colour(make_colour_rgb(150, 90, 210));       // purple haunt accent
draw_rectangle(list_left_x, sel_y, list_right_x, sel_y + item_height, false);
draw_set_alpha(1);

draw_set_font(font_main_body);

// --- Draw each menu item ---
for (var item_index = 0; item_index < item_count; item_index++) {
    var item = current_menu_items[item_index];

    // How far through its own slide-in this item is (0..1).
    // Later items start later, which creates the staggered cascade.
    var slide_in_progress = clamp(menu_progress * stagger_speed - item_index * stagger_delay, 0, 1);

    // Smoothstep again so each item eases into place
    var slide_in_eased = slide_in_progress * slide_in_progress * (3 - 2 * slide_in_progress);

    // Slide from off-screen left to resting position, plus a rightward nudge when hovered.
	var item_slide_x = lerp(text_offscreen_x, text_rest_x, slide_in_eased);   // slide-in only
	var label_x      = item_slide_x + item.hover * hover_nudge_px;            // label gets the hover nudge
	var control_x    = item_slide_x + control_offset_x;                       // controls stay put when hovered
	var item_y       = list_top_y + item_index * item_spacing;

    // Items fade in as they slide; unselected items are grey, selected ones brighten to white
    draw_set_alpha(slide_in_progress);
    draw_set_colour(merge_colour(c_gray, c_white, item.hover));

    // Label, slightly enlarged while hovered
    var label_scale = 1 + item.hover * hover_scale_boost;
    draw_text_transformed(label_x, item_y + 8, item.label, label_scale, label_scale, 0);

    // --- Extra control to the right of the label, depending on item type ---
	draw_set_colour(merge_colour(c_gray, c_ltgray, item.hover));
	var slider_y1 = item_y + 30;//20;
	var slider_y2 = slider_y1 + 4;
	var slider_dot_y = slider_y1 + 2;
	if (item.type == 1) {
	    var slider_right_x = control_x + slider_track_width;
	    var handle_x       = control_x + item.get() * slider_track_width;
	    draw_rectangle(control_x, slider_y1, slider_right_x, slider_y2, false);
	    draw_circle(handle_x, slider_dot_y, 6, false);
	} else if (item.type == 2) {
	    draw_text(control_x, item_y + 8, "< " + item.options[item.get()] + " >");
	}
}

//draw_text(500, 500, "blend: "+string(blend));

// --- Restore draw state so we don't affect other GUI drawing ---
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_font(global.font_default);