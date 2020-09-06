import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Extra-Screens/Listviewer.dart';
import 'package:sampleproject/Screens/studentAssignmentList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alert.dart';

class StudentClassList extends StatefulWidget {
  
  final String organisation;

  const StudentClassList({Key key, this.organisation}) : super(key: key);



  @override
  _StudentClassListState createState() => _StudentClassListState();
}

class _StudentClassListState extends State<StudentClassList> {

  String cla;

  Future<String> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('orgname') ?? '';
    print(name);
  DocumentSnapshot ds =
  await FirebaseFirestore.instance.collection('Org').doc(name).collection("Login").doc(FirebaseAuth.instance.currentUser.uid).get();
  if(!ds.exists){
    cla = null;
  }else
  {
    cla = ds.data()['fields']['class'];
  }
  return cla;
}

StreamSubscription<DocumentSnapshot> subscription;

  List values = ["English","Maths","Marathi"];
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1976D2),
      body: ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, position) {
          return GestureDetector(
            onTap: ()async{

              cla = await check();

              bool checkif = false;
              var queary = await FirebaseFirestore
                                  .instance
                                  .collection('Org')
                                  .doc(widget.organisation)
                                  .collection("Assignment").get();

                                  String id;
                                  queary.docs.forEach((element) {
                                    id = element.id;
                                   });
                                  
                                  
              DocumentReference ds = FirebaseFirestore
                                  .instance
                                  .collection('Org')
                                  .doc(widget.organisation)
                                  .collection("Assignment")
                                  .doc(id);

                                  
                                  subscription = ds.snapshots().listen((event) {
                                    if(event.data().containsKey(values[position])){
                                      setState(() {
                                        checkif = true;
                                      });
                                    }
                                   });

                                  

                                  print(checkif);
              if(checkif == true){
                Navigator.of(context).push(MaterialPageRoute<Null>(
                                    builder: (BuildContext context){
                                      return new StudentAssignList(
                                        clas: cla,
                                        sub:values[position],
                                      );
                                    }
                                    ));
              }else{
                Navigator.of(context).push(MaterialPageRoute<Null>(
                                    builder: (BuildContext context){
                                      return new Alert(
                                        
                                      );
                                    }
                                    ));
              }
              
            },
            child: Card(
              
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(values[position], style: TextStyle(fontSize: 22.0),),
                
              ),
            ),
          );
        },
      ),
    );
}
}