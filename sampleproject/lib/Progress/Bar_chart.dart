import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Student {
  final String name;
  final int marks;

  Student(this.name, this.marks);
}

class BarChart extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<BarChart> {
  List<charts.Series> seriesList;
  List<charts.Series> seriesList2;

  static List<charts.Series<Student, String>> studentdata() {
    final desktopStudentsData = [
      Student('Student1', 34),
      Student('Student2', 82),
      Student('Student3', 100),
      Student('Student4', 96),
      Student('Student5', 18),
      Student('Student6', 32),
      Student('Student7', 77),
      Student('Student8', 50),
      Student('Student9', 55),
      Student('Student10', 75),
    ];
    return [
      charts.Series<Student, String>(
          id: 'Student',
          domainFn: (Student data, _) => data.name,
          measureFn: (Student data, _) => data.marks,
          data: desktopStudentsData,
          fillColorFn: (Student data, _) {
            return charts.MaterialPalette.blue.shadeDefault;
          },
          labelAccessorFn: (Student data, _) => '${data.marks.toString()}')
    ];
  }

  static List<charts.Series<Student, String>> studentdata2() {
    final desktopStudentsData2 = [
      Student('Student1', 40),
      Student('Student2', 30),
      Student('Student3', 50),
      Student('Student4', 46),
      Student('Student5', 96),
      Student('Student6', 100),
      Student('Student7', 77),
      Student('Student8', 80),
      Student('Student9', 55),
      Student('Student10', 75),
    ];
    return [
      charts.Series<Student, String>(
          id: 'Student',
          domainFn: (Student data, _) => data.name,
          measureFn: (Student data, _) => data.marks,
          data: desktopStudentsData2,
          fillColorFn: (Student data, _) {
            return charts.MaterialPalette.blue.shadeDefault;
          },
          labelAccessorFn: (Student data, _) => '${data.marks.toString()}')
    ];
  }

  @override
  void initState() {
    super.initState();
    seriesList = studentdata();
    seriesList2 = studentdata2();
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
    );
  }

  barChart2() {
    return charts.BarChart(
      seriesList2,
      animate: true,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.only(left: 50.0, top: 50),
                child: Text(
                  "Overall progress of all students",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  "Percentage",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: 300.0,
                  height: 300.0,
                  child: barChart(),
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
