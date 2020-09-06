import 'package:flutter/material.dart';
import 'package:sampleproject/Extra-Screens/EachAssignmentMarks.dart';
import 'package:sampleproject/Extra-Screens/McqMarks.dart';

class SelectSubject extends StatefulWidget {
  final String page;

  const SelectSubject({Key key, this.page}) : super(key: key);

  @override
  _SelectSubjectState createState() => _SelectSubjectState();
}

class _SelectSubjectState extends State<SelectSubject> {
  String dropdownValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                "Select subject to check the marks",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 36,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                isExpanded: true,
                underline: Container(
                  width: 10,
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['English', 'Maths', 'Marathi']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              // child: RaisedButton(
              //   onPressed: (){
              //     Navigator.of(context).push(MaterialPageRoute<Null>(
              //                                   builder: (BuildContext context){
              //                                     return new AssignmentMarks(
              //                                       sub: dropdownValue,
              //                                     );
              //                                   }
              //                                   ));
              //   },
              //   child: Text("Submit"),
              // ),
              child: ButtonTheme(
                minWidth: 300.0,
                height: 50.0,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.black,
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (widget.page == "Assignment") {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new AssignmentMarks(
                          sub: dropdownValue,
                        );
                      }));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new McqMarks(
                          sub: dropdownValue,
                        );
                      }));
                    }
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
