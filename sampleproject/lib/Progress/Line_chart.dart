import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sampleproject/Extra-Screens/EachAssignmentMarks.dart';
import 'package:sampleproject/Extra-Screens/subjectList.dart';
import 'package:sampleproject/Screens/selectSubject.dart';

/// Sample linear data type.
class Student {
  final int assignment;
  final int marks;

  Student(this.assignment, this.marks);
}

/// Example of a line chart rendered with dash patterns.
class LineChartt extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<LineChartt> {
  List<charts.Series> seriesList;
  List<charts.Series> seriesList2;

  List l = ["Assignment marks", "Examination marks"];

  /// Create three series with sample hard coded data.

  static List<charts.Series<Student, int>> _createSampleData2() {
    final Science = [
      new Student(0, 85),
      new Student(1, 45),
      new Student(2, 39),
      new Student(3, 27),
      new Student(4, 40),
      new Student(5, 88),
    ];

    return [
      new charts.Series<Student, int>(
        id: 'Science',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Student sales, _) => sales.assignment,
        measureFn: (Student sales, _) => sales.marks,
        data: Science,
      ),
    ];
  }

  static List<charts.Series<Student, int>> _createSampleData() {
    final English = [
      new Student(0, 15),
      new Student(1, 42),
      new Student(2, 63),
      new Student(3, 36),
      new Student(4, 80),
      new Student(5, 50),
    ];

    /*  final Geography = [
      new Student(0, 35),
      new Student(1, 75),
      new Student(2, 80),
      new Student(3, 54),
      new Student(4, 29),
      new Student(5, 73),
    ];
    final Science = [
      new Student(0, 85),
      new Student(1, 45),
      new Student(2, 39),
      new Student(3, 27),
      new Student(4, 40),
      new Student(5, 88),
    ];*/

    return [
      new charts.Series<Student, int>(
        id: 'English',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Student sales, _) => sales.assignment,
        measureFn: (Student sales, _) => sales.marks,
        data: English,
      ),
      /*  new charts.Series<Student, int>(
        id: 'Geography',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Student sales, _) => sales.assignment,
        measureFn: (Student sales, _) => sales.marks,
        data: Geography,
      ),
      new charts.Series<Student, int>(
        id: 'Science',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (Student sales, _) => sales.assignment,
        measureFn: (Student sales, _) => sales.marks,
        data: Science,
      ),*/
    ];
  }

  /// Creates a [LineChart] with sample data and no transition.
  lineChartt() {
    return charts.LineChart(
      seriesList,
      animate: true,
    );
  }

  linechat2() {
    return charts.LineChart(
      seriesList2,
      animate: true,
    );
  }

  @override
  void initState() {
    seriesList = _createSampleData();
    seriesList2 = _createSampleData2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Student Progress'),
    //   ),
    //   body: Container(
    //     padding: EdgeInsets.all(5.0),
    //     child: lineChartt(),
    //   ),
    // );
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 110, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 200, 0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Student progress",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(
                  "English",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: 300.0,
                  height: 300.0,
                  child: lineChartt(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ButtonTheme(
                  minWidth: 300.0,
                  height: 50.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.black,
                    child: Text(
                      "Assignment Marks",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return SelectSubject(
                          page: "Assignment",
                        );
                      }));
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ButtonTheme(
                  minWidth: 300.0,
                  height: 50.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.black,
                    child: Text(
                      "Examination Marks",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return SelectSubject(
                          page: "Exam",
                        );
                      }));
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(top: 100),
              //   child: Container(
              //         width: 300.0,
              //         height: 300.0,
              //         child: linechat2(),
              //     ),
              // ),

              // Expanded(
              //                   child: Padding(
              //       padding: EdgeInsets.fromLTRB(0, 100, 0, 70),

              //       child: ListView.builder(
              //         physics: ScrollPhysics(),
              //         shrinkWrap: true,
              //         itemCount: 2,
              //         itemBuilder: (BuildContext context,int index){
              //           return Container(
              //             child: Card(
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(16.0),
              //                   child: Text(l[index],

              //                     style: TextStyle(fontSize: 22.0),
              //                   ),
              //                 ),
              //               ),
              //           );
              //         }),

              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
