import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rave/flutter_rave.dart';
import 'package:glores/login.dart';
import 'package:glores/profileBusiness.dart';

class NavBar extends StatefulWidget {
  NavBar({this.uid});
  final String uid;
  @override
  NavBarState createState() => new NavBarState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class NavBarState extends State<NavBar> {
    int currentTab = 0;
  HomeScreen home = HomeScreen();
  Notifications notifications = new Notifications();
    List<Widget> pages;
    Widget currentPage;

  @override
  void initState() {
    this.getCurrentUser();
    super.initState();
    pages = [home, notifications];
    currentPage = home;
  }
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
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
            icon: new Icon(Icons.home),
            title: new Text("Home")),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.notifications), title: new Text("Notifications")),
      ],
    );

    return new Scaffold(
      bottomNavigationBar: navBar,
      body: currentPage,
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({this.uid});
  final String uid;
  @override
  _HomeScreenState createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<IconData> _icons = [
    FontAwesomeIcons.plane,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.walking,
    FontAwesomeIcons.biking,
  ];
  int currentTab = 0;

  List<Widget> pages;
  Widget currentPage;
  
  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  Future<String> getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    print('++++++++++++++++++++++++++++++' + currentUser.uid);
    return currentUser.uid;
  }

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          if (_selectedIndex == 0) {
            print('plane');
          }
        });
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Theme.of(context).accentColor
              : Color(0xFFE7EBEE),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          _icons[index],
          size: 25.0,
          color: _selectedIndex == index
              ? Theme.of(context).primaryColor
              : Color(0xFFB4C1C4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Glores",
          style: TextStyle(color: Colors.white),
        ),
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
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 120.0, top: 5.0),
          child: Text(
            'What would you like to find?',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _icons
              .asMap()
              .entries
              .map(
                (MapEntry map) => _buildIcon(map.key),
              )
              .toList(),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("users").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    if (document['business'] != -1) {
                      return new Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                            height: 170.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 120.0,
                                        child: Text(
                                          document['businessName'],
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '\$200',
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'per pax',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Restauratnt',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  _buildRatingStars(5),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              380),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            DatePicker.showDateTimePicker(
                                                context,
                                                showTitleActions: true,
                                                minTime: DateTime(2018, 3, 5),
                                                maxTime: DateTime(2019, 6, 7),
                                                onConfirm: (date) {
                                              print('confirm $date');
                                              Firestore.instance
                                                  .collection("users")
                                                  .document(document['uid'])
                                                  .collection('events')
                                                  .add({
                                                    "eventTime": "${date}",
                                                    "eventFrom":
                                                        currentUser.email,
                                                    "eventState": true,
                                                    "eventAnswer": false,
                                                    "uidFrom": currentUser.uid,
                                                    "businessFrom":
                                                        document['businessName']
                                                  })
                                                  .then((result) => {
                                                        _pay(context),
                                                      })
                                                  .catchError(
                                                      (err) => print(err));
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.en);
                                          },
                                          child: Text("Book now"),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20.0,
                            top: 15.0,
                            bottom: 15.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                width: 110.0,
                                image: AssetImage('assets/images/hotel1.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else
                      return Visibility(visible: false, child: Text(''));
                  }).toList(),
                );
            }
          },
        )),

      ]),
    );
  }

  _pay(BuildContext context) {
    final snackBar_onFailure = SnackBar(content: Text('Transaction failed'));
    final snackBar_onClosed = SnackBar(content: Text('Transaction closed'));
    final _rave = RaveCardPayment(
      isDemo: true,
      encKey: "f385f2a9630877d6e6c295f9",
      publicKey: "FLWPUBK-9a4d6e5d7df7e6edf0efe5a2f2f58132-X",
      transactionRef: "FLWSECK-f385f2a96308ec1273b401e5fca38443-X",
      amount: 100,
      email: "joan.kabello@gmail.com",
      onSuccess: (response) {
        print("$response");
        print("Transaction Successful");
        if (mounted) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Transaction Sucessful!"),
              backgroundColor: Colors.green,
              duration: Duration(
                seconds: 5,
              ),
            ),
          );
        }
      },
      onFailure: (err) {
        print("$err");
        print("Transaction failed");
        Scaffold.of(context).showSnackBar(snackBar_onFailure);
      },
      onClosed: () {
        print("Transaction closed");
        Scaffold.of(context).showSnackBar(snackBar_onClosed);
      },
      context: context,
    );
    _rave.process();
  }
}

class Notifications extends StatefulWidget {
  Notifications({this.uid});
  final String uid;
  @override
  NotificationsState createState() => new NotificationsState();
}

class NotificationsState extends State<Notifications> {
   @override
  void initState() {
    this.getCurrentUser();
    super.initState();
  }
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
            appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
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
      body: Column(
        children: <Widget>[
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150, minHeight: 50.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("users")
                  .document(currentUser.uid)
                  .collection('events')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            visible: document['eventAnswer'],
                            child: Card(
                                child: Container(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(document['eventAccept']
                                            ? 'Reservation from ${document['businessFrom']} ACCEPTED'
                                            : 'Reservation from ${document['businessFrom']} CANCELED'),
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                Firestore.instance
                                                    .collection("users")
                                                    .document(currentUser.uid)
                                                    .collection('events')
                                                    .document(
                                                        document.documentID)
                                                    .updateData(
                                                        {"eventAnswer": false})
                                                    .then((result) => {
                                                          print(
                                                              "${currentUser.email}"),
                                                        })
                                                    .catchError(
                                                        (err) => print(err));
                                              });
                                            },
                                            child: Text("OK")),
                                      ],
                                    ))));
                      }).toList(),
                    );
                }
              },
            ))
        ],
      ),
    );
  }
}