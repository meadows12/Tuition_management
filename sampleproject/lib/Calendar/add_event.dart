import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sampleproject/Calendar/event.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Screens/uploadAssign.dart';
import 'package:sampleproject/services/database.dart';

import '../services/database.dart';

class AddEventPage extends StatefulWidget {
  final String clas;
  final String sub;

  const AddEventPage({Key key, this.clas, this.sub}) : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  String title_event = "";
  String description = "";

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
  var id = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _eventDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add note"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      title_event = value;
                    });
                  },
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter title" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter description" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Date (YYYY-MM-DD)"),
                subtitle: Text(
                    "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                onTap: () async {
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: _eventDate,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              FloatingActionButton(
                child: Text(
                  "Save",
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new Uploadassign(
                            id: id,
                            clas: widget.clas,
                            sub: widget.sub,
                            title: title_event,
                            description: description,
                            eventDate: _eventDate);
                      }));
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
/*
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
  */
}
