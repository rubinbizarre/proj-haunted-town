function menu_button(_label, _fn) {
    return { type: 0, label: _label, fn: _fn, hover: 0 };
}
function menu_slider(_label, _get, _set) {   // get/set use 0..1
    return { type: 1, label: _label, get: _get, set: _set, hover: 0 };
}
function menu_cycle(_label, _options, _get, _set) {   // get returns index, set takes index
    return { type: 2, label: _label, options: _options, get: _get, set: _set, hover: 0 };
}