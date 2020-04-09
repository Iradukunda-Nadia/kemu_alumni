import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kemu_alumni/tabs.dart';


class voteNow extends StatefulWidget {
  @override
  _voteNowState createState() => _voteNowState();
}

class _voteNowState extends State<voteNow> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();



  String selectedItem;
  String Item;
  String chair;
  String assChair;
  String secretary;
  String cID;
  String aID;
  String sID;
  String state;
  bool _isLoading;
  bool _isVoted;
  int prevCV;
  int cV;
  int prevAV;
  int aV;
  int prevSV;
  int sV;



  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  _getEmail() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      email = user.email;

    });
  }

  void validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });

      await Firestore.instance
          .collection(DateFormat('MMM yyyy').format(DateTime.now()))
          .document(cID)
          .updateData({'votes': FieldValue.increment(1.0)});
    await Firestore.instance
        .collection(DateFormat('MMM yyyy').format(DateTime.now()))
        .document(sID)
        .updateData({'votes': FieldValue.increment(1.0)});
    await Firestore.instance
        .collection(DateFormat('MMM yyyy').format(DateTime.now()))
        .document(aID)
        .updateData({'votes': FieldValue.increment(1.0)});

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection("votes")
        .add({
      "Chairperson": chair,
      "Assistant": assChair,
      "Secretary": secretary,
      "name": user.email,
      "status": "voted",
    }).then((result) =>
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: new Text("You have already voted"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (BuildContext context) => new tabView()
                      ));

                    },
                  ),
                ],
              ),
            );
          },
        )
    );

  }


  _voterCheck() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var collectionReference = Firestore.instance.collection('votes');
    var query = collectionReference.where("name", isEqualTo: user.email );
    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length > 0) {
        querySnapshot.documents.forEach((document)
        async {
          setState(() {
            state = document['status'];

          });


          if( state == "voted" ) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                    content: new Text("You have already voted"),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("BACK"),
                        onPressed: () {
                          Navigator.of(context).push(new CupertinoPageRoute(
                              builder: (BuildContext context) => new tabView()
                          ));

                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

        });
      }
    });
  }

  String email;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _voterCheck();
  }

  Future getNew() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var firestore = Firestore.instance;
    QuerySnapshot snap = await firestore.collection("votes").where('name', isEqualTo: user.email).getDocuments();
    return snap.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        new Container(
                          decoration: BoxDecoration(
                            color: Colors.pink[900],
                          ),
                          height: 100.0,
                          width: 200.0,
                          child: new Image.asset("assets/logo.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.pink[900],
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(title: Text("Select Chairperson", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[900]),),
                              initiallyExpanded: true,
                              backgroundColor: Colors.lightBlue[50],

                              leading: new Icon (Icons.border_color, size: 30, color: Colors.pink[900],),
                              children: <Widget>[
                                new StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection(DateFormat('MMM yyyy').format(DateTime.now())).where("status", isEqualTo: "approved").where("cat", isEqualTo: "chair" ).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data.documents.map((doc) {
                                            return RadioListTile(
                                              groupValue: chair,
                                              title: Text(doc.data["name"]),
                                              value: doc.data["name"],
                                              activeColor: Colors.pink[900],
                                              onChanged: (val) {
                                                setState(() {
                                                  chair = val;
                                                  cID = doc.documentID;
                                                });
                                              },
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                ),
                              ],),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.pink[900],
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(title: Text("Select Assistant Chairperson", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[900]),),
                              backgroundColor: Colors.lightBlue[50],

                              leading: new Icon (Icons.border_color, size: 30, color: Colors.pink[900],),
                              children: <Widget>[
                                new StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection(DateFormat('MMM yyyy').format(DateTime.now())).where("status", isEqualTo: "approved").where("cat", isEqualTo: "assistant" ).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data.documents.map((doc) {
                                            return RadioListTile(
                                              groupValue: assChair,
                                              title: Text(doc.data["name"]),
                                              value: doc.data["name"],
                                              activeColor: Colors.pink[900],
                                              onChanged: (val) {
                                                setState(() {
                                                  assChair = val;
                                                  aID = doc.documentID;
                                                });
                                              },
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                ),
                              ],),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.pink[900],
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(title: Text("Select Secretary", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[900]),),
                              backgroundColor: Colors.lightBlue[50],

                              leading: new Icon (Icons.border_color, size: 30, color: Colors.pink[900],),
                              children: <Widget>[
                                new StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection(DateFormat('MMM yyyy').format(DateTime.now())).where("status", isEqualTo: "approved").where("cat", isEqualTo: "secretary" ).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data.documents.map((doc) {
                                            return RadioListTile(
                                              groupValue: secretary,
                                              title: Text(doc.data["name"]),
                                              value: doc.data["name"],
                                              activeColor: Colors.pink[900],
                                              onChanged: (val) {
                                                setState(() {
                                                  secretary = val;
                                                  sID = doc.documentID;
                                                });
                                              },
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                ),
                              ],),
                          ),
                        ),

                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                            child: SizedBox(
                              height: 40.0,
                              width: 200.0,
                              child: new RaisedButton(
                                elevation: 5.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                color: Colors.pink[900],
                                child: new Text("Submit",
                                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                                onPressed: (){validateAndSubmit();},
                              ),
                            )),

                      ],
                    ),
                  )),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }
}

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Election Results"),
        backgroundColor: Colors.pink[900],
        centerTitle: true,
      ),

      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        new Container(
                          decoration: BoxDecoration(
                            color: Colors.pink[900],
                          ),
                          height: 100.0,
                          width: 200.0,
                          child: new Image.asset("assets/logo.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.pink[900],
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(title: Text("Chairperson", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[900]),),
                              initiallyExpanded: true,
                              backgroundColor: Colors.lightBlue[50],

                              leading: new Icon (Icons.equalizer, size: 30, color: Colors.pink[900],),
                              children: <Widget>[
                                new StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection(DateFormat('MMM yyyy').format(DateTime.now())).where("status", isEqualTo: "approved").where("cat", isEqualTo: "chair" ).orderBy("votes", descending: true).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data.documents.map((doc) {
                                           return ListTile(
                                              title: Text(doc.data["name"], style: TextStyle(fontSize: 18),),
                                              trailing: Text(doc.data["votes"].toString(), style: TextStyle(fontSize: 18),),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                ),
                              ],),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.pink[900],
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(title: Text("Assistant Chairperson", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[900]),),
                              backgroundColor: Colors.lightBlue[50],
                              initiallyExpanded: true,

                              leading: new Icon (Icons.equalizer, size: 30, color: Colors.pink[900],),
                              children: <Widget>[
                                new StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection(DateFormat('MMM yyyy').format(DateTime.now())).where("status", isEqualTo: "approved").where("cat", isEqualTo: "assistant" ).orderBy("votes", descending: true).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data.documents.map((doc) {
                                            return ListTile(
                                              title: Text(doc.data["name"], style: TextStyle(fontSize: 18),),
                                              trailing: Text(doc.data["votes"].toString(), style: TextStyle(fontSize: 18),),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                ),
                              ],),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.pink[900],
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(title: Text("Secretary", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[900]),),
                              backgroundColor: Colors.lightBlue[50],
                              initiallyExpanded: true,

                              leading: new Icon (Icons.equalizer, size: 30, color: Colors.pink[900],),
                              children: <Widget>[
                                new StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection(DateFormat('MMM yyyy').format(DateTime.now())).where("status", isEqualTo: "approved").where("cat", isEqualTo: "secretary" ).orderBy("votes", descending: true).snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: snapshot.data.documents.map((doc) {
                                            return ListTile(
                                              title: Text(doc.data["name"], style: TextStyle(fontSize: 18),),
                                              trailing: Text(doc.data["votes"].toString(), style: TextStyle(fontSize: 18),),
                                            );
                                          }).toList(),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                ),
                              ],),
                          ),
                        ),


                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),


    );
  }
}
