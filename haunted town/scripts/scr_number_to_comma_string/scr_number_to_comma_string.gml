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