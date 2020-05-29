import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/utils/database_provider.dart';
import 'package:todo/utils/notification_provider.dart';
import 'package:todo/utils/task_provider.dart';
import 'package:todo/widgets/task.dart';

class Tasks extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasks, child) {
        return tasks.isInit
            ? tasks.items.length == 0
                ? Center(
                    child: Text("No Tasks Here"),
                  )
                : ListView.builder(
                    itemCount: tasks.items.length,
                    itemBuilder: (context, i) {
                      var item = tasks.items[i];
                      return Dismissible(
                          confirmDismiss: (direction) =>
                              showDismissDialog(context, item),
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
                          child: Task(item));
                    })
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple,
                ),
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
                await DatabaseProvider.db.delete(item.id);
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
