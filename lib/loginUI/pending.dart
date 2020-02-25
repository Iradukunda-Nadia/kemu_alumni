import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kemu_alumni/loginUI/auth.dart';

class Pending extends StatefulWidget {
  Pending({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Your Registration is Pending Approval"),
        ),
      ),
    );
  }
}


class Denied extends StatefulWidget {

  @override
  _DeniedState createState() => _DeniedState();
}

class _DeniedState extends State<Denied> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Your Registration has been suspended."),
                Text("Contact admin for more information."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
