import 'package:flutter/material.dart';
import 'package:todo/utils/database_provider.dart';
import 'package:todo/utils/time_util.dart';

class TaskModel with ChangeNotifier {
  int id;
  String title;
  DateTime date;
  TimeOfDay start;
  TimeOfDay end;
  bool isCompleted;
  bool isArchived;
  bool isDeleted;
  int priority;

  TaskModel(
      {this.id,
      this.title,
      this.date,
      this.start,
      this.end,
      this.isCompleted: false,
      this.isArchived: false,
      this.isDeleted: false,
      this.priority: 0});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_DATE:
          date == null ? null : date.toIso8601String(),
      DatabaseProvider.COLUMN_START: start == null ? null : toMinutes(start),
      DatabaseProvider.COLUMN_END: end == null ? null : toMinutes(end),
      DatabaseProvider.COLUMN_COMPLETED: isCompleted ? 1 : 0,
      DatabaseProvider.COLUMN_ARCHIVED: isArchived ? 1 : 0,
      DatabaseProvider.COLUMN_DELETED: isDeleted ? 1 : 0,
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
        : toTime(map[DatabaseProvider.COLUMN_START]);
    end = map[DatabaseProvider.COLUMN_END] == null
        ? null
        : toTime(map[DatabaseProvider.COLUMN_END]);
    isCompleted = map[DatabaseProvider.COLUMN_COMPLETED] == 1;
    isArchived = map[DatabaseProvider.COLUMN_ARCHIVED] == 1;
    isDeleted = map[DatabaseProvider.COLUMN_DELETED] == 1;
    priority = map[DatabaseProvider.COLUMN_PRIORITY];
  }

  void toggleIsCompleted() {
    isCompleted = !isCompleted;
    DatabaseProvider.db.update(this);
    notifyListeners();
  }

  void toggleIsArchived() {
    isArchived = !isArchived;
    DatabaseProvider.db.update(this);
    notifyListeners();
  }

  void toggleIsDeleted() {
    isDeleted = !isDeleted;
    DatabaseProvider.db.update(this);
    notifyListeners();
  }
}
