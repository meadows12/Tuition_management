import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Calendar/add_event.dart';
import 'package:sampleproject/Screens/displaySubmission.dart';
import 'package:sampleproject/Screens/uploadAssign.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Listviewer extends StatefulWidget {
  final String clas;
  final String sub;

  const Listviewer({Key key, this.clas, this.sub}) : super(key: key);
  @override
  _ListviewerState createState() => _ListviewerState();
}

class _ListviewerState extends State<Listviewer> {
  List<Map<dynamic, dynamic>> values;

  Future getassignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('orgname') ?? '';
    print(name);

    /*   var query = FirebaseFirestore.instance
        .collection('Org')
        .doc(name)
        .collection('Assignment')
        .doc(FirebaseAuth.instance.currentUser.uid);
    query.snapshots().forEach((doc) {
      values = List.from(doc.data()['${widget.clas}']['${widget.sub}']);
    });

    print(values);*/
  }

  void getlist() {
    getassignment();
  }

  @override
  void initState() {
    getlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Org')
          .doc('Org 2')
          .collection('Assignment')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
          List videosList = 
          snapshot.data.data()['${widget.clas}']['${widget.sub}'];
            
            return videosList != null
                ? new Scaffold(
                    backgroundColor: Color(0xFF1976D2),
                    body: ListView.builder(
                        itemCount: snapshot.data
                            .data()['${widget.clas}']['${widget.sub}']
                            .length,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return new DisplaySubmission(
                                  clas: widget.clas,
                                  sub: widget.sub,
                                  assign: snapshot.data.data()['${widget.clas}']
                                          ['${widget.sub}'][position]
                                      ['title'],
                                );
                              }));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  snapshot.data.data()['${widget.clas}']
                                          ['${widget.sub}'][position]
                                      ['title'],
                                  style: TextStyle(fontSize: 22.0),
                                ),
                              ),
                            ),
                          );
                        }),
                    floatingActionButton: FloatingActionButton(
                      child: new Icon(Icons.add),
                      backgroundColor: Colors.black54,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new AddEventPage(
                            clas: widget.clas,
                            sub: widget.sub,
                          );
                        }));
                      },
                    ),
                  )
                : Center(
                    child: Container(
                    width: 300,
                    child: Text(
                      'No Assignments yet!',
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
