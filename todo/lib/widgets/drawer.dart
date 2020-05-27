import 'package:flutter/material.dart';
import 'package:todo/pages/archive_page.dart';

class CustomDrawer extends StatelessWidget{
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: null,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/icons/logo.png"))
          ),
          ),
          ListTile(leading: Icon(Icons.archive,color: Color(0xff8280FF),),
          title: Text("Archives",style: TextStyle(color: Color(0xff8280FF),fontSize: 20),),
          onTap: (){
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArchivePage(),));
          },
          ),
          Divider()
        ],
      )
    );
  }
}