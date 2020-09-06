import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Database {
  // CollectionReference reference = FirebaseFirestore.instance.collection("Org");

  storeteacherinfo(id, orgname, email, firstname, lastname, phone, d, context) {
    FirebaseFirestore.instance
        .collection("Org")
        .doc(orgname)
        .collection("Login")
        .doc(id)
        .set({
      "fields": {
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "email": email
      }
    }, SetOptions(merge: true)).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/Home');
    }).catchError((e) {
      print(e);
    });
  }

  storeneworganisation(email, address, context, name, phone) {
    FirebaseFirestore.instance.collection("Org").doc(name).set({
      "fields": {"Address": address, "Phone no.": phone, "orgname": name}
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/Home');
    }).catchError((e) {
      print(e);
    });
  }

  signinteacher(id, context, orgname) {
    FirebaseFirestore.instance
        .collection("Org")
        .doc(orgname)
        .collection("Login")
        .doc(id)
        .set({
      "fields": {
        "isTeacher": true,
        "isChanged": false,
        "isStudent": false,
        "isProfile": false
      }
    }, SetOptions(merge: true)).catchError((e) {
      print(e);
    });
  }

  signinstudent(id, context, orgname) {
    FirebaseFirestore.instance
        .collection("Org")
        .doc(orgname)
        .collection("Login")
        .doc(id)
        .set({
      "fields": {
        "isTeacher": false,
        "isStudent": true,
        "isProfile": false,
        "isChanged": false
      }
    }, SetOptions(merge: true)).catchError((e) {
      print(e);
    });
  }

  storestudentinfo(
      orgname, email, firstname, lastname, phone, clas, age, context, id) {
    FirebaseFirestore.instance
        .collection("Org")
        .doc(orgname)
        .collection("Login")
        .doc(id)
        .set({
      "fields": {
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "age": age,
        "organisation": orgname,
        "class": clas,
        "email": email
      },
    }, SetOptions(merge: true)).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/Home');
    }).catchError((e) {
      print(e);
    });
  }

  event(id, clas, sub, title, description, url, urlname, event_date, context) {
    Map m = {
      "title": title,
      "description": description,
      "eventDate": event_date,
      "url": url,
      "urlType": urlname
    };

    FirebaseFirestore.instance
        .collection('Org')
        .doc('Org 2')
        .collection("Assignment")
        .doc(id)
        .set({
      clas: {
        sub: FieldValue.arrayUnion([m])
      }
    }, SetOptions(merge: true)).catchError((e) {
      print(e);
    });
  }
}
