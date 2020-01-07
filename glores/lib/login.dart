import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glores/home.dart';
import 'package:glores/screens/home_screen.dart';
import 'package:glores/welcome.dart';
import 'package:glores/profileBusiness.dart';

FirebaseUser currentUser;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  FirebaseUser currentUser;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    this.getCurrentUser();
    super.initState();
  }
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
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

  String pwdIncorrect() {
    return 'Password is incorrect';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                Image.asset('assets/images/logo.png', width: MediaQuery.of(context).size.width / 2, height: MediaQuery.of(context).size.height / 2,),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Email*',
                        hintText: "name.lastname@gmail.com",
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Password*',
                        hintText: "********",
                        icon: new Icon(
                          Icons.email,
                          color: Colors.grey,
                        )),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  RaisedButton(
                    child: Text("Sign In"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                            .then((currentUser) => Firestore.instance
                                .collection("users")
                                .document(currentUser.uid)
                                .get()
                                .then((DocumentSnapshot result) =>
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                checkRole(result))))
                                .catchError((err) => print(err)))
                            .catchError((err) => pwdIncorrect);
                      }
                    },
                  ),
                  Text("Don't have an account yet?"),
                  FlatButton(
                    child: Text("Register here!", style: TextStyle(color: Theme.of(context).primaryColor),),
                    onPressed: () {
                      Navigator.pushNamed(context, '/welcome');
                    },
                  )
                ],
              ),
            ))));
  }

  Widget checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: Text(
            'no data set in the userId document in firestore ${snapshot.data}'),
      );
    }
    if (snapshot.data['business'] == -1) {
      return userPage(snapshot);
    } else {
      return adminPage(snapshot);
    }
  }

  Reservations adminPage(DocumentSnapshot snapshot) {
    return Reservations();
  }

  NavBar userPage(DocumentSnapshot snapshot) {
    return NavBar();
  }
}
