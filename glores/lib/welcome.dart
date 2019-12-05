import 'package:glores/sign_up.dart';
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
            onPressed: navigateToSignIn,
            child: Text('Customer'),
          ),
          RaisedButton(
            onPressed: navigateToSignUp,
            child: Text('Business Owner'),
          ),
        ],
      ),
    );
  }

  void navigateToSignIn(){
  }

  void navigateToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(), fullscreenDialog: true));
  }
}
