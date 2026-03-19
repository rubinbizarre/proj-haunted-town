// ── config ────────────────────────────────────────────────────────────

var _w = room_width - 80;
var _h = 400;

config = {
    width  : _w,
    height : _h,
	xpos   : (room_width/2) - (_w/2),
    ypos   : (room_height/2) - (_h/2),

    // appearance
    bg_colour          : make_colour_rgb(18, 16, 24),
    bg_alpha           : 1.0,
    border_colour      : make_colour_rgb(90, 80, 110),
    border_width       : 4,
    corner_radius      : 24,
    padding            : 18,

    // text
    font               : font_main_body,
    text_colour        : make_colour_rgb(220, 215, 230),
    char_width         : 21,      // pixel width of one monospace character
    line_height        : 36,      // px between lines

    // column widths in characters — adjust to taste
    col1_chars         : 16,      // event label column
    col2_chars         : 16,      // sub change column
    // col3 fills the remaining space automatically

    // scrollbar
    scrollbar_width    : 24,
    scrollbar_bg       : make_colour_rgb(35, 30, 45),
    scrollbar_thumb    : make_colour_rgb(110, 95, 140),
    scrollbar_thumb_hover : make_colour_rgb(160, 140, 200),
    scrollbar_min_thumb : 20,
};

// ── internal state ────────────────────────────────────────────────────
rows          = [];       // array of row structs from build_summary_rows()
built_rows    = [];       // processed rows with pre-wrapped lines
total_height  = 0;
scroll_offset = 0;
scroll_dragging   = false;
scroll_drag_start_y      = 0;
scroll_drag_start_offset = 0;
scroll_hover  = false;

// ── derived geometry ──────────────────────────────────────────────────
_inner_x = config.xpos + config.padding;
_inner_y = config.ypos + config.padding;
_inner_w = config.width - config.padding * 2 - config.scrollbar_width - 4;
_inner_h = config.height - config.padding * 2;

// column x positions (in pixels from _inner_x)
_col2_x  = 0; // set in rebuild() once char_width is confirmed
_col3_x  = 0;
_col3_w  = 0;

/// wraps a string into an array of lines that fit within _max_chars characters
function wrap_text(_str, _max_chars) {
    var _words   = string_split(_str, " ");
    var _lines   = [];
    var _current = "";
    for (var i = 0; i < array_length(_words); i++) {
        var _word = _words[i];
        var _test = (_current == "") ? _word : _current + " " + _word;
        if (string_length(_test) > _max_chars) {
            array_push(_lines, _current);
            _current = _word;
        } else {
            _current = _test;
        }
    }
    if (_current != "") array_push(_lines, _current);
    if (array_length(_lines) == 0) array_push(_lines, "");
    return _lines;
}

/// formats a number with comma separators and a leading + for positives, - for negatives
function number_to_comma_string(_n, _include_sign) {
	var _sign = "";
	if (_include_sign) {
		_sign = (_n >= 0) ? "+" : "-";
	}
    var _abs  = abs(_n);
    var _s    = string(_abs);
    var _result = "";
    var _len  = string_length(_s);
    for (var i = 1; i <= _len; i++) {
        _result += string_char_at(_s, i);
        if ((_len - i) mod 3 == 0 && i < _len) _result += ",";
    }
    return _sign + _result;
}

/// returns a milestone label string, or "" if none reached
function check_subscriber_milestone(_subs) {
    // add or remove tiers to match your design
    if (_subs >= 1000000) return "POLTERGUST UNLOCKED";
    if (_subs >= 100000)  return "EMF MONITOR UNLOCKED";
    if (_subs >= 50000)   return "PRO TV CAM UNLOCKED";
    if (_subs >= 10000)   return "VCR VIDEOCAM UNLOCKED";
    if (_subs >= 0)       return ""; // no milestone yet
    return "";
}

/// builds the actual three columns of data
function build_summary_rows() {
    var _rows = [];

    array_push(_rows, {
        type : "header",
        col1 : "Event",
        col2 : "Nev's Subs",
        col3 : "Nev's Notes",
    });
    array_push(_rows, { type : "separator" });

    var _net = 0;
    for (var i = 0; i < array_length(global.daily_events); i++) {
        var _ev = global.daily_events[i];
        array_push(_rows, {
            type : "event",
            col1 : _ev.label,
            col2 : number_to_comma_string(_ev.sub_change, true),
            col3 : _ev.note,
        });
        _net += _ev.sub_change;
    }

    array_push(_rows, { type : "separator" });

    var _passive = global.daily_passive_growth;
    _net += _passive;
    array_push(_rows, {
        type : "event",
        col1 : "Daily Passive Growth",
        col2 : "+" + string(_passive),
        col3 : "General curiosity from across the world!",
    });

    array_push(_rows, { type : "spacer" });

    array_push(_rows, {
        type : "stat",
        col1 : "NET GAIN",
        col2 : number_to_comma_string(_net, true),
        col3 : "",
    });

    array_push(_rows, { type : "spacer" });

    var _milestone = check_subscriber_milestone(global.subs);
    array_push(_rows, {
        type : "stat",
        col1 : "TOTAL SUBSCRIBERS",
        col2 : number_to_comma_string(global.subs, false),
        col3 : _milestone != "" ? "MILESTONE REACHED: " + _milestone : "",
    });

    return _rows;
}

/// processes raw rows into built_rows with per-column wrapped line arrays
function rebuild() {
    //draw_set_font(config.font);

    _inner_x = config.xpos + config.padding;
    _inner_y = config.ypos + config.padding;
    _inner_w = config.width - config.padding * 2 - config.scrollbar_width - 4;
    _inner_h = config.height - config.padding * 2;

    var _cw   = config.char_width;
    var _col1_w = config.col1_chars * _cw;
    var _col2_w = config.col2_chars * _cw;
    _col2_x  = _col1_w;
    _col3_x  = _col1_w + _col2_w;
    _col3_w  = _inner_w - _col3_x;

    var _col1_chars = config.col1_chars;
    var _col2_chars = config.col2_chars;
    var _col3_chars = floor(_col3_w / _cw);

    built_rows   = [];
    total_height = 0;

    for (var i = 0; i < array_length(rows); i++) {
        var _r = rows[i];

        if (_r.type == "separator") {
            array_push(built_rows, { type : "separator", height : config.line_height });
            total_height += config.line_height;
            continue;
        }

        if (_r.type == "spacer") {
            array_push(built_rows, { type : "spacer", height : config.line_height });
            total_height += config.line_height;
            continue;
        }

        // wrap each column independently
        var _lines1 = wrap_text(_r.col1, _col1_chars);
        var _lines2 = wrap_text(_r.col2, _col2_chars);
        var _lines3 = wrap_text(_r.col3, _col3_chars);

        // row height is the tallest column
        var _line_count = max(array_length(_lines1), array_length(_lines2), array_length(_lines3));
        var _row_h      = _line_count * config.line_height;

        // add a gap after each event/stat row
        var _gap = config.line_height;

        array_push(built_rows, {
            type   : _r.type,
            lines1 : _lines1,
            lines2 : _lines2,
            lines3 : _lines3,
            height : _row_h + _gap,
        });
        total_height += _row_h + _gap;
    }

    // clamp scroll
    var _max_scroll = max(0, total_height - _inner_h);
    scroll_offset   = clamp(scroll_offset, 0, _max_scroll);
}

/// call when creating the summary box inst
function toggle_display() {
    rows = build_summary_rows();
    rebuild();
	visible = !visible;
}
	
toggle_display();