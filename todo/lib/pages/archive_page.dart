import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/utils/database_provider.dart';
import 'package:todo/utils/notification_provider.dart';
import 'package:todo/widgets/task.dart';

class ArchivePage extends StatefulWidget{
  _ArchiveState createState()=>_ArchiveState();
}
class _ArchiveState extends State<ArchivePage>{
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(
      title: Text("Archives",style: TextStyle(color: Color(0xff8280FF), fontSize: 24, fontWeight: FontWeight.bold),),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color:Color(0xff8280FF)),
      elevation: 0,
    ),
    body: FutureBuilder(
      future: DatabaseProvider.db.getTasks(),
      builder: (context, snapshot){
      if(snapshot.hasData){
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context,i){
            if(snapshot.data[i].isArchived==true){
          return GestureDetector(
            child:Task(snapshot.data[i],notifyParent: refresh,),
          onTap: ()=>unArchive(context,snapshot.data[i]),
          );
            }
            else{
              return SizedBox();
            }
        });
      }
      else{
        return Center(child:CircularProgressIndicator(backgroundColor: Color(0xff8280FF)),);
      }
    },),
    );
  }
  void unArchive(context,item){
    showDialog(context: context,
    child: AlertDialog(
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                item.isArchived=false;
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
        content: Text("Would you like to unArchive the Task ?"),
      ),
    );
  }
  void refresh(){
    setState(() {
      
    });
  }
}