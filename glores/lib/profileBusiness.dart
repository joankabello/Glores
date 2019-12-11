import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glores/reservationBusiness.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_alert/easy_alert.dart';

class ReservationsCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Reservations(),
    );
  }
}

class Reservations extends StatefulWidget {
  @override
  ReservationsState createState() => new ReservationsState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class ReservationsState extends State<Reservations> {
  int currentTab = 0;
  MyHomePage pageOne = new MyHomePage();
  ProfileState profile = new ProfileState();
  PageThree pageThree = PageThree();
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    pages = [pageOne, profile, pageThree];
    currentPage = pageOne;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar navBar = new BottomNavigationBar(
      currentIndex: currentTab,
      onTap: (int numTab) {
        setState(() {
          print("Current tab: " + numTab.toString());
          currentTab = numTab;
          currentPage = pages[numTab];
        });
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text("Reservations")),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.person), title: new Text("Profile")),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.chat), title: new Text("Chat"))
      ],
    );

    return new Scaffold(
      bottomNavigationBar: navBar,
      body: currentPage,
    );
  }
}

class ProfileState extends StatefulWidget {
  ProfileState({Key key, this.title, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  Profile createState() => Profile();
}

class Profile extends State<ProfileState> {
  FirebaseUser currentUser;
  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  bool value;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Hero(
        tag: "assets/images/hotel0.jpg",
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image(
            image: AssetImage("assets/images/hotel0.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Expanded(
          child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users")
            .document("8u6LklyqD2dXIJmLZdWMnSacS783")
            .collection('events')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new Visibility(
                      visible: document['eventState'],
                      child: Card(
                          child: Container(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                children: <Widget>[
                                  Text('You have a reservation'),
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          print('before dialog $value');
                                          _asyncConfirmDialog(
                                              context, document);
                                        });
                                      },
                                      child: Text("See More")),
                                ],
                              ))));
                }).toList(),
              );
          }
        },
      ))
    ]);
  }

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, DocumentSnapshot document) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Reservation'),
          content:
              Text('from ${document['eventFrom']} at ${document['eventTime']}'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                print(value);
                Navigator.of(context).pop(ConfirmAction.CANCEL);
                setState(() {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .collection('events')
                      .document(document.documentID)
                      .updateData({"eventState": false, "eventAccept": false})
                      .then((result) => {
                            print("${currentUser.email}"),
                          })
                      .catchError((err) => print(err));
                });
                print(value);
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
                setState(() {
                      Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .collection('events')
                      .document(document.documentID)
                      .updateData({"eventState": false, "eventAccept": true})
                      .then((result) => {
                            print("${currentUser.email}"),
                          })
                      .catchError((err) => print(err));
                      });
              },
            )
          ],
        );
      },
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(child: new Text("Page three"));
  }
}
