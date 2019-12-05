import 'package:glores/signUpUser.dart';
import 'package:glores/splash.dart';
import 'package:glores/welcome.dart';
import 'package:flutter/material.dart';
import 'package:glores/home.dart';
import 'package:glores/signUpBusiness.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        ),
        home: WelcomePage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(title: 'Home'),
          '/registerUser': (BuildContext context) => RegisterUserPage(),
          '/registerBussines': (BuildContext context) => RegisterBusinessPage(),
        });
  }
}