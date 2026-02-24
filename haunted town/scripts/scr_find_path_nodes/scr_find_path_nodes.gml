/// @function scr_find_path_nodes(start_node, goal_node)
function scr_find_path_nodes(_start, _goal) {
    if (_start == _goal) return [_start];

    var _queue = ds_queue_create();
    ds_queue_enqueue(_queue, _start);

    // Track visited nodes and their "parents" (where we came from)
    // Using a struct for fast lookups
    var _meta = {}; 
    _meta[$ string(_start.id)] = { parent: noone };

    var _found = false;

    while (!ds_queue_empty(_queue)) {
        var _current = ds_queue_dequeue(_queue);

        if (_current == _goal) {
            _found = true;
            break;
        }

        // Loop through neighbors (assuming 'connections' array exists in node)
        var _neighbors = _current.connections;
        for (var i = 0; i < array_length(_neighbors); i++) {
            var _neighbor = _neighbors[i];
            var _key = string(_neighbor.id);

            // If we haven't visited this neighbor yet
            if (!struct_exists(_meta, _key)) {
                _meta[$ _key] = { parent: _current };
                ds_queue_enqueue(_queue, _neighbor);
            }
        }
    }

    ds_queue_destroy(_queue);

    // Backtrack to build the path array
    if (_found) {
        var _path_array = [];
        var _curr = _goal;
        
        while (_curr != noone) {
            array_insert(_path_array, 0, _curr); // Insert at start to keep order
            _curr = _meta[$ string(_curr.id)].parent;
        }
        return _path_array;
    }

    return []; // Return empty if no path found
}