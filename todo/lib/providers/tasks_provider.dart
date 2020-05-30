import 'dart:core';

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/task.dart';
import '../models/task.dart';
import '../utils/database_provider.dart';
import '../utils/notification_provider.dart';

class TasksProvider with ChangeNotifier {
  bool isInit = false;

  List<TaskModel> _items = [];

  TasksProvider() {
    initData();
  }

  void initData() {
    if (isInit == false) {
      _items.clear();
      DatabaseProvider.db.getSortedtasks().then((tasks) {
        _items.addAll(tasks);
        isInit = true;
        notifyListeners();
      });
    }
  }

  List<TaskModel> get allTasks {
    return [..._items];
  }

  List<TaskModel> get completedTasks {
    return _items.where((item) => item.isCompleted).toList();
  }

  // void addTask({
  //   String title,
  //   DateTime date,
  //   TimeOfDay start,
  //   TimeOfDay end,
  //   int priority,
  // }) {
  //   var currentTask = TaskModel(
  //       title: title, date: date, start: start, end: end, priority: priority);
  //   DatabaseProvider.db.insert(currentTask).then((task) {
  //     _items.add(task);
  //     notifyListeners();
  //   });
  // }

  Future<TaskModel> addTask(TaskModel currentTask) {
    return DatabaseProvider.db.insert(currentTask).then((task) {
      _items.add(task);
      notifyListeners();
      return task;
    });
  }

  void deleteTask(int id) {
    DatabaseProvider.db.delete(id).then((_) {
      _items.removeWhere((task) => task.id == id);
      notifyListeners();
    });
  }
}
