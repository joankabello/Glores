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
        title: Text(
          'Glores',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/logo.png', width: MediaQuery.of(context).size.width / 2, height: MediaQuery.of(context).size.height / 2,),
          Center(
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: navigateToRegisteUser,
              child: Text('Register as Customer'),
            ),
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: navigateToRegisterBusiness,
            child: Text('Register as Business'),
          ),
        ],
      ),
    );
  }

  void navigateToRegisteUser() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterUserPage(), fullscreenDialog: true));
  }

  void navigateToRegisterBusiness() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterBusinessPage(),
            fullscreenDialog: true));
  }
}
