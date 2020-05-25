import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';

import 'database_provider.dart';

class TaskProvider with ChangeNotifier {
  bool isInit = false;
  bool showCompleted = true;

  List<TaskModel> _items = [];

  TaskProvider() {
    initData();
  }

  void initData() {
    if (isInit == false) {
      _items.clear();
      DatabaseProvider.db.getTasks().then((tasks) {
        print("Contacting DB Tasks Len: ${tasks.length}");
        _items.addAll(tasks);
        isInit = true;
        notifyListeners();
      });
    }
  }

  List<TaskModel> get items {
    return _items;
  }

  void addItem(TaskModel task) {
    DatabaseProvider.db.insert(task).then((task) {
      _items.add(task);
      notifyListeners();
    });
  }

  void deleteItem(int id) {
    DatabaseProvider.db.delete(id).then((_) {
      _items.removeWhere((task) => task.id == id);
      notifyListeners();
    });
  }
}
