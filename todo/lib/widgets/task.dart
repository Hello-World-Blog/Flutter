import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/pages/add_a_task.dart';
import 'package:todo/utils/database_provider.dart';

class Task extends StatefulWidget {
  final TaskModel task;
  final Function notifyParent;
  Task(this.task, {Key key, @required this.notifyParent}) : super(key: key);
  _TaskState createState() => _TaskState(this.task);
}

class _TaskState extends State<Task> {
  TaskModel task;
  _TaskState(this.task);
  Widget build(BuildContext context) {
    DateTime date = task.date.toLocal();
    String time = date.day.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.year.toString() +
        "  " ;
    String start=task.start.hour<12?task.start.hour.toString():(task.start.hour-12).toString();
    String end=task.end.hour<12?task.end.hour.toString():(task.end.hour-12).toString();
    String duration = "$start:${task.start.minute} - $end:${task.end.minute}";
    duration += task.end.hour > 12 ? " PM" : " AM";
    start += task.start.hour < 12 ? " AM" : " PM";
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
              text: TextSpan(
                children: [
                  TextSpan(text: time,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18,color:Colors.black),),
                  TextSpan(text: start,style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18,color:Color(0xff8280FF)))
                ]
              ),
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
                    task.isCompleted = !task.isCompleted;
                    DatabaseProvider.db.update(task);
                    setState(() {});
                    widget.notifyParent();
                  }),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff8280FF),
                        fontSize: 18,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null),
                  ),
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
                Icon(
                    this.task.priority == 3
                        ? Icons.priority_high
                        : this.task.priority == 2
                            ? Icons.build
                            : Icons.low_priority,
                    color: this.task.priority == 3
                        ? Colors.red
                        : this.task.priority == 2
                            ? Colors.orange[700]
                            : Colors.yellow[600],
                    size: 25),
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
