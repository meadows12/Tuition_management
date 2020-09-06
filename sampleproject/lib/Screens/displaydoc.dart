import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sampleproject/services/APIserviceprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFviewer extends StatefulWidget {
  final String url;
  final String clas;
  final String sub;
  final String assign;
  final String name;
  final String id;
  const PDFviewer(
      {Key key, this.url, this.clas, this.sub, this.assign, this.name, this.id})
      : super(key: key);

  @override
  _PDFviewerState createState() => _PDFviewerState();
}

class _PDFviewerState extends State<PDFviewer> {
  String localPath;
  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ApiServiceProvider.loadPDF(widget.url).then((value) {
      setState(() {
        localPath = value;
      });
    });
  }

  _showDialogue(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "TextField in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final name = prefs.getString('orgname') ?? '';
                  print(name);

                  Map m = {
                    "description": widget.assign,
                    "marks": _textFieldController.text.toString()
                  };
                  FirebaseFirestore.instance
                      .collection('Org')
                      .doc(name)
                      .collection('AssignmentMarks')
                      .doc(widget.clas)
                      .collection(widget.sub)
                      .doc(widget.id)
                      .set({
                    'marks': {
                      "${widget.assign}": _textFieldController.text.toString()
                    }
                  }, SetOptions(merge: true)).catchError((e) {
                    print(e);
                  });

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
            _showDialogue("Marks", "Enter marks for this assignment");
          },
        ),
        title: Text(
          "CodingBoot Flutter PDF Viewer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
