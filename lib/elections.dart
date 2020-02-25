import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kemu_alumni/voting.dart';

import 'loginUI/home.dart';


class VotingHomePage extends StatelessWidget  {
  const VotingHomePage ({this.title}) :super();
  final String title;



  Widget _buildListItem(BuildContext context,DocumentSnapshot document){
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffdddff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              document['votes'].toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
      ),
      onTap: (){
        Firestore.instance.runTransaction((transaction) async{
          DocumentSnapshot freshData = await transaction.get(document.reference);
          await transaction.update(freshData.reference, {
            'votes':freshData['votes']+1,
          });
        });

      },
    );
  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.pink[900],
          label: new Text('Register as Candidate'),
          //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
          onPressed: () {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new regCand()
            ));
          },
        ),
        body: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                color: Colors.purple[100],
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: new NetworkImage(
                    'https://www.nation.co.ke/image/view/-/5331682/highRes/2480738/-/118vdcs/-/Meth.jpg',
                  ),
                ),
              ),
            ),
            new Container(
                padding: EdgeInsets.all(16.0),
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Image.asset(
                          "assets/elections.png",
                          fit: BoxFit.contain,
                          height: 200.0,
                          width: 200.0,
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(new CupertinoPageRoute(
                                builder: (BuildContext context) => new voteNow()
                            ));
                          },
                          child: new Container(
                              height: 120.0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    height: 124.0,
                                    margin: new EdgeInsets.only(left: 46.0),
                                    decoration: new BoxDecoration(
                                      color: Colors.lightBlue[50],
                                      shape: BoxShape.rectangle,
                                      borderRadius: new BorderRadius.circular(8.0),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10.0,
                                          offset: new Offset(0.0, 10.0),
                                        ),
                                      ],
                                    ),
                                    child: new Container(
                                      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                                      constraints: new BoxConstraints.expand(),
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(height: 15.0),
                                          new Text("Vote Now",
                                              style: TextStyle(fontSize: 18.0, color: Colors.grey[800])

                                          ),
                                          new Container(
                                              margin: new EdgeInsets.symmetric(vertical: 8.0),
                                              height: 2.0,
                                              width: 18.0,
                                              color: new Color(0xff00c6ff)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    margin: new EdgeInsets.symmetric(
                                        vertical: 16.0
                                    ),
                                    alignment: FractionalOffset.centerLeft,
                                    child: new CircleAvatar(
                                        radius: 40,
                                        child: new Icon (Icons.border_color, size: 30,)),
                                    height: 92.0,
                                    width: 92.0,
                                  ),
                                ],
                              )
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(new CupertinoPageRoute(
                                builder: (BuildContext context) => new Results()
                            ));
                          },
                          child: new Container(
                              height: 120.0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    height: 124.0,
                                    margin: new EdgeInsets.only(left: 46.0),
                                    decoration: new BoxDecoration(
                                      color: Colors.lightBlue[50],
                                      shape: BoxShape.rectangle,
                                      borderRadius: new BorderRadius.circular(8.0),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10.0,
                                          offset: new Offset(0.0, 10.0),
                                        ),
                                      ],
                                    ),

                                    child: new Container(
                                      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                                      constraints: new BoxConstraints.expand(),
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(height: 15.0),
                                          new Text("Election Results",
                                              style: TextStyle(fontSize: 18.0, color: Colors.grey[800])

                                          ),
                                          new Container(
                                              margin: new EdgeInsets.symmetric(vertical: 8.0),
                                              height: 2.0,
                                              width: 18.0,
                                              color: new Color(0xff00c6ff)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    margin: new EdgeInsets.symmetric(
                                        vertical: 16.0
                                    ),
                                    alignment: FractionalOffset.centerLeft,
                                    child: new CircleAvatar(
                                        radius: 40,
                                        child: new Icon (Icons.equalizer, size: 30,)),
                                    height: 92.0,
                                    width: 92.0,
                                  ),
                                ],
                              )
                          ),
                        ),

                      ],
                    ),


                  ],
                )),

          ],
        ));
  }

}

class regCand extends StatefulWidget {
  @override
  _regCandState createState() => _regCandState();
}

class _regCandState extends State<regCand> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _company;
  String _description;
  String _title;
  String _requirements;
  String _link;
  String name;
  String location;
  DateTime now = DateTime.now();
  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    //`validate()` validates every FormField that is a descendant of this Form,
    // and returns true if there are no errors.
    if (form.validate()) {
      //`save()` Saves every FormField that is a descendant of this Form.
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _AddData();
    }
  }

  _AddData() async {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('candidates');

      await reference.add({
        'position': Item,
        'date': DateTime.now(),
        'req': _requirements,
        'name': name,
        "status": "pending",
        'votes': 0,

      });
    }).then((result) =>

        _showRequest());
  }

  void _showRequest() {
    // flutter defined function
    final form = formKey.currentState;
    form.reset();
    var context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("data has been added"),
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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var collectionReference = Firestore.instance.collection('users');
    var query = collectionReference.where("name", isEqualTo: user.email );

    query.getDocuments().then((querySnapshot) {
      if (querySnapshot.documents.length == 0) {
        final snack = SnackBar(
          content: Text('Current user is undetermined'),
        );
        scaffoldKey.currentState.showSnackBar(snack);
      } else {
        querySnapshot.documents.forEach((document)
        async {


          setState(() {
            name = document['userName'];

          });



        });
      }
    });
  }

  String selectedItem;
  String Item;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Candidate Registration"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: new Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[

              new Card(child: new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          SizedBox(
                            height: 60.0,
                            child:  new StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection("category").snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return new Text("Please wait");
                                  var length = snapshot.data.documents.length;
                                  DocumentSnapshot ds = snapshot.data.documents[length - 1];
                                  return new DropdownButton(
                                    items: snapshot.data.documents.map((
                                        DocumentSnapshot document) {
                                      return DropdownMenuItem(
                                          value: document.data["cat"],
                                          child: new Text(document.data["cat"]));
                                    }).toList(),
                                    value: Item,
                                    onChanged: (value) {
                                      print(value);

                                      setState(() {
                                        Item = value;
                                      });
                                    },
                                    hint: new Text("Select Position"),
                                    style: TextStyle(color: Colors.black),

                                  );
                                }
                            ),
                          ),


                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Qualification',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _requirements = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                            child: MaterialButton(
                              onPressed: _submitCommand,
                              child: Text('Register',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'SFUIDisplay',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.white,
                              elevation: 16.0,
                              minWidth: 400,
                              height: 50,
                              textColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          ),




                        ],
                      ),
                    ),

                  ],
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}