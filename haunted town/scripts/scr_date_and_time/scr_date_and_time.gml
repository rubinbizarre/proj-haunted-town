function scr_date_and_time(_time) {
	/*
	
	_time / 60 = hour.progress_through_hour = 3.5 = 3 hrs 30 mins
	
		need to consider if hour == 24 make hour 0 to cycle back
		then also increment counter for which day in the week it is
		if counter == 8 then reset it to 0 to cycle back
	
	global.hour_progress_multiplier = 100 / 60; // this is the factor (constant) that we need to multiply the progress_though_hour value by (it's roughly 1.6667)
	
	progress_through_hour * global.z = actual_minutes
	
	var str_minutes = string(actual_minutes);
	
	if actual_minutes < 10
		str_minutes = "0" + string(actual_minutes);
	
	var str_output = day_name + " " + string(hour) + ":" + str_minutes;
	
	*/
	
	var _actual_hour, _actual_minutes, _hour_progress, _day_counter = 0;
	var _str_hour, _str_minutes, _str_output, _day_name = "";
	
	// determine actual hour (ranges from 0 to 168)
	_actual_hour = floor(_time / 60);	// e.g. 487 / 60 = 8.1166667 = 8
	
	// determine what # day we are on (ranges from 0 to 6) (loops back around when it gets to 7)
	_day_counter = floor(_actual_hour / 24);
	
	// calculate what to output as the current _str_hour (ranges from 00-23) if hour is less than 10, add a 0 before it e.g. "05"
	// here is likely where you would include the logic for converting to 12-hr time but not a priority right now
	_str_hour = string(_actual_hour - (24 * _day_counter));
	if (_str_hour < 10) {
		_str_hour = "0" + _str_hour;
	}
	
	// determine what _day_name to output based on _day_counter
	switch (_day_counter) {
		case 0: _day_name = "Monday"; break;
		case 1: _day_name = "Tuesday"; break;
		case 2: _day_name = "Wednesday"; break;
		case 3: _day_name = "Thursday"; break;
		case 4: _day_name = "Friday"; break;
		case 5: _day_name = "Saturday"; break;
		case 6: _day_name = "Sunday"; break;
		default: _day_name = "Monday"; break;
	}
	
	// determine progression through the hour by retrieving the remainder only from the same calculation
	_hour_progress = _time mod 60; // e.g. 487 / 60 = 8.1166667 = 0.1166667
	//show_message(string(_time) + " mod 60 = " + string(_hour_progress));
	// get actual minutes from the remainder we just retrieved
	_actual_minutes = floor(_hour_progress);//* 60);//global.hour_progress_multiplier); // flooring removes the remainder (unwanted)
	//show_message(string(_hour_progress) + " * 60 = " + string(_actual_minutes));
	// store minutes as a string. if less than 10, add a 0 before it e.g. "08"
	_str_minutes = string(_actual_minutes);
	if (_actual_minutes < 10) {
		_str_minutes = "0" + string(_actual_minutes);
	}
	
	// combine vars to create the final output string e.g. "Monday 14:32"
	_str_output = _day_name + " " + _str_hour + ":" + _str_minutes;
	
	return _str_output;
}