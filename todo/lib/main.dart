import 'package:flutter/material.dart';
import 'package:todo/pages/add_a_task.dart';
import 'package:todo/utils/database_provider.dart';
import 'package:todo/utils/notification_provider.dart';
import 'package:todo/widgets/drawer.dart';
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
      drawer: CustomDrawer(),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xff8280FF)),
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
                SizedBox(width: 10,),
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
                                              print(snapshot.data[i].title);
                          if(snapshot.data[i].isArchived==false){
                          return GestureDetector(
                            child:Task(snapshot.data[i], notifyParent: refresh),
                            onTap: () => archiveTask(context,snapshot.data[i]),
                            );
                          }
                          else{
                            return SizedBox();
                          }
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
                          if (snapshot.data[i].isCompleted == true && snapshot.data[i].isArchived ==false) {
                            return Task(
                              snapshot.data[i],
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

  void archiveTask(context,item){
    showDialog(context: context,
    child: AlertDialog(
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                item.isArchived=true;
                await DatabaseProvider.db
                    ..delete(item.id)
                    ..insert(item)
                    .then((value) => setState((){}));
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
        content: Text("Would you like to Archive the Task ?"),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
