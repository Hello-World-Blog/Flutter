import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/tasks_provider.dart';
import 'package:todo/widgets/task.dart';

class DeletePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xff8280FF)),
        backgroundColor: Colors.white,
        title: Text(
          "Deleted Tasks",
          style: TextStyle(color: Color(0xff8280FF)),
        ),
      ),
      body: Consumer<TasksProvider>(builder: (context, tasks, child) {
        return ListView.builder(
          itemCount: tasks.deletedTasks.length,
          itemBuilder: (context, index) {
            var item = tasks.deletedTasks[index];
            return ChangeNotifierProvider.value(
              value: item,
              child: Task(),
            );
          },
        );
      }),
    );
  }

  void confirmDelete() {
    showDialog(context: null);
  }
}
