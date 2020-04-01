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
      appBar: AppBar(title: Text("Approved users"),
      backgroundColor: Colors.pink[900],),
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
                            trailing: Container(
                              width: MediaQuery.of(context).orientation == Orientation.portrait ? 60 : 100,
                              height: MediaQuery.of(context).orientation == Orientation.portrait ? 20 : 40,
                              child: RaisedButton(
                                  child: Text("Suspend",style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 6 : 14, color: Colors.white),

                                  ),
                                  color: Colors.pink[900],
                                  onPressed: () async{

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text("Suspend this user?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Yes"),
                                              onPressed: () async{
                                                await db
                                                    .collection('users')
                                                    .document(doc.documentID)
                                                    .updateData({
                                                  'status': "suspended",
                                                });
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Suspended"),
                                                        content: Text("This user has been suspended"),
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