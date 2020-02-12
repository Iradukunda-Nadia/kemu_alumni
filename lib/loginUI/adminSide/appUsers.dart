import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class appUsers extends StatefulWidget {
  @override
  _appUsersState createState() => _appUsersState();
}

class _appUsersState extends State<appUsers> {
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
              stream: db.collection('users').where("status", isEqualTo: "pending").snapshots(),
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
                          trailing: RaisedButton(
                              color: Colors.pink[900],
                              child: Text("Approve"),
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
                                                Firestore.instance.collection('notifications').document(doc.data['token']).setData({
                                                'title': "Approved!!",
                                                'body': "Your regestration has been approved",
                                                'token': doc.data['token'],
                                                });
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Approved"),
                                                        content: Text("This user has been approved"),
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
                              })
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

class addUser extends StatefulWidget {
  @override
  _addUserState createState() => _addUserState();
}

class _addUserState extends State<addUser> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _name;
  String _uid;
  String _pw;
  String _dept;
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
      CollectionReference reference = Firestore.instance.collection('users');

      await reference.add({
        'name': _name,
        'uid': _uid,
        'dept': _dept,
        'pw': _pw,
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
          content: new Text("User has been created"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New user"),
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

                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Name',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _name = val,
                              ),
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
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _pw = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                            child: MaterialButton(
                              onPressed: _submitCommand,
                              child: Text('Add User',
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

class userDetails extends StatefulWidget {
  String name;
  String uid;
  String pw;
  String dept;
  String docID;


  userDetails({

    this.name,
    this.uid,
    this.pw,
    this.dept,
    this.docID,
  });
  @override
  _userDetailsState createState() => _userDetailsState();
}

class _userDetailsState extends State<userDetails> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _name;
  String _uid;
  String _pw;
  String _dept;
  final db = Firestore.instance;

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
      _updateData();
    }
  }

  _updateData() async {
    await Firestore.instance
        .collection('users')
        .document(widget.docID)
        .updateData({
      'name': _name,
      'uid': _uid,
      'pw': _pw,
      'dept': _dept,

    }).then((result) =>

        _showPopUp());
  }

  void _showPopUp() {
    // flutter defined function
    final form = formKey.currentState;
    form.reset();
    var context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Your request has been sent"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: new Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              new Container(
                height: 200.0,
                decoration: new BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  borderRadius: new BorderRadius.only(
                    bottomRight: new Radius.circular(20.0),
                    bottomLeft: new Radius.circular(20.0),
                  ),
                ),
              ),
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

                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Name',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.name,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _name = val,
                              ),
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
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                initialValue: widget.pw,
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _pw = val,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                            child: MaterialButton(
                              onPressed: _submitCommand,
                              child: Text('Update',
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

                          FlatButton(
                            color: Colors.deepPurple[900],
                            onPressed: () async {
                              await db
                                  .collection('userID')
                                  .document(widget.docID)
                                  .delete();

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Deleted"),
                                      content: Text("Removed from Database"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).push(new CupertinoPageRoute(
                                                builder: (context) => appUsers()));
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text('Delete User',style: TextStyle(color: Colors.white, fontSize: 10.0),),
                              ],
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