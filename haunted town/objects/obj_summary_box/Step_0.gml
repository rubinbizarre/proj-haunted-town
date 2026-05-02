//var _gui_w = display_get_gui_width();
//var _gui_h = display_get_gui_height();
//var _w = _gui_w * 0.96;//_gui_w - 80;
//var _h = _gui_h * 0.37;//400;
//config.xpos = (_gui_w/2) - (_w/2);
//config.ypos = (_gui_h/2) - (_h/2);
//_inner_x = config.xpos + config.padding;
//_inner_y = config.ypos + config.padding;
//_inner_w = config.width - config.padding * 2 - config.scrollbar_width - 4;
//_inner_h = config.height - config.padding * 2;

// ── derived geometry ──────────────────────────────────────────────────
var _sb_x = config.xpos + config.width - config.scrollbar_width - config.border_width;
var _sb_y = config.ypos + config.border_width;
var _sb_h = config.height - config.border_width * 2;
var _max_scroll  = max(0, total_height - _inner_h);
var _thumb_ratio = clamp(_inner_h / max(total_height, 1), 0, 1);
var _thumb_h     = max(_thumb_ratio * _sb_h, config.scrollbar_min_thumb);
var _thumb_y     = _sb_y + (_max_scroll > 0 ? (scroll_offset / _max_scroll) * (_sb_h - _thumb_h) : 0);

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// ── hover ─────────────────────────────────────────────────────────────
scroll_hover = point_in_rectangle(_mx, _my, _sb_x, _thumb_y, _sb_x + config.scrollbar_width, _thumb_y + _thumb_h);

// ── drag ──────────────────────────────────────────────────────────────
if (mouse_check_button_pressed(mb_left) && scroll_hover) {
    scroll_dragging          = true;
    scroll_drag_start_y      = _my;
    scroll_drag_start_offset = scroll_offset;
}
if (scroll_dragging) {
    if (mouse_check_button(mb_left)) {
        var _drag_delta  = _my - scroll_drag_start_y;
        var _scroll_range = _sb_h - _thumb_h;
        if (_scroll_range > 0)
            scroll_offset = clamp(scroll_drag_start_offset + (_drag_delta / _scroll_range) * _max_scroll, 0, _max_scroll);
    } else {
        scroll_dragging = false;
    }
}

// ── mouse wheel ───────────────────────────────────────────────────────
if (point_in_rectangle(_mx, _my, config.xpos, config.ypos, config.xpos + config.width, config.ypos + config.height)) {
    var _wheel = mouse_wheel_down() - mouse_wheel_up();
    scroll_offset = clamp(scroll_offset + _wheel * config.line_height, 0, _max_scroll);
}

