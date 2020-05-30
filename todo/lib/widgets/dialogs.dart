import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/tasks_provider.dart';
import 'package:todo/utils/notification_provider.dart';

import '../utils/globals.dart';

Future<bool> showArchiveDialog(context, item, bool toArchive) async {
  showDialog(
    context: globals.scaffoldKey.currentContext,
    child: AlertDialog(
      actions: [
        IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              Provider.of<TasksProvider>(context, listen: false)
                  .toggleArchiveTask(item.id);
              if (toArchive) {
                await NotificationProvider.instance.cancelNotification(item.id);
              } else {
                DateTime notificationTime = DateTime(
                    item.date.year,
                    item.date.month,
                    item.date.day,
                    item.start.hour,
                    item.start.minute);
                await NotificationProvider.instance.scheduleNotification(
                    item.title, notificationTime, item.priority, item.id);
              }
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
      content: toArchive
          ? Text("Would you like to Archive the Task ?")
          : Text("Would you like to unArchive the Task"),
    ),
  );
  return false;
}

void showDismissDialog(context, item, isPermanent) {
  showDialog(
    context: globals.scaffoldKey.currentContext,
    child: AlertDialog(
      actions: [
        IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              if (isPermanent) {
                Provider.of<TasksProvider>(context, listen: false)
                    .deleteTask(item.id);
              } else {
                if (item.isArchived) {
                  Provider.of<TasksProvider>(context, listen: false)
                      .toggleArchiveTask(item.id);
                }
                Provider.of<TasksProvider>(context, listen: false)
                    .toggleSoftDelete(item.id);
                await NotificationProvider.instance.cancelNotification(item.id);
              }
              print(context);
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
      content: Text("Would you like to Delete the Task"),
    ),
  );
}
