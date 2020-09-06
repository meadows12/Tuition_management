import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/services/database.dart';

class Profile extends StatefulWidget {
  final String email;
  final String organisation;

  const Profile({Key key, this.email, this.organisation}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String firstname = " ";
  String lastname = " ";
  String phone = " ";
  String cla = " ";
  String age = " ";

  TextEditingController firstNameInputController;
  TextEditingController lastnameInputController;
  TextEditingController classInputController;
  TextEditingController ageInputController;
  TextEditingController mobileNoInputController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 20, right: 20)),
            TextFormField(
              controller: firstNameInputController,
              decoration: InputDecoration(
                  labelText: "First name",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  firstname = value;
                });
              },
            ),
            TextFormField(
              controller: lastnameInputController,
              onChanged: (value) {
                setState(() {
                  lastname = value;
                });
              },
              decoration: InputDecoration(
                  labelText: "Last name",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              controller: mobileNoInputController,
              decoration: InputDecoration(
                  labelText: "Phone",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
            ),
            TextFormField(
              controller: classInputController,
              decoration: InputDecoration(
                  labelText: "Class",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  cla = value;
                });
              },
            ),
            TextFormField(
              controller: ageInputController,
              decoration: InputDecoration(
                labelText: "Age",
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  age = value;
                });
              },
            ),
            RaisedButton(
                child: Text('Submit'),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  side: BorderSide(color: Colors.black),
                ),
                padding: const EdgeInsets.all(20.0),
                onPressed: () async {
                  // ignore: unnecessary_statements
                  Database().storestudentinfo(
                      widget.organisation,
                      widget.email,
                      firstname,
                      lastname,
                      phone,
                      cla,
                      age,
                      context,
                      FirebaseAuth.instance.currentUser.uid);
                })
          ],
        ),
      ),
    );
  }
}
