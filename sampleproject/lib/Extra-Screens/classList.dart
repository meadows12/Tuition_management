import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sampleproject/Extra-Screens/subjectList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Classlist extends StatefulWidget {
  final String organisation;

  const Classlist({Key key, this.organisation}) : super(key: key);

  @override
  _ClasslistState createState() => _ClasslistState();
}

class _ClasslistState extends State<Classlist> {
  DocumentReference ref;
  List values = [];
  String name;
  getassignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('orgname') ?? '';
    print(name);
    var ref = FirebaseFirestore.instance
        .collection('Org')
        .doc(name)
        .collection('Login')
        .doc(FirebaseAuth.instance.currentUser.uid);
    print(ref);
    
  }

  @override
  void initState() {
    
    super.initState();
    getassignment();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Org')
          .doc(widget.organisation)
          .collection('Login')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            List videosList = snapshot.data.data()['fields']['class'];
            return videosList != null
                ? new Scaffold(
                    backgroundColor: Color(0xFF1976D2),
                    body: ListView.builder(
                        itemCount:
                            snapshot.data.data()['fields']['class'].length,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return new SubjectList(
                                  clas: snapshot.data.data()['fields']['class']
                                      [position],
                                  organisation: widget.organisation,
                                );
                              }));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  snapshot.data.data()['fields']['class']
                                      [position],
                                  style: TextStyle(fontSize: 22.0),
                                ),
                              ),
                            ),
                          );
                        }))
                : Center(
                    child: Container(
                    width: 300,
                    child: Text(
                      'Error!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'acumin-pro',
                        fontSize: 30,
                      ),
                    ),
                  ));
        }
      },
    );
  }
}
