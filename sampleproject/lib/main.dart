import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Calendar/calendar_student.dart';
import 'package:sampleproject/Progress/Bar_chart.dart';
import 'package:sampleproject/Progress/Line_chart.dart';
import 'package:sampleproject/Screens/changepassword.dart';
import 'package:sampleproject/Screens/home.dart';
import 'package:sampleproject/Screens/profile.dart';
import 'package:sampleproject/Screens/register.dart';
import 'package:sampleproject/Screens/splashscreen.dart';
import 'package:sampleproject/Screens/teacher-home.dart';
import 'package:sampleproject/Screens/teacher-sign-in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Calendar/add_event.dart';
import 'Calendar/calendar.dart';

import 'Screens/displaySubmission.dart';
import 'Screens/sign-in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MyApp myApp;
  bool checkteacher;
  Future<bool> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('orgname') ?? '';
    print(name);
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Org')
        .doc(name)
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

  if (FirebaseAuth.instance.currentUser != null) {
    checkteacher = await check();
    if (checkteacher == false) {
      myApp = MyApp(initialRoute: '/Home');
    } else {
      myApp = MyApp(initialRoute: '/TeacherHomePage');
    }
  } else {
    myApp = MyApp(initialRoute: '/');
  }

  return runApp(myApp);
}

final routes = {
  '/': (context) => SplashScreen(),
  '/SignIn': (context) => SignIn(),
  '/TeacherSignIn': (context) => TeacherSignin(),
  '/Home': (context) => Home(),
  '/Register': (context) => Register(),
  '/ChangePassword': (context) => ChangePassword(),
  '/Profile': (context) => Profile(),
  '/Calendar': (context) => Calendar(),
  '/Calendar_Student': (context) => CalendarStudent(),
  '/TeacherHomePage': (context) => TeacherHomeScreen(),
  '/add_event': (context) => AddEventPage(),
  '/barchart': (context) => BarChart(),
  '/linechart': (context) => LineChartt(),
  '/DisplaySubmission': (context) => DisplaySubmission(),
};

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key key, this.initialRoute}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
