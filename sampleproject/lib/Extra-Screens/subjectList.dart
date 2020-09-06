import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Calendar/add_event.dart';
import 'package:sampleproject/Extra-Screens/Listviewer.dart';
import 'package:sampleproject/Screens/uploadAssign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SubjectList extends StatefulWidget {
  final String clas;
  final String organisation;

  const SubjectList({Key key, this.clas, this.organisation}) : super(key: key);
  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  List values;

  Future getassignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('orgname') ?? '';
    print(name);

    var query = FirebaseFirestore.instance
        .collection('Org')
        .doc(name)
        .collection('Login')
        .doc(FirebaseAuth.instance.currentUser.uid);
    query.snapshots().forEach((doc) {
      values = List.from(doc.data()['fields']['${widget.clas}']);
      print(values);
    });
  }
  StreamSubscription<DocumentSnapshot> subscription;
  @override
  void initState() {
    super.initState();
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
            List videosList = snapshot.data.data()['fields']['${widget.clas}'];
            return videosList != null
                ? new Scaffold(
                    backgroundColor: Color(0xFF1976D2),
                    body: ListView.builder(
                        itemCount:
                            snapshot.data.data()['fields']['${widget.clas}'].length,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            onTap: () async {
                              DocumentReference ds = await FirebaseFirestore
                                  .instance
                                  .collection('Org')
                                  .doc(widget.organisation)
                                  .collection("Assignment")
                                  .doc(FirebaseAuth.instance.currentUser.uid);
                                  bool check = false;
                                  subscription = ds.snapshots().listen((event) {
                                    if(event.data().containsKey("${widget.clas}")){
                                      setState(() {
                                        check = true;
                                      });
                                    }
                                   });

                                  

                                  print(check);
                              if (check == false) {
                                Navigator.of(context).push(
                                    MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                  return new AddEventPage(
                                    clas: widget.clas,
                                    sub: snapshot.data.data()['fields']
                                        ['${widget.clas}'][position],
                                  );
                                }));
                              } else {
                                Navigator.of(context).push(
                                    MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                  return new Listviewer(
                                    clas: widget.clas,
                                    sub: snapshot.data.data()['fields']
                                        ['${widget.clas}'][position],
                                  );
                                }));
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  snapshot.data.data()['fields']
                                      ['${widget.clas}'][position],
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
                        fontSize: 22,
                      ),
                    ),
                  ));
        }
      },
    );
  }
}
