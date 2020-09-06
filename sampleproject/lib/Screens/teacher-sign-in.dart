import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sampleproject/Screens/changepassword.dart';
import 'package:sampleproject/services/database.dart';
import 'package:sampleproject/services/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherSignin extends StatefulWidget {
  @override
  _TeacherSigninState createState() => _TeacherSigninState();
}

class _TeacherSigninState extends State<TeacherSignin> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state

  BuildContext _ctx;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String error = '';
  bool _showPassword = false;
  String email = " ";
  String password = " ";

  String _selectorg;

  bool checkpass;

  List list = [];

  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Org").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a.id);
    }
  }

  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();

    // getDocs();
    setlist();
    super.initState();
    Firebase.initializeApp();
  }

  void setlist() async {
    list = await getHistory();
    print(list);
  }

  Future<List> getHistory() async {
    List history;

    final List<DocumentSnapshot> documents =
        (await FirebaseFirestore.instance.collection("Org").get()).docs;

    history = documents.map((documentSnapshot) => documentSnapshot.id).toList();

    return history;
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter an Email';
    } else if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6 && value.length > 1) {
      return 'Password must be longer than 6 characters';
    } else if (value.isEmpty) {
      return 'Please enter the password';
    } else {
      return null;
    }
  }

  _showDialogue(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<bool> check() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Org')
        .doc(_selectorg)
        .collection("Login")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (!ds.exists) {
      checkpass = null;
    } else {
      checkpass = ds.data()['fields']['isChanged'];
    }

    return checkpass;
  }

  void save(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("orgname", name);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.black54,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 150, right: 50, left: 50, bottom: 150),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (val) => emailValidator(val),
                        controller: emailInputController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.blue[400],
                            ),
                            labelText: "Email ID",
                            hintText: "john.doe@gmail.com",
                            labelStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        onChanged: (value) => {
                          setState(() {
                            password = value;
                          })
                        },
                        controller: pwdInputController,
                        validator: (val) => pwdValidator(val),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue[400],
                          ),
                          labelText: "Password",
                          hintText: "********",
                          labelStyle: TextStyle(color: Colors.white),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blue[400],
                              )),
                        ),
                        obscureText: !_showPassword,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      DropdownButtonFormField(
                        validator: (value) =>
                            value == "Select" ? 'Field required' : null,
                        value: _selectorg,
                        onChanged: (val) => setState(() => _selectorg = val),
                        items: list.map(
                          (item) {
                            return DropdownMenuItem(
                              child: Text('$item'),
                              value: item,
                            );
                          },
                        ).toList(),
                        hint: Text("SELECT ORGANISATION",
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      RaisedButton(
                          color: Colors.white,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((user) async {
                                checkpass = await check();
                                print(checkpass);

                                if (checkpass == false || checkpass == null) {
                                  Database().signinteacher(
                                      FirebaseAuth.instance.currentUser.uid,
                                      context,
                                      _selectorg);
                                  save(_selectorg);
                                  Navigator.of(_ctx).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                    return new ChangePassword(
                                      email: email,
                                      organisation: _selectorg,
                                    );
                                  }));
                                } else {
                                  Navigator.of(context)
                                      .pushNamed('/TeacherHomePage');
                                }
                              }).catchError((e) {
                                print(Errors.show(e.code));
                                _showDialogue("Error",Errors.show(e.code));
                              });
                            }
                          }),
                      FlatButton(
                        color: Colors.black54,
                        child: Text(
                          'Not a Member Yet? Sign Up Here.',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          Navigator.pushNamed(_ctx, '/Register');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
