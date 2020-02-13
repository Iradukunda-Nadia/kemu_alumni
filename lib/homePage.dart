import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kemu_alumni/loginUI/auth.dart';
import 'package:kemu_alumni/loginUI/home.dart';
import 'package:kemu_alumni/loginUI/pending.dart';
import 'package:kemu_alumni/tabs.dart';


enum AuthStatus {
  APPROVED,
  DECLINED,
  PENDING,
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String email;
  String state;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loginCommand();
  }


  _loginCommand() async {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        email = user.uid.toString();
      });
    });
    var collectionReference = Firestore.instance.collection('users');
    var query = collectionReference.where("name", isEqualTo: email );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length == 0) {
        final snack = SnackBar(
          content: Text('invallid login details'),
        );
        scaffoldKey.currentState.showSnackBar(snack);
      } else {
        querySnapshot.documents.forEach((document)
        async {
          setState(() {
            state = document['status'];

          });


          if( state == "pending" ) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Pending()
            ));
          }


          if( state == "approved") {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new tabView()
            ));

          }


        });
      }
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: Colors.purple[100],
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: new NetworkImage(
                  'https://www.nation.co.ke/image/view/-/5331682/highRes/2480738/-/118vdcs/-/Meth.jpg',
                ),
              ),
            ),
          ),
          Center(
          child:CircularProgressIndicator(),
          ),
        ],

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildWaitingScreen()
    );
  }
}
