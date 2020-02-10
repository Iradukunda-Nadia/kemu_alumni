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
  Denied({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _DeniedState createState() => _DeniedState();
}

class _DeniedState extends State<Denied> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Your Registration is Denied"),
        ),
      ),
    );
  }
}
