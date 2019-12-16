import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_view_widget/calendar_view_widget.dart';
import 'dart:async';

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StreamController<List<Map<String, String>>> eventsController =
      new StreamController();

  @override
  void dispose() {
    eventsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const eventList = [
      {
        'name': 'Event (null location)',
        'location': null,
        'date': '2019-09-27 13:27:00',
        'id': '1',
      },
      {
        'name': null,
        'location': 'Suite 501',
        'date': '2019-09-21 14:35:00',
        'id': '2',
      },
      {
        'name': 'Event null date',
        'location': '1200 Park Avenue',
        'date': null,
        'id': '3',
      },
      {
        'name': 'Event null id',
        'location': 'Grand Ballroom',
        'date': '2019-08-27 13:27:00',
        'id': null,
      },
      {
        'name': 'Event 4',
        'location': 'Grand Ballroom',
        'date': '2019-08-27 13:27:00',
        'id': '4',
      },
      {
        'name': 'Event 5',
        'location': 'Suite 501',
        'date': '2019-10-21 14:35:00z',
        'id': '5',
      },
      {
        'name': 'Event 6',
        'location': '1200 Park Avenue',
        'date': '2019-08-22 05:49:00',
        'id': '6',
      },
      {
        'name':
            'Handle really long names in the event list so it does not break',
        'location': '1200 Park Avenue',
        'date': '2019-10-24 05:49:00',
        'id': '7',
      },
      {
        'name': 'Event 8',
        'location':
            'Handle really long locations in the event list so it does not break',
        'date': '2019-10-24 05:49:00z',
        'id': '8',
      },
    ];

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
    eventsController.add(eventList);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Reservations'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CalendarView(
              eventStream: eventsController.stream,
              onEventTapped: onEventTapped,
              titleField: 'name',
              detailField: 'location',
              dateField: 'date',
              separatorTitle: 'Events',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}