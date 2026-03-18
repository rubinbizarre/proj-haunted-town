// ── background ────────────────────────────────────────────────────────
draw_set_alpha(config.bg_alpha);
draw_set_colour(config.bg_colour);
if (config.corner_radius > 0)
    draw_roundrect_ext(config.xpos, config.ypos, config.xpos + config.width, config.ypos + config.height, config.corner_radius, config.corner_radius, false);
else
    draw_rectangle(config.xpos, config.ypos, config.xpos + config.width, config.ypos + config.height, false);

// ── border ────────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_colour(config.border_colour);
if (config.corner_radius > 0)
    draw_roundrect_ext(config.xpos, config.ypos, config.xpos + config.width, config.ypos + config.height, config.corner_radius, config.corner_radius, true);
else
    draw_rectangle(config.xpos, config.ypos, config.xpos + config.width, config.ypos + config.height, true);

// ── scissor clip ──────────────────────────────────────────────────────
gpu_set_scissor(_inner_x, _inner_y, _inner_w, _inner_h);

draw_set_font(config.font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ── draw rows ─────────────────────────────────────────────────────────
var _cursor_y = _inner_y - scroll_offset;

for (var i = 0; i < array_length(built_rows); i++) {
    var _br = built_rows[i];

    // skip rows fully above the clip area
    if (_cursor_y + _br.height < _inner_y) {
        _cursor_y += _br.height;
        continue;
    }
    // stop once we're fully below
    if (_cursor_y > _inner_y + _inner_h) break;

    if (_br.type == "separator") {
        // draw a full-width dashed separator line
        draw_set_colour(make_colour_rgb(90, 80, 110));
        draw_set_alpha(0.6);
        var _sep_y = _cursor_y + config.line_height * 0.5;
        var _dash_w = config.char_width * 2;
        var _gap_w  = config.char_width;
        var _dx     = _inner_x;
        while (_dx < _inner_x + _inner_w) {
            draw_rectangle(_dx, _sep_y, min(_dx + _dash_w, _inner_x + _inner_w), _sep_y + 1, false);
            _dx += _dash_w + _gap_w;
        }
        draw_set_alpha(1);

    } else if (_br.type == "spacer") {
        // intentionally empty — just advances _cursor_y

    } else {
        // header, event, stat — draw each column's wrapped lines
        var _col = config.text_colour;

        // tint sub change column: green for gain, red for loss
        for (var line = 0; line < array_length(_br.lines1); line++) {
            draw_set_colour(_col);
            draw_text(_inner_x + 0,       _cursor_y + line * config.line_height, _br.lines1[line]);
        }
        for (var line = 0; line < array_length(_br.lines2); line++) {
            // colour the sub change value by sign
            var _col2 = _col;
            if (_br.type == "event") {
                var _val_str = _br.lines2[0];
                if (string_char_at(_val_str, 1) == "+") _col2 = make_colour_rgb(100, 220, 130);
                if (string_char_at(_val_str, 1) == "-") _col2 = make_colour_rgb(220, 90, 90);
            }
            draw_set_colour(_col2);
            draw_text(_inner_x + _col2_x, _cursor_y + line * config.line_height, _br.lines2[line]);
        }
        for (var line = 0; line < array_length(_br.lines3); line++) {
            draw_set_colour(_col);
            draw_text(_inner_x + _col3_x, _cursor_y + line * config.line_height, _br.lines3[line]);
        }
    }

    _cursor_y += _br.height;
}

// ── clear scissor ─────────────────────────────────────────────────────
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

// ── scrollbar track ───────────────────────────────────────────────────
var _sb_x = config.xpos + config.width - config.scrollbar_width - config.border_width;
var _sb_y = config.ypos + config.border_width;
var _sb_h = config.height - config.border_width * 2;
var _max_scroll  = max(0, total_height - _inner_h);
var _thumb_ratio = clamp(_inner_h / max(total_height, 1), 0, 1);
var _thumb_h     = max(_thumb_ratio * _sb_h, config.scrollbar_min_thumb);
var _thumb_y     = _sb_y + (_max_scroll > 0 ? (scroll_offset / _max_scroll) * (_sb_h - _thumb_h) : 0);

draw_set_colour(config.scrollbar_bg);
draw_rectangle(_sb_x, _sb_y, _sb_x + config.scrollbar_width, _sb_y + _sb_h, false);

if (total_height > _inner_h) {
    draw_set_colour((scroll_hover || scroll_dragging) ? config.scrollbar_thumb_hover : config.scrollbar_thumb);
    draw_roundrect_ext(_sb_x + 2, _thumb_y, _sb_x + config.scrollbar_width - 2, _thumb_y + _thumb_h, 4, 4, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(global.font_default);