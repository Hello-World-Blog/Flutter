import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/add_a_task.dart';
import 'package:todo/widgets/drawer.dart';

import 'providers/tasks_provider.dart';
import './widgets/all_tasks.dart';
import './widgets/completed_tasks.dart';
import './utils/globals.dart';

void main() {
  runApp(MyApp());
}

List<String> weeks = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];
List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "November",
  "December"
];

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TasksProvider(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              iconTheme: IconThemeData(color: Color(0xff8280FF)),
              primaryColor: Color(0xff8280FF),
              backgroundColor: Colors.white,
              fontFamily: "Segoe UI",
              inputDecorationTheme: InputDecorationTheme(
                border: UnderlineInputBorder(),
              )),
          home: ToDoHome()),
    );
  }
}

class ToDoHome extends StatefulWidget {
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDoHome> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return SafeArea(
      child: Scaffold(
        key: globals.scaffoldKey,
        drawer: CustomDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTask(),
            ));
          },
          iconSize: 40,
          color: Color(0xff8280FF),
        ),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xff8280FF)),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "ToDo.",
              style: TextStyle(
                  color: Color(0xff8280FF),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              Row(
                children: [
                  Text(
                    "${weeks[today.weekday - 1]}, ${months[today.month - 1]} ${today.day} ${today.year}",
                    style: TextStyle(
                        color: Colors.grey[700], fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xff8280FF),
                    size: 15,
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              )
            ],
            bottom: TabBar(
              controller: _tabController,
              labelStyle: TextStyle(fontSize: 20),
              indicatorColor: Color(0xff8280FF),
              labelColor: Color(0xff8280FF),
              unselectedLabelColor: Colors.grey[700],
              tabs: [
                Tab(
                    child: Text(
                  "All",
                )),
                Tab(
                    child: Text(
                  "Completed",
                ))
              ],
            )),
        body: TabBarView(controller: _tabController, children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Provider.of<TasksProvider>(context).isInit
                ? AllTasks()
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xff8280FF),
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: CompletedTasks(),
          ),
        ]),
      ),
    );
  }
}
