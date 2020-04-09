import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  TextEditingController dateCtl = TextEditingController();
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Events"),
        backgroundColor: Colors.pink[900],),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () {
          Navigator.of(context).push(new CupertinoPageRoute(
              builder: (BuildContext context) => new addEvent()
          ));
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('events').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new eventReserves(

                            itemImage: doc.data["image"],
                            eventTitle: doc.data["title"],
                            eventDate: doc.data["date"],
                            eventID: doc.documentID,


                          )));
                        },
                        child: ListTile(
                          leading: Image.network(doc.data["image"]),
                          title: Text("${doc.data["title"]}"),
                          subtitle: Text("${doc.data["date"]}"),
                          trailing: new Icon(Icons.arrow_forward_ios),
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


class addEvent extends StatefulWidget {
  @override
  _addEventState createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _name;
  String _date;
  String _img;
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
      CollectionReference reference = Firestore.instance.collection('events');

      await reference.add({
        'title': _name,
        'date': dateCtl,
        'image': _img,
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
          content: new Text("event has been created"),
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
  TextEditingController dateCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New event"),
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
                                    labelText: 'Event title',
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
                                controller: dateCtl,
                                decoration: InputDecoration(
                                  labelText: "Date",
                                  hintText: "Enter Date",),
                                onTap: () async{
                                  DateTime date = DateTime(1900);
                                  FocusScope.of(context).requestFocus(new FocusNode());

                                  date = await showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now(),
                                      firstDate:DateTime(1900),
                                      lastDate: DateTime(2100));

                                  dateCtl.text = DateFormat(' dd MMM yyyy').format(date);},),
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
                                    labelText: 'Image url',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _img = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                            child: MaterialButton(
                              onPressed: _submitCommand,
                              child: Text('Add Event',
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

class eventReserves extends StatefulWidget {
  String itemImage;
  String eventTitle;
  String eventDate;
  String eventID;

  eventReserves({

    this.itemImage,
    this.eventTitle,
    this.eventDate,
    this.eventID,
  });
  @override
  _eventReservesState createState() => _eventReservesState();
}

class _eventReservesState extends State<eventReserves> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RSVP's"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink[900],
        label: new Text('Delete Event', style: TextStyle(fontSize: 20),),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () async {
          await db
              .collection('events')
              .document(widget.eventID)
              .delete();
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Deleted"),
                  content: Text("event deleted from database"),
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
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10.0),
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage(widget.itemImage),
                      fit: BoxFit.cover,
                    ),
                  ),

              ),
            ],
          ),

          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(12.0),
            children: <Widget>[
              Center(child: Text("Registered to attend")),
              SizedBox(height: 20.0),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('rsvp').where("event", isEqualTo: widget.eventTitle).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.documents.map((doc) {
                          return GestureDetector(
                            onTap: (){},
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                leading: Icon(Icons.person, color: Colors.pink[900],),
                                title: Text(doc.data['name'], style: TextStyle(fontSize: 18),),

                              ),
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


        ],
      ),
    );
  }
}
