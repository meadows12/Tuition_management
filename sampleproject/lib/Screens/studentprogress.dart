import 'package:flutter/material.dart';
import 'package:sampleproject/Extra-Screens/EachAssignmentMarks.dart';

class StudetnProgress extends StatefulWidget {
  @override
  _StudetnProgressState createState() => _StudetnProgressState();
}

class _StudetnProgressState extends State<StudetnProgress> {
  List list = ["Assignment Marks", "Examination marks"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new AssignmentMarks();
                    }));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        list[index],
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
