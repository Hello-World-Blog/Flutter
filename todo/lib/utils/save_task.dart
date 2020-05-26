import 'package:flutter/material.dart';

import 'database_provider.dart';
import 'notification_provider.dart';

bool isValidTask = false;
void saveTask(task, context) async {
  isValidime(task.start, task.end, task.date, task.title);
  if (isValidTask == false) {
    showErrorDialog(context);
  } else {
    if (task.start != null) {
      DateTime notificationTime = DateTime(task.date.year, task.date.month,
          task.date.day, task.start.hour, task.start.minute);
      NotificationProvider.instance.cancelNotification(task.id);
      await DatabaseProvider.db.delete(task.id);
      await DatabaseProvider.db.insert(task).then((value) {
        NotificationProvider.instance.scheduleNotification(
            value.title, notificationTime, value.priority, value.id);
      });
      Navigator.pop(context);
    }
  }
}

void showErrorDialog(context) {
  showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          "Error..!",
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
            "Title must not be left blank\nDate must be specified\nStart Time and End Time must be given\nStart Time should be less than End Time"),
        actions: [
          RaisedButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Color(0xff8280FF))
        ],
      ));
}

void isValidime(TimeOfDay start, TimeOfDay end, DateTime date, String text) {
  if (start == null || end == null) {
    isValidTask = false;
    return;
  } else {
    if (start.hour > end.hour) {
      isValidTask = false;
      return;
    } else if (start.hour == end.hour) {
      if (start.minute > end.minute) {
        isValidTask = false;
        return;
      } else {
        isValidTask = true;
      }
    } else {
      isValidTask = true;
    }
  }
  if (date == null) {
    isValidTask = false;
    return;
  } else {
    isValidTask = true;
  }
  if (text == null || text == "") {
    isValidTask = false;
    return;
  } else {
    isValidTask = true;
  }
}
