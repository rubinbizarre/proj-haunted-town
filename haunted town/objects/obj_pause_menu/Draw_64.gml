if (blend <= 0 || array_length(stack) == 0) exit;
var ease = blend * blend * (3 - 2 * blend);
var items = stack[array_length(stack)-1].items;
var n = array_length(items);

// selection bar that glides between items
draw_set_alpha(0.25 * ease);
draw_set_colour(make_colour_rgb(150, 90, 210));   // purple haunt accent
draw_rectangle(60, sel_y, 460, sel_y + 48, false);
draw_set_alpha(1);
draw_set_font(font_main_body);

for (var i = 0; i < n; i++) {
    var it = items[i];
    var t  = clamp(ease * 1.8 - i * 0.12, 0, 1); // stagger
    var xx = lerp(-300, 80, t * t * (3 - 2 * t)) + it.hover * 14;
    var yy = 300 + i * 56;
    draw_set_alpha(t);
    draw_set_colour(merge_colour(c_gray, c_white, it.hover));
    draw_text_transformed(xx, yy + 8, it.label, 1 + it.hover * 0.08, 1 + it.hover * 0.08, 0);

    if (it.type == 1) {              // slider
        draw_rectangle(xx + 180, yy + 20, xx + 380, yy + 24, false);
        draw_circle(xx + 180 + it.get() * 200, yy + 22, 6, false);
    } else if (it.type == 2) {       // cycle
        draw_text(xx + 180, yy + 8, "< " + it.options[it.get()] + " >");
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_font(global.font_default);