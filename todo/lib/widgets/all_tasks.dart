import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/notification_provider.dart';
import '../providers/tasks_provider.dart';
import './task.dart';

class AllTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasks, child) {
        return ListView.builder(
          itemCount: tasks.allTasks.length,
          itemBuilder: (context, index) {
            var item = tasks.allTasks[index];
            return Dismissible(
              confirmDismiss: (direction) => showDismissDialog(context, item),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
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

  Future<bool> showDismissDialog(context, item) async {
    showDialog(
      context: context,
      child: AlertDialog(
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                Provider.of<TasksProvider>(context, listen: false)
                    .deleteTask(item.id);
                await NotificationProvider.instance.cancelNotification(item.id);
                Navigator.pop(context);
                return true;
              }),
          IconButton(
            icon: Icon(
              Icons.error,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              return false;
            },
          ),
        ],
        content: Text("Would you like to delete the Task ?"),
      ),
    );
    return false;
  }
}
