import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class approvedUser extends StatefulWidget {
  @override
  _approvedUserState createState() => _approvedUserState();
}

class _approvedUserState extends State<approvedUser> {
  var reason = TextEditingController();
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
                            title: Text(doc.data['name'], style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 12 : 20),),
                            subtitle: Text("Date Created: ${doc.data['date']}", style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 12 : 20),),
                            trailing: Container(
                              width: MediaQuery.of(context).orientation == Orientation.portrait ? 60 : 100,
                              height: MediaQuery.of(context).orientation == Orientation.portrait ? 20 : 40,
                              child: RaisedButton(
                                  child: Text("Suspend",style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.portrait ? 6 : 14, color: Colors.white),

                                  ),
                                  color: Colors.pink[900],
                                onPressed: () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoActionSheet(
                                            title: Text(
                                                "Enter a reason for suspending this user"),
                                            message: Column(
                                              children: <Widget>[
                                                CupertinoTextField(
                                                  controller: reason,
                                                  placeholder: 'reason',
                                                ),

                                              ],
                                            ),
                                            actions: <Widget>[
                                              CupertinoButton(
                                                child: Text("Suspend"),
                                                onPressed: () async {
                                                  await db
                                                      .collection('users')
                                                      .document(doc.documentID)
                                                      .updateData({
                                                    'status': "suspended",
                                                    'reason': reason.text,
                                                  });
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("User Suspended"),
                                                          content: Text("This user has been Suspended"),
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
                                                },
                                              )
                                            ],
                                          ));

                                },),
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