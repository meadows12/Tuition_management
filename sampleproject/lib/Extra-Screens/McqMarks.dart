import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class McqMarks extends StatefulWidget {
  final String sub;

  const McqMarks({Key key, this.sub}) : super(key: key);
  @override
  _McqMarksState createState() => _McqMarksState();
}

class _McqMarksState extends State<McqMarks> {
  String name;
  List l = [];
  List<Map<String, dynamic>> values = [];
  Future getassignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('orgname') ?? '';
    print(name);

    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Org')
        .doc(name)
        .collection("Login")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    if (!ds.exists) {
      cla = null;
    } else {
      cla = ds.data()['fields']['class'];
    }

    var query = await FirebaseFirestore.instance
        .collection('Org')
        .doc("Org 2")
        .collection('McqMarks')
        .doc(cla)
        .collection(widget.sub)
        .doc(FirebaseAuth.instance.currentUser.uid);

    query.snapshots().forEach((doc) {
      values = List.from(doc.data()['list']);
      print(doc.data()['list']);
      for (int i = 0; i < values.length; i++) {
        var r = doc.data()['list'][i]['marks'];
        print(r);
        l.add(r);
      }
      print(l);
    });

    print("for");
    for (int i = 0; i < values.length; i++) {
      print(values[i]);
    }

    for (Map m in values) {
      print(m);
    }
    print(values.toString());
  }

  String cla;

  Future check() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Org')
        .doc(name)
        .collection("Login")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    if (!ds.exists) {
      cla = null;
    } else {
      cla = ds.data()['fields']['class'];
    }
  }

  String dropdownValue;

  void getlist() {
    getassignment();

    check();
  }

  @override
  void initState() {
    getlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Org')
          .doc("Org 2")
          .collection('McqMarks')
          .doc("9")
          .collection("English")
          .doc("BxdGMpUjJOXKjg9asD8CCrqViJT2")
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            List videosList;

            videosList = snapshot.data.data()['list'];

            return videosList != null
                ? new Scaffold(
                    body: ListView.builder(
                        itemCount: snapshot.data.data()['list'].length,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        videosList[position]['description'],
                                        style: TextStyle(fontSize: 22.0),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 120.0),
                                        child: Text(
                                          videosList[position]['marks'] + "/30",
                                          style: TextStyle(fontSize: 22.0),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
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
