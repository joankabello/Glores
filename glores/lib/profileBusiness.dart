import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glores/login.dart';
import 'package:glores/reservationBusiness.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';


class Reservations extends StatefulWidget {
  Reservations({this.uid});
  final String uid;
  @override
  ReservationsState createState() => new ReservationsState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class ReservationsState extends State<Reservations> {
  int currentTab = 2;
  MyHomePage pageOne = new MyHomePage();
  ProfileState profile = new ProfileState();
  PageThree pageThree = PageThree();
  List<Widget> pages;
  Widget currentPage;
  Future<String> getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser.uid;
  }

  @override
  void initState() {
    this.getCurrentUser();
    super.initState();
    pages = [pageOne, profile, pageThree];
    currentPage = pageThree;
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
            icon: new Icon(Icons.chat), title: new Text("Inbox"))
      ],
    );

    return new Scaffold(
      bottomNavigationBar: navBar,
      body: currentPage,
    );
  }
}

class ProfileState extends StatefulWidget {
  ProfileState({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;
  @override
  Profile createState() => Profile();
}

class Profile extends State<ProfileState> {
  String _imageUrl; 
  @override
  initState() {
    this.getCurrentUser();
    super.initState();

     var ref = FirebaseStorage.instance.ref().child("${currentUser.email}/profile");
     ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));

     }

  Future<String> getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    print('++++++++++++++++++++++++++++++' + currentUser.uid);
    return currentUser.uid;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool value;

  @override
  Widget build(BuildContext context) {
    print('----------------------------' + getCurrentUser().toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            FlatButton(
              child: Text("Log Out"),
              textColor: Colors.white,
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((result) =>
                        Navigator.pushReplacementNamed(context, '/login'))
                    .catchError((err) => print(err));
              },
            )
          ],
        ),
        body: Column(children: <Widget>[
          Hero(
            tag: "assets/images/hotel0.jpg",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: _imageUrl == null ? Image.asset('assets/images/hotel0.jpg')
                :Image.network(_imageUrl,fit: BoxFit.cover,)
              // child: Image(
              //   image: AssetImage("assets/images/hotel0.jpg"),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("users")
                .document(currentUser.uid)
                .collection('events')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return new Visibility(
                          visible: document['eventState'] == null ? false : document['eventState'],
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
        ]));
  }

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, DocumentSnapshot document) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Reservation'),
          content: Text(
              'from ${document['eventFrom']} in ${document['eventTime'].toString().substring(0, document['eventTime'].toString().length - 13)} at ${document['eventTime'].toString().substring(10, document['eventTime'].toString().length - 7)}'),
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
                  Firestore.instance
                      .collection("users")
                      .document(document["uidFrom"])
                      .collection('events')
                      .add({
                        "eventAnswer": true,
                        "eventAccept": false,
                        'businessFrom': document['businessFrom']
                      })
                      .then((result) => {
                            print("${currentUser.email}"),
                          })
                      .catchError((err) => print(err));
                  final MailOptions mailOptions = MailOptions(
                    body:
                        'Hello, Your reservation in ${document['eventTime'].toString().substring(0, document['eventTime'].toString().length - 13)} at ${document['eventTime'].toString().substring(10, document['eventTime'].toString().length - 7)} was CANCELED from ${currentUser.email}',
                    subject: 'Reservation Canceled',
                    recipients: ['${document['eventFrom']}'],
                    isHTML: true,
                  );

                  FlutterMailer.send(mailOptions);
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
                  Firestore.instance
                      .collection("users")
                      .document(document["uidFrom"])
                      .collection('events')
                      .add({
                        "eventAnswer": true,
                        "eventAccept": true,
                        'businessFrom': document['businessFrom']
                      })
                      .then((result) => {
                            print("${currentUser.email}"),
                          })
                      .catchError((err) => print(err));
                  final MailOptions mailOptions = MailOptions(
                    body:
                        'Hello, Your reservation in ${document['eventTime'].toString().substring(0, document['eventTime'].toString().length - 13)} at ${document['eventTime'].toString().substring(10, document['eventTime'].toString().length - 7)} was ACCEPTED from ${currentUser.email}',
                    subject: 'Reservation Accepted',
                    recipients: ['${document['eventFrom']}'],
                    isHTML: true,
                  );
                  FlutterMailer.send(mailOptions);
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
    return new Scaffold(
        appBar: AppBar(
          title: Text('Inbox', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            FlatButton(
              child: Text("Log Out"),
              textColor: Colors.white,
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((result) =>
                        Navigator.pushReplacementNamed(context, '/login'))
                    .catchError((err) => print(err));
              },
            )
          ],
        ),
        body: new Center(child: new Text("Coming Soon ...")),
    );
  }
}
