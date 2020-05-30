import 'dart:core';

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/database_provider.dart';

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
    return _items.where((item) => !item.isArchived && !item.isDeleted).toList();
  }

  List<TaskModel> get completedTasks {
    return _items.where((item) => item.isCompleted && !item.isArchived && !item.isDeleted).toList();
  }

  List<TaskModel> get archivedTasks {
    return _items.where((item) => item.isArchived).toList();
  }

  List<TaskModel> get deletedTasks {
    return _items.where((item) => item.isDeleted).toList();
  }

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

  void archivedTask(int id) {
    _items.firstWhere((task) => task.id == id).toggleIsArchived();
    notifyListeners();
  }
}
