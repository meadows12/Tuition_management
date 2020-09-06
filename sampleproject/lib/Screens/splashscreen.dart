import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // List<String> list = ["Pict"];

  // SharedPreferences prefs;

  @override
  initState() {
    Firebase.initializeApp();
    // organisation();
    // getDocs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    child: Text("Organisation", style: TextStyle(fontSize: 20)),
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/Register');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.white),
                    )),
                SizedBox(
                  height: 100,
                ),
                RaisedButton(
                    child: Text("Teacher", style: TextStyle(fontSize: 20)),
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.black,
                    onPressed: () =>
                        {Navigator.of(context).pushNamed('/TeacherSignIn')},
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.white),
                    )),
                SizedBox(
                  height: 100,
                ),
                RaisedButton(
                    child: Text("Student", style: TextStyle(fontSize: 20)),
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    color: Colors.black,
                    onPressed: () async {
                      Navigator.of(context).pushNamed('/SignIn');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.white),
                    ))
              ]),
        ));
  }
}
