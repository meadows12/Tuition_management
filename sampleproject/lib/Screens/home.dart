import 'package:charts_flutter/flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Extra-Screens/classList.dart';
import 'package:sampleproject/Extra-Screens/studentClassList.dart';
import 'package:sampleproject/Calendar/calendar.dart';
import 'package:sampleproject/Progress/Bar_chart.dart';
import 'package:sampleproject/Screens/Examination.dart';
import 'package:sampleproject/Screens/studentProgress.dart';
import 'package:sampleproject/Screens/studentprogress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Center(child: Text('Home')),
    //       leading: IconButton(
    //         icon: const Icon(Icons.account_box),
    //         tooltip: 'Sign Out',
    //         onPressed: () async {
    //           await _firebaseAuth.signOut();
    //           Navigator.popUntil(context, ModalRoute.withName("/"));
    //         },
    //       ),
    //       actions: <Widget>[
    //         IconButton(
    //           icon: const Icon(Icons.account_circle),
    //           tooltip: 'Profile',
    //           onPressed: () {
    //             //Profile page
    //           },
    //         ),
    //       ],
    //     ),
    //     body: Center(
    //         child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         RaisedButton(
    //           onPressed: () {},
    //           textColor: Colors.white,
    //           padding: const EdgeInsets.all(0.0),
    //           child: Container(
    //             decoration: const BoxDecoration(
    //               gradient: LinearGradient(
    //                 colors: <Color>[
    //                   Color(0xFF0D47A1),
    //                   Color(0xFF1976D2),
    //                   Color(0xFF42A5F5),
    //                 ],
    //               ),
    //             ),
    //             padding: const EdgeInsets.all(10.0),
    //             child: const Text('Assignment', style: TextStyle(fontSize: 20)),
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 40,
    //         ),
    //         RaisedButton(
    //           onPressed: () {},
    //           textColor: Colors.white,
    //           padding: const EdgeInsets.all(0.0),
    //           child: Container(
    //             decoration: const BoxDecoration(
    //               gradient: LinearGradient(
    //                 colors: <Color>[
    //                   Color(0xFF0D47A1),
    //                   Color(0xFF1976D2),
    //                   Color(0xFF42A5F5),
    //                 ],
    //               ),
    //             ),
    //             padding: const EdgeInsets.all(10.0),
    //             child: const Text('Exams', style: TextStyle(fontSize: 20)),
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 40,
    //         ),
    //         RaisedButton(
    //           onPressed: () async {
    //             Navigator.push(context,
    //                 MaterialPageRoute(builder: (context) => Calendar()));
    //           },
    //           textColor: Colors.white,
    //           padding: const EdgeInsets.all(0.0),
    //           child: Container(
    //             decoration: const BoxDecoration(
    //               gradient: LinearGradient(
    //                 colors: <Color>[
    //                   Color(0xFF0D47A1),
    //                   Color(0xFF1976D2),
    //                   Color(0xFF42A5F5),
    //                 ],
    //               ),
    //             ),
    //             padding: const EdgeInsets.all(10.0),
    //             child: const Text('Calendar', style: TextStyle(fontSize: 20)),
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 40,
    //         ),
    //         RaisedButton(
    //           onPressed: () {},
    //           textColor: Colors.white,
    //           padding: const EdgeInsets.all(0.0),
    //           child: Container(
    //             decoration: const BoxDecoration(
    //               gradient: LinearGradient(
    //                 colors: <Color>[
    //                   Color(0xFF0D47A1),
    //                   Color(0xFF1976D2),
    //                   Color(0xFF42A5F5),
    //                 ],
    //               ),
    //             ),
    //             padding: const EdgeInsets.all(10.0),
    //             child: const Text('Progress', style: TextStyle(fontSize: 20)),
    //           ),
    //         ),
    //       ],
    //     )));
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
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new StudentClassList(
                      organisation: name,
                    );
                  }));
                } else if (index == 3) {
                  Navigator.of(context).pushNamed('/linechart');
                } else if (index == 1) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Examination();
                  }));
                }
              },
            ),
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
