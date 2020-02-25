import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class myRsvp extends StatefulWidget {
  @override
  _myRsvpState createState() => _myRsvpState();
}

final db = Firestore.instance;

class _myRsvpState extends State<myRsvp> {
  @override

  String email;

  Future getUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      email= user.email;
    });
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY RSVPs'),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),

      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('rsvp').where("name", isEqualTo: email).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return GestureDetector(
                        onTap: (){},
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(doc.data['event'], style: TextStyle(fontSize: 18),),
                            subtitle: Text(doc.data['date'], style: TextStyle(fontSize: 12),),
                            trailing: new Icon(Icons.turned_in),

                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}

class myVotes extends StatefulWidget {
  @override
  _myVotesState createState() => _myVotesState();
}


class _myVotesState extends State<myVotes> {
  @override

  String email;

  Future getUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      email= user.email;
    });
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My vote'),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),

      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('votes').where("name", isEqualTo: email).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return GestureDetector(
                        onTap: (){},
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text("Chair person:", style: TextStyle(fontSize: 12),),
                                subtitle: Text("${doc.data['Chairperson']}"),
                              ),
                              ListTile(
                                title: Text("Assistant Chair person:", style: TextStyle(fontSize: 12),),
                                subtitle: Text("${doc.data['Assistant']}"),
                              ),
                              ListTile(
                                title: Text("Secretary:", style: TextStyle(fontSize: 12),),
                                subtitle: Text("${doc.data['Secretary']}"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}
