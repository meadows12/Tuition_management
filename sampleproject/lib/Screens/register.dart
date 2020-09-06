import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:sampleproject/services/database.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  BuildContext _ctx;
  final _formKey = new GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;

  String error = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String email = " ";
  String password = " ";
  String name = " ";
  String phone = " ";
  String address = " ";

  TextEditingController firstNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController mobileNoInputController;
  TextEditingController referCodeInputController;
  TextEditingController addressInputController;

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

  String confirmPwdValidator(String val) {
    if (val.isEmpty) return 'Empty';
    if (val != pwdInputController.text) return "Password Dosen't Match";
    return null;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
  }

  void _changePassword(String password) async {
    //Create an instance of the current user.
    User user = await FirebaseAuth.instance.currentUser;

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: 30.0, right: 30, left: 30, bottom: 100),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val.length < 3) {
                          return "Enter a Valid First Name";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Organisation Name",
                          hintText: "JHA classes",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      controller: firstNameInputController,
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) => val.length != 10
                          ? "Enter a 10 Digit Mobile Number"
                          : null,
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue[400],
                          ),
                          labelText: "10 Digit Mobile Number(for OTP)",
                          hintText: "94XXXXXX12",
                          labelStyle: TextStyle(color: Colors.white)),
                      controller: mobileNoInputController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) => emailValidator(val),
                      controller: emailInputController,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.blue[400],
                          ),
                          labelText: "Email ID",
                          hintText: "john.doe@gmail.com",
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) => pwdValidator(val),
                      controller: pwdInputController,
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
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      obscureText: !_showPassword,
                    ),
                    TextFormField(
                      // validator: (val) => addressInputController(val),
                      controller: addressInputController,
                      onChanged: (value) {
                        setState(() {
                          address = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue[400],
                          ),
                          labelText: "Address",
                          hintText: "Address",
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) => confirmPwdValidator(val),
                      controller: confirmPwdInputController,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue[400],
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showConfirmPassword = !_showConfirmPassword;
                                });
                              },
                              child: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blue[400],
                              )),
                          labelText: "Confirm Password",
                          hintText: "********",
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      obscureText: !_showConfirmPassword,
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.black54),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.black),
              ),
              padding: const EdgeInsets.all(20.0),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password)
                      .then((signinuser) {
                    Database().storeneworganisation(
                        email, address, context, name, phone);
                  }).catchError((e) {
                    print(e);
                  });
                }
              },
              splashColor: Colors.grey,
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
            FlatButton(
              color: Colors.black54,
              child: Text(
                'Already Have An Account? Login Here!',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.pushNamed(_ctx, '/SignIn');
              },
            ),
          ],
        ),
      ),
    );
  }
}
