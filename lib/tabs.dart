import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kemu_alumni/chat.dart';
import 'package:kemu_alumni/contributions.dart';
import 'package:kemu_alumni/events.dart';
import 'package:kemu_alumni/loginUI/auth.dart';
import 'package:kemu_alumni/profile.dart';
import 'package:kemu_alumni/rsvp.dart';
import 'dart:ui';
import 'loginUI/home.dart';
import 'loginUI/loginSignup.dart';
import 'loginUI/root.dart';
import 'newEvent.dart';

class tabView extends StatefulWidget {
  tabView({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;


  @override
  _tabViewState createState() => _tabViewState();
}

class _tabViewState extends State<tabView> with SingleTickerProviderStateMixin {

  TabController controller;
  String _email;
  String id;
  String _password;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _signOut() async {
    await _firebaseAuth.signOut();
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new RootPage(auth: new Auth())
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
      appBar: new AppBar(
        backgroundColor: Colors.pink[900],
        centerTitle: true,
        title: Text(
          "KeMU - AA",
          textAlign: TextAlign.center,
        ),

        actions: <Widget>[

          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              new IconButton(icon: new Icon(Icons.chat,
                color: Colors.white,)
                  , onPressed: (){
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new Chat()
                    ));
                  }),

            ],
          ),
          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              PopupMenuButton(
                icon: new Icon(Icons.person, color: Colors.white,),
                onSelected: (String value) {
                  switch (value) {
                    case 'logout':
                      _signOut();
                      break;
                  // Other cases for other menu options
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: "logout",
                    child: Row(
                      children: <Widget>[
                        Text("LOGOUT"),
                        Icon(Icons.exit_to_app, color: Colors.pink[900],),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: <Widget>[
            new DrawerHeader(decoration: new BoxDecoration(
              color: Colors.pink[900],
            ),
              child: new Center(
                child: new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: <Widget>[
                      new Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          new Container(
                            height: 100.0,
                            width: 200.0,
                            child: new Image.asset("assets/logo.png"),
                          )

                        ],
                      ),
                    ],
                  ),
                ),
              ),),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.group),
              title: new Text("Admin"),
              onTap: (){
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Staff()
                ));
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.assignment),
              title: new Text("My RSVPs"),
              onTap: (){
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new myRsvp()
                ));
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.border_color),
              title: new Text("My Votes"),
              onTap: (){
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new myVotes()
                ));
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.monetization_on),
              title: new Text("My Contributions"),
              onTap: (){
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Receipts()
                ));
              },
            ),
          ],
        ),
      ),

      body: new TabBarView(
        // Add tabs as widgets
        children: <Widget>[new Home(),  new newEvents(), new Profile(), ],
        // set the controller
        controller: controller,
      ),
      // Set the bottom navigation bar
      bottomNavigationBar: new Material(
        // set the color of the bottom navigation bar
        color: Colors.pink[900],
        // set the tab bar as the child of bottom navigation bar
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              text: 'Home',// set icon to the tab
              icon: new Icon(Icons.home),
            ),
            new Tab(
              text: 'Events',
              icon: new Icon(Icons.forum),
            ),
            new Tab(
              text: 'Profile',
              icon: new Icon(Icons.person),
            ),

          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }
}