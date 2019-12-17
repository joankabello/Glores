import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glores/login.dart';
import 'package:calendar_view_widget/calendar_view_widget.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
 
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};
 
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.uid}) : super(key: key);
   final String uid;

  final String title;
 
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> {
 
  StreamController<List<Map<String, String>>> eventsController =
      new StreamController();
 
  @override
  initState() {
    this.getCurrentUser();
    super.initState();

  }

  Future getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    print('++++++++++++++++++++++++++++++'+currentUser.uid);
    return currentUser.uid;
  }

  @override
  void dispose() {
    eventsController.close();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection('events')
        .getDocuments()
        .then((QuerySnapshot sn) {
          var l = new List();
          List<DocumentSnapshot> templist;
          List<Map<String, String>> list = new List();
 
          templist = sn.documents;
          list = templist.map((DocumentSnapshot docSnapshot){
            Map<String, String> x = docSnapshot.data.cast<String, String>();
            return x;
            }).toList();
          eventsController.add(list);
    });
 
    final theme = ThemeData.dark().copyWith(
      primaryColor: Colors.grey,
      accentColor: Colors.lightBlue,
      canvasColor: Colors.white,
      backgroundColor: Colors.lightBlue,
      dividerColor: Colors.blueGrey,
      textTheme: ThemeData.dark().textTheme.copyWith(
            display1: TextStyle(
              fontSize: 21.0,
            ),
            subhead: TextStyle(
              fontSize: 14.0,
              color: Colors.blueGrey,
            ),
            headline: TextStyle(
              fontSize: 18.0,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
            title: TextStyle(
              fontSize: 14.0,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
      accentTextTheme: ThemeData.dark().accentTextTheme.copyWith(
            body1: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            title: TextStyle(
              fontSize: 21.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            display1: TextStyle(
              fontSize: 21.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
    );
 
    void onEventTapped(Map<String, String> event) {
      print(event);
    }
//    eventsController.add(eventList);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Reservations',style: TextStyle(color: Colors.white),),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CalendarView(
              eventStream: eventsController.stream,
              onEventTapped: onEventTapped,
              titleField: 'eventFrom',
              // detailField: 'eventAnswer',
              dateField: 'eventTime',
              separatorTitle: 'Events',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}