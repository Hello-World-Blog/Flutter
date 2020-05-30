import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/pages/add_a_task.dart';
import 'package:todo/utils/notification_provider.dart';

import '../models/task.dart';

class Task extends StatelessWidget {
  Widget build(BuildContext context) {
    final task = Provider.of<TaskModel>(context);
    DateTime date = task.date.toLocal();
    String time = date.day.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.year.toString() +
        "  ";
    String start = task.start.hour > 12
        ? (task.start.hour - 12).toString()
        : task.start.hour.toString();
    String end = task.end.hour > 12
        ? (task.end.hour - 12).toString()
        : task.end.hour.toString();
    String duration = "$start:${task.start.minute} - $end:${task.end.minute}";
    duration += task.end.hour >= 12 ? " PM" : " AM";
    start += task.start.hour >= 12 ? " PM" : " AM";
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: time,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: Colors.black),
                ),
                TextSpan(
                    text: start,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color(0xff8280FF)))
              ]),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              IconButton(
                  icon: task.isCompleted
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.blur_circular,
                          color: Colors.green,
                        ),
                  onPressed: () {
                    task.toggleIsCompleted();
                    NotificationProvider.instance.cancelNotification(task.id);
                  }),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.75,
                      child: Text(
                        task.title,
                        maxLines: null,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8280FF),
                            fontSize: 18,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    duration,
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 15),
                  )
                ],
              ),
            ]),
            Row(
              children: [
                IconButton(
                  iconSize: 25,
                  icon: task.priority == 3
                      ? Image.asset(
                          "assets/icons/icon_high.png",
                          color: Colors.red,
                        )
                      : task.priority == 2
                          ? Image.asset("assets/icons/icon_medium.png",
                              color: Colors.orange[700])
                          : Image.asset(
                              "assets/icons/icon_low.png",
                              color: Colors.yellow[600],
                            ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddTask(
                              task: task,
                            )));
                  },
                  color: Color(0xff8280FF),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
