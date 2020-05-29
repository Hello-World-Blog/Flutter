import 'package:flutter/material.dart';
import 'package:todo/pages/add_a_task.dart';
import 'package:todo/utils/database_provider.dart';
import 'package:todo/utils/notification_provider.dart';
import 'package:todo/widgets/task.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            iconTheme: IconThemeData(color: Color(0xff8280FF)),
            primaryColor: Color(0xff8280FF),
            backgroundColor: Colors.white,
            fontFamily: "Segoe UI",
            inputDecorationTheme: InputDecorationTheme(
              border: UnderlineInputBorder(),
            )),
        home: ToDoHome());
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
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Todo.",
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
            child: FutureBuilder(
                future: DatabaseProvider.db.getSortedtasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          var item = snapshot.data[i];
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
                              child: Task(item, notifyParent: refresh));
                        });
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Color(0xff8280FF)));
                  }
                })),
        Container(
            padding: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: FutureBuilder(
                future: DatabaseProvider.db.getSortedtasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          var item = snapshot.data[i];
                          if (snapshot.data[i].isCompleted == true) {
                            return Task(
                              item,
                              notifyParent: refresh,
                            );
                          } else {
                            return SizedBox();
                          }
                        });
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Color(0xff8280FF)));
                  }
                })),
      ]),
    ));
  }

  Future<bool> showDismissDialog(context, item) async {
    showDialog(
      context: context,
      child: AlertDialog(
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                await DatabaseProvider.db
                    .delete(item.id)
                    .then((value) => setState(() {}));
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

  void refresh() {
    setState(() {});
  }
}
