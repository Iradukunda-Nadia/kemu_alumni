import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class newEvents extends StatefulWidget {
  @override
  _newEventsState createState() => _newEventsState();
}

class _newEventsState extends State<newEvents> {
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("events").getDocuments();
    return qn.documents;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: new Column(
        children: <Widget>[

          new Flexible(
            child: FutureBuilder(
                future: getUsers(),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading... Please wait"),
                    );
                  }if (snapshot.data == null){
                    return Center(
                      child: Text("The are no saved events"),);
                  }else{
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: new Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 200,
                                  height: 300.0,
                                  decoration: BoxDecoration(
                                      color: Colors.pink[50],
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(color: Colors.grey.withOpacity(.3), width: .2)),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      Image.network(snapshot.data[index].data["image"], width: 281.0, height: 191.0),
                                      Text(snapshot.data[index].data["title"], style: TextStyle(fontSize: 24.0, fontFamily: "Raleway",color: Colors.white)),
                                      Text(snapshot.data[index].data["date"], style: TextStyle(fontSize: 12.0, fontFamily: "Raleway")),
                                      Container(
                                        width: MediaQuery.of(context).size.width * .3,
                                        height: 18,
                                        child: RaisedButton(
                                          child: Text(
                                            "RSVP",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .apply(color: Colors.white, fontSizeDelta: 2),

                                          ),
                                          color: Colors.pink[900],

                                          onPressed: () async {
                                            FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                            await Firestore.instance
                                                .collection("rsvp")
                                                .add({
                                              "event": snapshot.data[index].data["title"],
                                              "date": snapshot.data[index].data["date"],
                                              "status": "RSVP",
                                              "name": user.email,
                                            }).then((result) =>
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    // return object of type Dialog
                                                    return AlertDialog(
                                                      content: new Text("You have RSVP'd, See you then"),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        new FlatButton(
                                                          child: new Text("close"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                )
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),

                                    ],
                                  ),
                                ),
                              )
                          ),
                        );

                      },
                    );

                  }
                }),)
        ],
      ),
    );
  }
}