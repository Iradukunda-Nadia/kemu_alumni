import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class approvedUser extends StatefulWidget {
  @override
  _approvedUserState createState() => _approvedUserState();
}

class _approvedUserState extends State<approvedUser> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App users")),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('users').where("status", isEqualTo: "approved").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return GestureDetector(
                        onTap: (){},
                        child: ListTile(
                            leading: CircleAvatar(
                              child: new Icon(Icons.person),
                            ),
                            title: Text(doc.data['name'], style: TextStyle(fontSize: 12),),

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