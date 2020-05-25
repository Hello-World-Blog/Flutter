import 'package:flutter/material.dart';
import 'package:todo/utils/database_provider.dart';
//Import Database Provider

class TaskModel with ChangeNotifier {
  int id;
  String title;
  DateTime date;
  TimeOfDay start;
  TimeOfDay end;
  bool isCompleted;
  int priority;

  TaskModel(
      {this.id,
      this.title,
      this.date,
      this.start,
      this.end,
      this.isCompleted: false,
      this.priority: 0});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_DATE:
          date == null ? null : date.toIso8601String(),
      DatabaseProvider.COLUMN_START:
          start == null ? null : "${start.hour}:${start.minute}",
      DatabaseProvider.COLUMN_END:
          end == null ? null : "${end.hour}:${end.minute}",
      DatabaseProvider.COLUMN_COMPLETED: isCompleted ? 1 : 0,
      DatabaseProvider.COLUMN_PRIORITY: priority
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  TaskModel.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    title = map[DatabaseProvider.COLUMN_TITLE];
    date = map[DatabaseProvider.COLUMN_DATE] == null
        ? null
        : DateTime.parse(map[DatabaseProvider.COLUMN_DATE]);
    start = map[DatabaseProvider.COLUMN_START] == null
        ? null
        : TimeOfDay(
            hour: int.parse(map[DatabaseProvider.COLUMN_START].split(":")[0]),
            minute:
                int.parse(map[DatabaseProvider.COLUMN_START].split(":")[1]));
    end = map[DatabaseProvider.COLUMN_END] == null
        ? null
        : TimeOfDay(
            hour: int.parse(map[DatabaseProvider.COLUMN_END].split(":")[0]),
            minute: int.parse(map[DatabaseProvider.COLUMN_END].split(":")[1]));
    isCompleted = map[DatabaseProvider.COLUMN_COMPLETED] == 1;
    priority = map[DatabaseProvider.COLUMN_PRIORITY];
  }
}
