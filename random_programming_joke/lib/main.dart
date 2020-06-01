import 'package:random_programming_joke/get_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Random Programming Joke",
      theme: ThemeData.dark(),
      home: Scaffold(appBar: AppBar(title: Text("Random Programming Joke"),
      backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Card(child: Container(child: Text(snapshot.data.setup,textAlign: TextAlign.center,),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(50),
            ),
            elevation: 5,
            shadowColor: Colors.yellow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
            color:Colors.red,
            ),
            Card(child: Container(child: Text(snapshot.data.punchline,textAlign: TextAlign.center,),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(50),
            ),
            elevation: 5,
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
            color: Colors.green,
            )
          ],);
        }
        else{
          return Center(child:CircularProgressIndicator());
        }
      },),
      ),
    );
  }
}