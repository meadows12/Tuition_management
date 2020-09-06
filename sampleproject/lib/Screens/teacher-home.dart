import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Extra-Screens/classList.dart';
import 'package:sampleproject/Screens/Examination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    List items = ["Assignments", "Examination", "Calender", "Progress"];
    List icons = [
      Icons.assignment,
      Icons.import_contacts,
      Icons.event,
      Icons.poll
    ];
    Container myArticles(int index) {
      return Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: FlatButton(
                child: Card(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Icon(
                            icons[index],
                            color: Colors.blue,
                            size: 70,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: 200,
                            height: 30,
                            child: Text(
                              items[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () async {
                  if (index == 2) {
                    Navigator.of(context).pushNamed('/Calendar');
                  } else if (index == 0) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final name = prefs.getString('orgname') ?? '';
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new Classlist(
                        organisation: name,
                      );
                    }));
                  } else if (index == 3) {
                    Navigator.of(context).pushNamed('/barchart');
                  } else if (index == 1) {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new Examination();
                    }));
                  }
                }),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Center(child: Text('Home')),
        leading: IconButton(
          icon: const Icon(Icons.account_box),
          tooltip: 'Sign Out',
          onPressed: () async {
            await _firebaseAuth.signOut();
            Navigator.popUntil(context, ModalRoute.withName("/"));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              //Profile page
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(75.0),
            child: Text(
              "DASHBOARD",
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(4, (index) {
                      return myArticles(index);
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
