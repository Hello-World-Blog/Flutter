import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import './task.dart';
import 'dialogs.dart';

class AllTasks extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasks, child) {
        return ListView.builder(
          itemCount: tasks.allTasks.length,
          itemBuilder: (context, index) {
            var item = tasks.allTasks[index];
            return Dismissible(
              confirmDismiss: (direction) => showArchiveDialog(context, item,true),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.blue,
                child: item.isArchived?
                 Icon(
                   Icons.unarchive,
                   size: 30,
                   color: Colors.white,
                 )
                :Icon(
                  Icons.archive,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              key: ObjectKey(item),
              child: ChangeNotifierProvider.value(
                value: item,
                child: Task(),
              ),
            );
          },
        );
      },
    );
  }
}
