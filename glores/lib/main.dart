import 'package:glores/models/Buses.dart';
import 'package:glores/reservationBusiness.dart';
import 'package:glores/signUpUser.dart';
import 'package:glores/profileBusiness.dart';
import 'package:glores/welcome.dart';
import 'package:flutter/material.dart';
import 'package:glores/home.dart';
import 'package:glores/signUpBusiness.dart';
import 'package:glores/login.dart';
import 'package:glores/screens/home_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        primaryColor: Color(0xFF3EBACE),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
        ),
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeScreen(),
          '/welcome': (BuildContext context) => WelcomePage(),
          '/registerUser': (BuildContext context) => RegisterUserPage(),
          '/registerBussines': (BuildContext context) => RegisterBusinessPage(),
          '/reservation': (BuildContext context) => Reservations(),
          '/login': (BuildContext context) => LoginPage(),

        });
  }
}