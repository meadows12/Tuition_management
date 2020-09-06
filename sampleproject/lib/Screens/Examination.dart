import 'package:flutter/material.dart';

class Examination extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<Examination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            Text("Comming soon......", style: TextStyle(color: Colors.white)),
          ]),
        ));
  }
}
