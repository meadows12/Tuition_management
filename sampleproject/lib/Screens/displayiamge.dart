import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class Displayimage extends StatefulWidget {
  final String url;
  final String clas;
  final String sub;
  final String assign;
  final String name;
  final String id;

  const Displayimage(
      {Key key, this.url, this.clas, this.sub, this.assign, this.name, this.id})
      : super(key: key);

  @override
  _DisplayimageState createState() => _DisplayimageState();
}

class _DisplayimageState extends State<Displayimage> {
  TextEditingController _textFieldController = TextEditingController();

  static String pathPDF = "";
  static String pdfUrl = "";

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
  void initState() {
    super.initState();
    // LaunchFile.createFileFromPdfUrl(widget.url).then(
    //           (f) => setState(
    //             () {
    //               if (f is File) {
    //                 pathPDF = f.path;
    //               } else if (widget.url is Uri) {
    //                 //Open PDF in tab (Web)
    //                 pdfUrl = widget.url.toString();
    //               }
    //             },
    //           ),
    //         )
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
          "Iamge",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.25,
        width: MediaQuery.of(context).size.width / 1.25,
        child: Image.network(widget.url),
        //               child: FlatButton(
        //     onPressed: () {
        //       setState(() {
        //         LaunchFile.launchPDF(
        //             context, "Flutter Slides", pathPDF, widget.url);
        //       });
        //     },
        //     child: Text(
        //       "Open PDF",
        //       style: TextStyle(fontSize: 20),
        //     ),
        //   ),
      ),
      persistentFooterButtons: <Widget>[
        IconButton(
          icon: Icon(Icons.wallpaper),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.file_download),
          onPressed: () {
            _save();
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    );
  }

  _save() async {
    var response = await Dio()
        .get(widget.url, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

    print(result);
  }
}
