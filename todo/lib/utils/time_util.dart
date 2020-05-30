import 'package:flutter/material.dart';

int toMinutes(TimeOfDay time) {
  int minutes = 0;
  minutes += time.hour * 60 + time.minute;
  return minutes;
}

TimeOfDay toTime(int minutes) {
  int hour = minutes ~/ 60;
  minutes -= 60 * (minutes ~/ 60);
  int minute = minutes;
  return TimeOfDay(hour: hour, minute: minute);
}
