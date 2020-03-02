import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Elect extends StatefulWidget {
  @override
  _ElectState createState() => _ElectState();
}

class _ElectState extends State<Elect> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Candidates"),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),
      body: ListView(
        padding: EdgeInsets.all(5.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('candidates').orderBy("cat").snapshots(),
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
                            subtitle: Text(doc.data['cat'], style: TextStyle(fontSize: 12),),
                          trailing: Text(doc.data['votes'].toString(), style: TextStyle(fontSize: 12),),
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
