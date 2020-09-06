import 'package:flutter/material.dart';

class Allstudentprogress extends StatefulWidget {
  @override
  _AllstudentprogressState createState() => _AllstudentprogressState();
}

class _AllstudentprogressState extends State<Allstudentprogress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 100, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 200, 0),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                        ),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Student Progress",
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                //height: MediaQuery.of(context).size.height - 185,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(75.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 70),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
