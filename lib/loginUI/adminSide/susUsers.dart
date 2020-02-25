import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Suspended extends StatefulWidget {
  @override
  _SuspendedState createState() => _SuspendedState();
}

class _SuspendedState extends State<Suspended> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Suspended users"),
        backgroundColor: Colors.pink[900],),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('users').where("status", isEqualTo: "suspended").snapshots(),
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
                            trailing: Container(
                              width: 60,
                              height: 20,
                              child: RaisedButton(
                                  child: Text("Approve",style: TextStyle(fontSize: 6, color: Colors.white),

                                  ),
                                  color: Colors.pink[900],
                                  onPressed: () async{

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text("Approve this user?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Yes"),
                                              onPressed: () async{
                                                await db
                                                    .collection('users')
                                                    .document(doc.documentID)
                                                    .updateData({
                                                  'status': "approved",
                                                });
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("User Approved"),
                                                        content: Text("This user has been Approved"),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text("Close"),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }, ),
                                            FlatButton(
                                              child: Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],

                                        );
                                      },

                                    );
                                  }),
                            )

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