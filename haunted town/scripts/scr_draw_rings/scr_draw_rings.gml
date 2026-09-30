function draw_ring(_x, _y, _r, _thick, _col, _alpha, _segs = 48) {
    var _ro = _r + _thick * 0.5;
    var _ri = max(0, _r - _thick * 0.5);
    var _step = 360 / _segs;

    draw_primitive_begin(pr_trianglestrip);
    for (var i = 0; i <= _segs; i++) {
        var _c =  dcos(i * _step);
        var _s = -dsin(i * _step);
        draw_vertex_color(_x + _c * _ro, _y + _s * _ro, _col, _alpha);
        draw_vertex_color(_x + _c * _ri, _y + _s * _ri, _col, _alpha);
    }
    draw_primitive_end();
}