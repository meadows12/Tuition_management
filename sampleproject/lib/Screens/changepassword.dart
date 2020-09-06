import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Screens/profile.dart';
import 'package:sampleproject/Screens/teacher-profile.dart';
import 'package:sampleproject/Screens/teacher-sign-in.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  final String organisation;

  const ChangePassword({Key key, this.email, this.organisation})
      : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool checkteacher;
  Future<bool> check() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Org')
        .doc(widget.organisation)
        .collection("Login")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (!ds.exists) {
      checkteacher = null;
    } else {
      checkteacher = ds.data()['fields']['isTeacher'];
    }

    return checkteacher;
  }

  void _changePassword(String password) async {
    //Create an instance of the current user.
    User user = await FirebaseAuth.instance.currentUser;
    checkteacher = await check();
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfully changed password");
      FirebaseFirestore.instance
          .collection("Org")
          .doc(widget.organisation)
          .collection("Login")
          .doc(user.uid)
          .update({"fields.isChanged": true}).then((value) => print("Success"));

      if (checkteacher == false) {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new Profile(
            email: widget.email,
            organisation: widget.organisation,
          );
        }));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new ProfileTeacher(
            email: widget.email,
            organisation: widget.organisation,
          );
        }));
      }
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  String newpassword = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            "Change your password",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      newpassword = value;
                    });
                  },
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  )),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(fontSize: 20),
                          ),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: RaisedButton(
                          onPressed: () async {
                            _changePassword(newpassword);
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 20),
                          ),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ])
              ],
            ),
          )
        ],
      ),
    );
  }
}
