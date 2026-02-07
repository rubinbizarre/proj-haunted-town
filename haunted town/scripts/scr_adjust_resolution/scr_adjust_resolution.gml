//// width/height: The target resolution (e.g., 1920, 1080)
//// mode: 0 = Windowed, 1 = Fullscreen, 2 = Borderless

//function scr_adjust_resolution(_w, _h, _mode) {
//    // 1 = fullscreen mode
//    if (_mode == 1) {
//        window_set_fullscreen(true);
//    } else {
//        window_set_fullscreen(false);
        
//        // 2 = handle borderless vs windowed
//        if (_mode == 2) {
//            window_set_showborder(false);
//            window_set_rectangle(0, 0, display_get_width(), display_get_height());
//        } else {
//            window_set_showborder(true);
//            window_set_size(_w, _h);
//            // center it after a frame (use a timer or alarm)
//            alarm[0] = 1; 
//        }
//    }

//    // THE MOST IMPORTANT PART: resize the base application surface
//    // this ensures sprites stay crisp
//    surface_resize(application_surface, _w, _h);
    
//    // update the GUI layer so your menus don't break
//    display_set_gui_size(_w, _h);
//}

function scr_adjust_resolution(_w, _h, _mode) {
    // set the window state
	// mode: 0 = Windowed, 1 = Fullscreen, 2 = Borderless
    window_set_fullscreen(_mode == 1);
    if (_mode == 2) window_set_showborder(false); else window_set_showborder(true);
    window_set_size(_w, _h);

    // calculate aspect ratio
    var _ideal_ratio = 1920 / 1080;		// our target aspect ratio
    var _current_ratio = _w / _h;		// our actual aspect ratio
    
    var _view_w, _view_h, _offset_x, _offset_y;

    if (_current_ratio > _ideal_ratio) {
        // Window is WIDER than game (Ultrawide) -> Bars on sides
        _view_h = _h;
        _view_w = _h * _ideal_ratio;
        _offset_x = (_w - _view_w) / 2;
        _offset_y = 0;
    } else {
        // Window is TALLER than game -> Bars on top/bottom
        _view_w = _w;
        _view_h = _w / _ideal_ratio;
        _offset_x = 0;
        _offset_y = (_h - _view_h) / 2;
    }

    // now apply size to viewport
    view_set_wport(0, _view_w);
    view_set_hport(0, _view_h);
    view_set_xport(0, _offset_x);
    view_set_yport(0, _offset_y);

    // resize Application Surface to match the view, not the window!
    surface_resize(application_surface, _view_w, _view_h);
    
	// update the GUI layer so menus don't break
    display_set_gui_size(_w, _h);
	
    // center window via alarm
    alarm[0] = 1;
}