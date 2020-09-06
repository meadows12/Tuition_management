import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sampleproject/Extra-Screens/Listviewer.dart';
import 'package:sampleproject/Screens/studentAssignmentList.dart';
import 'package:sampleproject/services/database.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class Uploadassign extends StatefulWidget {
  final String id;
  final String clas;
  final String sub;
  final String assign;
  final String title;
  final String description;
  final DateTime eventDate;

  const Uploadassign(
      {Key key,
      this.id,
      this.clas,
      this.sub,
      this.assign,
      this.title,
      this.description,
      this.eventDate})
      : super(key: key);

  @override
  _UploadassignState createState() => _UploadassignState();
}

class _UploadassignState extends State<Uploadassign> {
  String fileType = '';
  File file;
  String fileName = 'sample';
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  bool checkteacher;

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.image);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'audio') {
        file = await FilePicker.getFile(type: FileType.audio);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'video') {
        file = await FilePicker.getFile(type: FileType.video);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'pdf') {
        file = await FilePicker.getFile(
            type: FileType.custom, allowedExtensions: ['pdf']);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'others') {
        file = await FilePicker.getFile(type: FileType.any);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  String name;

  Future<String> getname(id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Org')
        .doc("Org 2")
        .collection("Login")
        .doc(id)
        .get();

    if (!ds.exists) {
      name = null;
    } else {
      name = ds.data()['fields']['firstname'];
    }

    return name;
  }

  Future<bool> check() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Org')
        .doc("Org 2")
        .collection("Login")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (!ds.exists) {
      checkteacher = null;
    } else {
      checkteacher = ds.data()['fields']['isTeacher'];
    }

    return checkteacher;
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");
    }
    if (fileType == 'audio') {
      storageReference =
          FirebaseStorage.instance.ref().child("audio/$filename");
    }
    if (fileType == 'video') {
      storageReference =
          FirebaseStorage.instance.ref().child("videos/$filename");
    }
    if (fileType == 'pdf') {
      storageReference = FirebaseStorage.instance.ref().child("pdf/$filename");
    }
    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child("others/$filename");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('orgname') ?? '';
    print(name);
    String urlname;
    if (fileType == 'image') {
      urlname = 'imageurl';
    } else if (fileType == 'pdf') {
      urlname = 'pdfurl';
    }
    bool ch = await check();
    print(ch);
    if (ch == true) {
      Database().event(
          widget.id,
          widget.clas,
          widget.sub,
          widget.title,
          widget.description,
          url,
          urlname,
          Timestamp.fromDate(widget.eventDate),
          context);
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new Listviewer(
          clas: widget.clas,
          sub: widget.sub,
        );
      }));
    } else {
      String id = FirebaseAuth.instance.currentUser.uid;
      String n = await getname(id);
      Map submit = {"id": id, "url": url, "name": n};

      final CollectionReference dbIDS = FirebaseFirestore.instance
          .collection('Org')
          .doc(name)
          .collection('Submission')
          .doc(widget.clas)
          .collection(widget.sub);

      QuerySnapshot _query =
          await dbIDS.where('description', isEqualTo: widget.assign).get();

      if (_query.docs.length > 0) {
        String id;
        _query.docs.forEach((docs) {
          id = docs.id;
        });
        FirebaseFirestore.instance
            .collection('Org')
            .doc('Org 2')
            .collection('Submission')
            .doc(widget.clas)
            .collection(widget.sub)
            .doc(id)
            .set({
          "description": widget.assign,
          "list": FieldValue.arrayUnion([submit])
        }, SetOptions(merge: true)).catchError((e) {
          print(e);
        });
      } else {
        FirebaseFirestore.instance
            .collection('Org')
            .doc('Org 2')
            .collection('Submission')
            .doc(widget.clas)
            .collection(widget.sub)
            .doc()
            .set({
          "description": widget.assign,
          "list": FieldValue.arrayUnion([submit])
        }, SetOptions(merge: true)).catchError((e) {
          print(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(top: 150, right: 30, left: 50, bottom: 100),
          children: <Widget>[
            ListTile(
              title: Text(
                'Image',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.image,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'image';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'Audio',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.audiotrack,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'audio';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'Video',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.video_label,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'video';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'PDF',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.pages,
                color: Colors.redAccent,
              ),
              /*----new_branch-----
              onTap: () {
                setState(() {
                  fileType = 'pdf';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'Others',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.attach_file,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'others';
                });
                filePicker(context);
              },
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              result,
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),*/
            ),
            ListTile(
              title: Text(
                'Text editor',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.pages,
                color: Colors.redAccent,
              ),
              onTap: () {},
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              result,
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
