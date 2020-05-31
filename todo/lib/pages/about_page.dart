import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xff8280FF)),
        backgroundColor: Colors.white,
        title: Text(
          "About",
          style: TextStyle(color: Color(0xff8280FF)),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 50, right: 50, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/logo.png",
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "An open source Flutter Project, which never let's you forget a thing",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 3,
              ),
              Text(
                "Our Contributors",
                style: TextStyle(
                    color: Color(0xff8280FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.underline),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Tarun",
                style: TextStyle(color: Color(0xff8280FF), fontSize: 20),
              ),
              Text(
                "Deva Kumar Kilim",
                style: TextStyle(color: Color(0xff8280FF), fontSize: 20),
              )
            ],
          )),
    );
  }
}
