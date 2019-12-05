import 'package:glores/signUpBusiness.dart';
import 'package:glores/signUpUser.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My firebase app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            onPressed: navigateToRegisteUser,
            child: Text('Customer'),
          ),
          RaisedButton(
            onPressed: navigateToRegisterBusiness,
            child: Text('Business Owner'),
          ),
        ],
      ),
    );
  }

  void navigateToRegisteUser(){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUserPage(), fullscreenDialog: true));
  }

  void navigateToRegisterBusiness(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterBusinessPage(), fullscreenDialog: true));
  }
}
