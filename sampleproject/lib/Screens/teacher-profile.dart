import 'package:flutter/material.dart';
import 'package:sampleproject/Extra-Screens/multi-select.dart';

class ProfileTeacher extends StatefulWidget {
  final String email;
  final String organisation;

  const ProfileTeacher({Key key, this.email, this.organisation})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileTeacher> {
  String firstname = " ";
  String lastname = " ";
  String phone = " ";

  TextEditingController firstNameInputController;
  TextEditingController lastnameInputController;
  TextEditingController mobileNoInputController;
  List<int> selectedValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text("Profile details"),
                ),
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
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: Text('Submit'),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    onPressed: () async {
                      // ignore: unnecessary_statements
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new MultiSelect(
                          email: widget.email,
                          organisation: widget.organisation,
                          firstname: firstname,
                          lastname: lastname,
                          phone: phone,
                        );
                      }));
                    })
              ],
            ),
          ),
        ));
  }
}
