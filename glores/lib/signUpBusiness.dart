import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glores/login.dart';
import 'package:glores/profileBusiness.dart';
import 'package:glores/screens/home_screen.dart';
import 'package:glores/welcome.dart';
import 'package:glores/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterBusinessPage extends StatefulWidget {
  RegisterBusinessPage({Key key}) : super(key: key);

  @override
  _RegisterBusinessPageState createState() => _RegisterBusinessPageState();
}

class _RegisterBusinessPageState extends State<RegisterBusinessPage> {
  //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _value = 0;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    firstNameInputController = TextEditingController();
    lastNameInputController = TextEditingController();
    emailInputController = TextEditingController();
    pwdInputController = TextEditingController();
    confirmPwdInputController = TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'First Name*', hintText: "John"),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value.length < 3) {
                        return "Please enter a valid first name.";
                      }
                    },
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Last Name*', hintText: "Doe"),
                      controller: lastNameInputController,
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter a valid last name.";
                        }
                      }),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*', hintText: "john.doe@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password*', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  Padding(
                    padding: EdgeInsets.all(11.0),
                  ),
                  Text(
                    "Bussines Type:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                  ),
                  DropdownButton(
                    hint: Text('Select'),
                    value: _value,
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        child: Text(
                          'Hotel',
                        ),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text('Bar'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Restaurant',
                        ),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Barbershop',
                        ),
                        value: 3,
                      ),
                    ],
                    onChanged: (int value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Register"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                            .then((currentUser) => Firestore.instance
                                .collection("users")
                                .document(currentUser.uid)
                                .setData({
                                  "uid": currentUser.uid,
                                  "fname": firstNameInputController.text,
                                  "surname": lastNameInputController.text,
                                  "email": emailInputController.text,
                                  "bussines": _value,
                                })
                                .then((result) => {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Reservations()),
                                          (_) => false),
                                      firstNameInputController.clear(),
                                      lastNameInputController.clear(),
                                      emailInputController.clear(),
                                      pwdInputController.clear(),
                                      confirmPwdInputController.clear()
                                    })
                                .catchError((err) => print(err)))
                            .catchError((err) => print(err));
                      }
                    },
                  ),
                  Text("Already have an account?"),
                  FlatButton(
                    child: Text("Login here!"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true));
                    },
                  )
                ],
              ),
            ))));
  }
}
