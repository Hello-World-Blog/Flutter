import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

Future<DateTime> datetimepicker(context) async {
  DateTime newDateTime = await showRoundedDatePicker(
    context: context,
    fontFamily: "Segoe UI",
    firstDate: DateTime.now().subtract(Duration(days: 1)),
    lastDate: DateTime(2040, 12, 31),
    borderRadius: 16,
  );
  DateTime returnDateTime =
      DateTime(newDateTime.year, newDateTime.month, newDateTime.day);
  return returnDateTime;
}

Future<TimeOfDay> timepicker(context) async {
  TimeOfDay newTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
  );
  return newTime;
}
