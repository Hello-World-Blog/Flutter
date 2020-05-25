import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:todo/models/task.dart';
import 'package:todo/utils/database_provider.dart';
import 'package:todo/utils/notification_provider.dart';

class AddTask extends StatefulWidget {
  final TaskModel task;
  AddTask({this.task});
  _AddState createState() => _AddState(task: task == null ? null : task);
}

class _AddState extends State<AddTask> {
  final TaskModel task;
  _AddState({this.task});
  TextEditingController controller = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController taskController = new TextEditingController();
  TextEditingController endTimeController = new TextEditingController();
  int _priority = 3;
  TaskModel newTask = new TaskModel();
  bool isValidTask = true;
  @override
  void initState() {
    if (this.task != null) {
      taskController.text = this.task.title.toString();
      controller.text =
          "${this.task.date.day}/${this.task.date.month}/${this.task.date.year}";
      timeController.text = "${this.task.start.hour}:${this.task.start.minute}";
      endTimeController.text = "${this.task.end.hour}:${this.task.end.minute}";
    }
    super.initState();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            floatingActionButton: RaisedButton(
              onPressed: () async {
                if (this.task == null) {
                  newTask.title = taskController.text;
                  isValidime(
                      newTask.start, newTask.end, newTask.date, newTask.title);
                  if (isValidTask == false) {
                    showErrorDialog();
                  } else {
                    newTask.priority = _priority;
                    newTask.isCompleted = false;
                    if (newTask.start != null) {
                      DateTime notificationTime = DateTime(
                          newTask.date.year,
                          newTask.date.month,
                          newTask.date.day,
                          newTask.start.hour,
                          newTask.start.minute);
                      await DatabaseProvider.db.insert(newTask).then((value){
                      NotificationProvider.instance.scheduleNotification(
                          value.title, notificationTime, value.priority,value.id);
                      });
                    }
                    Navigator.pop(context);
                  }
                } else {
                  task.title = taskController.text;
                  isValidime(task.start, task.end, task.date, task.title);
                  if (isValidTask == false) {
                    showErrorDialog();
                  } else {
                    task.priority = _priority;
                    if (task.start != null) {
                      DateTime notificationTime = DateTime(
                          task.date.year,
                          task.date.month,
                          task.date.day,
                          task.start.hour,
                          task.start.minute);
                      NotificationProvider.instance.cancelNotification(task.id);
                    await DatabaseProvider.db.delete(task.id);
                    await DatabaseProvider.db.insert(task).then((value){
                      NotificationProvider.instance.scheduleNotification(
                          value.title, notificationTime, value.priority,value.id);
                      });
                    Navigator.pop(context);
                  }
                }
              }
              },
              child: Text(
                "Save Task",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              color: Color(0xff8280FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            appBar: AppBar(
              title: Text(
                "Create New Task.",
                style: TextStyle(color: Color(0xff8280FF), fontSize: 24),
              ),
              backgroundColor: Colors.white,
              elevation: 0.5,
              iconTheme: IconThemeData(color: Colors.grey),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Container(
              padding: EdgeInsets.fromLTRB(20, 50, 30, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.blur_circular,
                        color: _priority == 1
                            ? Colors.yellow[600]
                            : _priority == 2 ? Colors.orange : Colors.red,
                        size: 24,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("New Task",
                          style: TextStyle(color: Colors.grey, fontSize: 16))
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextField(
                        controller: taskController,
                        decoration: InputDecoration(labelText: "Task Title"),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: width / 5, right: width / 5, top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Color(0xff8280FF),
                              ),
                              onPressed: () {
                                datetimepicker().then((value) {
                                  this.task == null
                                      ? newTask.date = value
                                      : task.date = value;
                                  setState(() {
                                    controller.text =
                                        "${value.day}/${value.month}/${value.year}";
                                  });
                                });
                              }),
                          Expanded(
                              child: TextField(
                                  enabled: false,
                                  controller: controller,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelText: "Date",
                                    hintText: "DD/MM/YYYY",
                                  )))
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width / 5, right: width / 5, top: 30),
                    child: Row(children: [
                      IconButton(
                        icon: Icon(
                          Icons.timer,
                          color: Color(0xff8280FF),
                        ),
                        onPressed: () {
                          timepicker().then((value) {
                            this.task == null
                                ? newTask.start = value
                                : task.start = value;
                            setState(() {
                              timeController.text =
                                  "${value.hour}:${value.minute}";
                            });
                          });
                        },
                      ),
                      Expanded(
                          child: TextField(
                        enabled: false,
                        textAlign: TextAlign.center,
                        controller: timeController,
                        decoration: InputDecoration(
                          labelText: "Start",
                          hintText: "HH:MM (24Hrs)",
                        ),
                      ))
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width / 5, right: width / 5, top: 30),
                    child: Row(children: [
                      IconButton(
                        icon: Icon(
                          Icons.timer,
                          color: Color(0xff8280FF),
                        ),
                        onPressed: () {
                          timepicker().then((value) {
                            this.task == null
                                ? newTask.end = value
                                : task.end = value;
                            setState(() {
                              endTimeController.text =
                                  "${value.hour}:${value.minute}";
                            });
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            controller: endTimeController,
                            decoration: InputDecoration(
                              labelText: "End",
                              hintText: "HH:MM (24Hrs)",
                            )),
                      )
                    ]),
                  ),
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                            ),
                            Text(
                              " Priority",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(children: [
                          Column(children: [
                            Radio(
                              activeColor: Colors.yellow[600],
                              value: 1,
                              groupValue: _priority,
                              onChanged: (value) {
                                setState(() {
                                  _priority = value;
                                });
                                task == null
                                    ? newTask.priority = _priority
                                    : task.priority = _priority;
                              },
                            ),
                            Text(
                              "LOW",
                              style: TextStyle(color: Colors.yellow[600]),
                            )
                          ]),
                          Column(children: [
                            Radio(
                              activeColor: Colors.orange,
                              value: 2,
                              groupValue: _priority,
                              onChanged: (value) {
                                setState(() {
                                  _priority = value;
                                });
                                task == null
                                    ? newTask.priority = _priority
                                    : task.priority = _priority;
                              },
                            ),
                            Text(
                              "MEDIUM",
                              style: TextStyle(color: Colors.orange),
                            )
                          ]),
                          Column(children: [
                            Radio(
                              activeColor: Colors.red,
                              value: 3,
                              groupValue: _priority,
                              onChanged: (value) {
                                setState(() {
                                  _priority = value;
                                });
                                task == null
                                    ? newTask.priority = _priority
                                    : task.priority = _priority;
                              },
                            ),
                            Text(
                              "HIGH",
                              style: TextStyle(color: Colors.red),
                            )
                          ])
                        ]),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 60),
                  )
                ],
              ),
            )));
  }

  void showErrorDialog() {
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

  Future<DateTime> datetimepicker() async {
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      theme: ThemeData.dark(),
      fontFamily: "Segoe UI",
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(2040, 12, 31),
      borderRadius: 16,
    );
    return newDateTime;
  }

  Future<TimeOfDay> timepicker() async {
    TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    return newTime;
  }
  void isValidime(TimeOfDay start, TimeOfDay end, DateTime date, String text) {
    if (start == null || end == null) {
      isValidTask = false;
    } else {
      if (start.hour > end.hour) {
        isValidTask = false;
      } else if (start.hour == end.hour) {
        if (start.minute > end.minute) {
          isValidTask = false;
        } else {
          isValidTask = true;
        }
      } else {
        isValidTask = true;
      }
    }
    if (date == null) {
      isValidTask = false;
    } else {
      isValidTask = true;
    }
    if (text == null || text == "") {
      isValidTask = false;
    } else {
      isValidTask = true;
    }
  }
}
