import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import './task.dart';

class CompletedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(builder: (context, tasks, child) {
      return ListView.builder(
        itemCount: tasks.completedTasks.length,
        itemBuilder: (context, index) {
          var item = tasks.completedTasks[index];
          return ChangeNotifierProvider.value(
            value: item,
            child: Task(),
          );
        },
      );
    });
  }
}
