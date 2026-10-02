var dt = delta_time / 1000000;        // real time on purpose

// toggle
if (keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_start)) {
    if (!global.paused) { global.paused = true; stack = []; menu_push(menu_main); }
    else if (array_length(stack) > 1) menu_pop();
    else global.paused = false;
}

// eased transition drives visuals AND world time
blend = lerp(blend, global.paused ? 1 : 0, 1 - exp(-10 * dt));
if (abs(blend - global.paused) < 0.005) blend = global.paused;
global.pause_scale = 1 - blend;

// control pause muffle
global.fx_music_lpf.cutoff = 20000 * power(700 / 20000, blend);

if (blend <= 0) exit;

if (global.paused && array_length(stack) > 0) {
    var top   = stack[array_length(stack)-1];
    var items = top.items;
    var n     = array_length(items);

    var nav_v = (keyboard_check_pressed(vk_down) || gamepad_button_check_pressed(0, gp_padd))
              - (keyboard_check_pressed(vk_up)   || gamepad_button_check_pressed(0, gp_padu));
    var nav_h = (keyboard_check_pressed(vk_right) || gamepad_button_check_pressed(0, gp_padr))
              - (keyboard_check_pressed(vk_left)  || gamepad_button_check_pressed(0, gp_padl));
    var confirm = keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0, gp_face1);

    if (nav_v != 0) { sel = (sel + nav_v + n) mod n; }

    // mouse hover, using your existing GUI-space helpers
    var mx = cursor_gui_x(), my = cursor_gui_y();
    //if (!global.using_gamepad_cursor) {
    //    for (var i = 0; i < n; i++) {
    //        var iy = 300 + i * 56;
    //        if (mx > 60 && mx < 460 && my > iy && my < iy + 48) { sel = i; break; }
    //    }
    //}
	//var mouse_over = false;
	//if (!global.using_gamepad_cursor) {
	//    for (var i = 0; i < n; i++) {
	//        var iy = 300 + i * 56;
	//        if (mx > 60 && mx < 460 && my > iy && my < iy + 48) { sel = i; mouse_over = true; break; }
	//    }
	//}
	var mouse_over = false;
	if (!global.using_gamepad_cursor) {
	    for (var i = 0; i < n; i++) {
	        if (ui_is_hot("pause_item_" + string(i))) { sel = i; mouse_over = true; break; }
	    }
	}
    top.sel = sel;

    var it = items[sel];
    switch (it.type) {
        case 0:
            //if (confirm || mouse_check_button_pressed(mb_left)) it.fn();
			if (confirm || (mouse_over && ui_click_pressed())) it.fn();
            break;
        case 1:
            var v = it.get();
            if (nav_h != 0) it.set(clamp(v + nav_h * 0.05, 0, 1));
            //if (mouse_check_button(mb_left) && !global.using_gamepad_cursor)
			if (mouse_over && ui_click_held() && !global.using_gamepad_cursor)
                it.set(clamp((mx - 260) / 200, 0, 1));   // bar spans x 260..460
            break;
        case 2:
            var cnt = array_length(it.options);
            if (nav_h != 0) it.set((it.get() + nav_h + cnt) mod cnt);
            //if (confirm || mouse_check_button_pressed(mb_left))
			if (confirm || (mouse_over && ui_click_pressed()))
				it.set((it.get() + 1) mod cnt);
            break;
    }

    // per-item hover easing
    for (var i = 0; i < n; i++)
        items[i].hover = lerp(items[i].hover, (i == sel) ? 1 : 0, 1 - exp(-18 * dt));
    sel_y = lerp(sel_y, 300 + sel * 56, 1 - exp(-20 * dt));
}