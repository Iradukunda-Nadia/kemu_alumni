import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class candi extends StatefulWidget {
  @override
  _candiState createState() => _candiState();
}

class _candiState extends State<candi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/education.png",
              fit: BoxFit.contain,
              height: 200.0,
              width: 300.0,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new ActiveCand()
                  ));
                },
                child: new Container(
                  height: 60.0,
                  margin: new EdgeInsets.only(top: 5.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 2.0),
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: Colors.pink[900],
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20.0))),
                      child: new Center(
                          child: new Text(
                            "Approve registered candidates",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          )),
                    ),
                  ),
                ),
              ),

            ),

            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
              child: new InkWell(
                onTap: () {},
                child: new Container(
                  height: 60.0,
                  margin: new EdgeInsets.only(top: 5.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 2.0),
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: Colors.pink[900],
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(20.0))),
                      child: new Center(
                          child: new Text(
                            "SET ELECTION PERIOD",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveCand extends StatefulWidget {
  @override
  _ActiveCandState createState() => _ActiveCandState();
}

class _ActiveCandState extends State<ActiveCand> {
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
              stream: db.collection(DateFormat('MMM yyyy').format(DateTime.now())).orderBy("cat").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new regDetail(

                            cat: doc.data["cat"],
                            cv: doc.data["cv"],
                            date: doc.data["date"],
                            name: doc.data["name"],
                            status: doc.data["status"],
                            qualification: doc.data["status"],
                            docID: doc.documentID,


                          )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: new Icon(Icons.person),
                          ),
                          title: Text(doc.data['name'], style: TextStyle(fontSize: 12),),
                          subtitle: Text(doc.data['cat'], style: TextStyle(fontSize: 12),),
                          trailing: Text(doc.data['status'], style: TextStyle(fontSize: 12),),
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

class regDetail extends StatefulWidget {

  String status;
  String cat;
  String cv;
  String date;
  String name;
  String qualification;
  String docID;

  regDetail({
    this.docID,
    this.status,
    this.cat,
    this.cv,
    this.date,
    this.name,
    this.qualification,
});

  @override
  _regDetailState createState() => _regDetailState();
}

class _regDetailState extends State<regDetail> {

  String urlData;

  _launchURL() async {
    String url = urlData;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 100.0,
            decoration: new BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(100.0),
                bottomLeft: new Radius.circular(100.0),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 50.0,
                ),
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: new Text(
                            "Registration Details",
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        new SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  child: Container(
                    margin: new EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 5.0,
                        ),
                        new Text('Date: ${widget.date}'),
                        new SizedBox(
                          height: 5.0,
                        ),
                        new Text('Name: ${widget.name}'),
                        new SizedBox(
                          height: 5.0,
                        ),
                        new Text('Category: ${widget.cat}'),
                        new SizedBox(
                          height: 5.0,
                        ),
                        new Text('Qualification: ${widget.qualification}'),
                        new SizedBox(
                          height: 5.0,
                        ),
                        new FlatButton( onPressed: () {
                          setState(() {
                            urlData = widget.cv;
                          });

                          _launchURL();
                        },
                          child: Text(
                            "CV Link",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .apply(color: Colors.blue[700]),
                          ),),
                      ],
                    ),
                  ),
                ),

                new SizedBox(
                  height: 20.0,
                ),

                widget.status== "approved" ? new Offstage(): RaisedButton(
                  child: const Text('Approve registration'),
                  onPressed: () async{

                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("Approve this Candidate?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () async{
                                await Firestore.instance
                                    .collection('users')
                                    .document(widget.docID)
                                    .updateData({
                                  'status': "approved",
                                });
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Approved"),
                                        content: Text("This Candidate has been approved"),
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
                  },
                ),

              ],
            ),
          )
        ],
      ),

    );
  }
}
