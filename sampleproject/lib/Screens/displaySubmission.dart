import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Screens/displaydoc.dart';
import 'package:sampleproject/Screens/displayiamge.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class DisplaySubmission extends StatefulWidget {
  final String clas;
  final String sub;
  final String assign;
  final String organisation;

  const DisplaySubmission({Key key, this.clas, this.sub, this.assign, this.organisation})
      : super(key: key);

  @override
  _DisplaySubmissionState createState() => _DisplaySubmissionState();
}

class _DisplaySubmissionState extends State<DisplaySubmission> {
  List<Map<dynamic, dynamic>> values;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Org')
          .doc(widget.organisation)
          .collection('Submission')
          .doc('${widget.clas}')
          .collection('${widget.sub}')
          .where("description", isEqualTo: widget.assign)
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            snapshot.data.docs.forEach((doc) {
              values = List.from(doc.data()['list']);
            });
            return values != null
                ? new ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        onTap: () {
                          if (values[position]['urlType'] == "pdfurl") {
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                              return PDFviewer(
                                assign: widget.assign,
                                sub: widget.sub,
                                clas: widget.clas,
                                url: values[position]['url'],
                                name: values[position]['name'],
                                id: values[position]['id'],
                              );
                            }));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                              return Displayimage(
                                assign: widget.assign,
                                sub: widget.sub,
                                clas: widget.clas,
                                url: values[position]['url'],
                                name: values[position]['name'],
                                id: values[position]['id'],
                              );
                            }));
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              values[position]['name'],
                              style: TextStyle(fontSize: 22.0),
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Container(
                    width: 300,
                    child: Text(
                      'No assignments yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        
                        fontSize: 22,
                        color: Colors.white
                      ),
                    ),
                  ));
        }
      },
    );
  }
}
