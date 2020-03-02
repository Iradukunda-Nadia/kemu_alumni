import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  String _cat;



  Future getSchool() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("school").orderBy("name" , descending: false).getDocuments();
    return qn.documents;

  }

  Future getCourse() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("courses").where("type", isEqualTo: _cat ).getDocuments();
    return qn.documents;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _cat = "masters";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("COURSES OFFERED"), backgroundColor: Colors.pink[900], centerTitle: true,),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.pink[900],
          label: new Text('Add Course'),
          //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
          onPressed: () {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new postCourse()
            ));
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 1100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Flexible(
                  child: FutureBuilder(
                      future: getSchool(),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading... Please wait"),
                          );
                        }if (snapshot.data == null){
                          return Center(
                            child: Text("The is no data"),);
                        }else{
                          return ConstrainedBox(
                            constraints: new BoxConstraints(
                              minHeight: 20.0,
                              maxHeight: 40.0,
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: MaterialButton(
                                    onPressed: (){
                                      setState(() {
                                        _cat = "masters";
                                      });
                                    },
                                    child: Text("Masters",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'SFUIDisplay',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    color: Colors.pink[900],
                                    elevation: 10.0,
                                    minWidth: 150,
                                    height: 20,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: MaterialButton(
                                    onPressed: (){
                                      setState(() {
                                        _cat = "phd";
                                      });
                                    },
                                    child: Text("PHD",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'SFUIDisplay',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    color: Colors.pink[900],
                                    elevation: 10.0,
                                    minWidth: 150,
                                    height: 20,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                        }
                      }),),

                new Flexible(
                  fit: FlexFit.loose,
                  child: FutureBuilder(
                      future: getCourse(),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading... Please wait"),
                          );
                        }if (snapshot.data == null){
                          return Center(
                            child: Text("There is no data"),);
                        }else{
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return new GestureDetector(
                                onTap: (){},
                                child: new Card(
                                  child: Stack(
                                    alignment: FractionalOffset.topLeft,
                                    children: <Widget>[
                                      new ListTile(
                                        title: new Text("${snapshot.data[index].data["title"]}",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0,
                                              color: Colors.pink[900]),),
                                        subtitle: new Text("${snapshot.data[index].data["school"]}",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0,
                                              color: Colors.grey),),
                                      ),

                                    ],
                                  ),
                                ),
                              );

                            },
                          );

                        }
                      }),)

              ],
            ),
          ),
        )
    );
  }
}

class postCourse extends StatefulWidget {
  @override
  _postCourseState createState() => _postCourseState();
}

class _postCourseState extends State<postCourse> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _title;
  String _cat;
  String _desc;
  String _intake;
  String _deadline;
  String _content;
  String _location;
  String _type;
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
      CollectionReference reference = Firestore.instance.collection('jobs');

      await reference.add({
        'title': _title,
        'cat': _cat,
        'date': DateTime.now(),
        'type': _type,
        'deadline': _deadline,
        'intake': _intake,
        'content': _content,
        'desc': _desc,
        'offered': _location,

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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course"),
        backgroundColor: Colors.pink[900],
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
                            height: 50.0,
                            child:  new StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection("school").snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return new Text("Please wait");
                                  var length = snapshot.data.documents.length;
                                  DocumentSnapshot ds = snapshot.data.documents[length - 1];
                                  return new DropdownButton(
                                    items: snapshot.data.documents.map((
                                        DocumentSnapshot document) {
                                      return DropdownMenuItem(
                                          value: document.data["name"],
                                          child: new Text(document.data["name"]));
                                    }).toList(),
                                    value: _cat,
                                    onChanged: (value) {
                                      print(value);

                                      setState(() {
                                        _cat = value;
                                      });
                                    },
                                    hint: new Text("Select School"),
                                    style: TextStyle(color: Colors.black),

                                  );
                                }
                            ),
                          ),

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
                                    labelText: 'TYPE',
                                    hintText: "masters / phd",
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _title = val,
                              ),
                            ),
                          ),
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
                                    labelText: 'Course Title',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _title = val,
                              ),
                            ),
                          ),

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
                                    labelText: 'Where is it offered?',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _location = val,
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
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Description',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _desc = val,
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
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    labelText: 'Course content',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _content = val,
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
                                    labelText: 'Intake',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _intake = val,
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
                                    labelText: 'Application deadline',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _deadline = val,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                            child: MaterialButton(
                              onPressed: _submitCommand,
                              child: Text('Add course',
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
