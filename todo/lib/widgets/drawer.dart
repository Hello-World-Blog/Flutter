import 'package:flutter/material.dart';
import 'package:todo/pages/archive_page.dart';
import 'package:todo/pages/deleted_page.dart';
// import 'package:todo/pages/archive_page.dart';

class CustomDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          child: null,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/icons/logo.png"))),
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.blue,
          ),
          title: Text(
            "Archives",
            style: TextStyle(color: Colors.blue, fontSize: 20),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArchivePage(),));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text(
            "Deleted Tasks",
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeletePage(),));
          },
        ),
        Divider()
      ],
    ));
  }
}
