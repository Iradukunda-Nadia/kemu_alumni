import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {


  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("jobs").orderBy("date", descending: true).getDocuments();
    return qn.documents;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Openings"),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink[900],
        label: new Text('Post new Job'),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () {
          Navigator.of(context).push(new CupertinoPageRoute(
              builder: (BuildContext context) => new postJob()
          ));
        },
      ),
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
                      child: Text("The are no Jobs Posted"),);
                  }else{
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new jobDetail(

                              company: snapshot.data[index].data["company"],
                              position: snapshot.data[index].data["position"],
                              desc: snapshot.data[index].data["desc"],
                              location: snapshot.data[index].data["location"],
                              req: snapshot.data[index].data["req"],
                              link: snapshot.data[index].data["link"],
                              index: index,


                            )));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300], blurRadius: 5.0, offset: Offset(0, 3))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data[index].data["position"],
                                            style: Theme.of(context).textTheme.title,
                                          ),
                                          Text(
                                            snapshot.data[index].data["location"],
                                            style: Theme.of(context).textTheme.subtitle.apply(
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  snapshot.data[index].data["desc"],
                                  style:
                                  Theme.of(context).textTheme.body1.apply(color: Colors.grey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 9),
                                Text(
                                  snapshot.data[index].data["company"],
                                  style:
                                  Theme.of(context).textTheme.subhead.apply(fontWeightDelta: 2, color: Colors.pink[900],),
                                ),
                                SizedBox(height: 9),
                                Text(
                                  "posted by: ${snapshot.data[index].data["name"]}",
                                  style:
                                  Theme.of(context).textTheme.subtitle.apply(
                                    color: Colors.grey,
                                  ),
                                )
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
    );
  }
}

class postJob extends StatefulWidget {
  @override
  _postJobState createState() => _postJobState();
}

class _postJobState extends State<postJob> {
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
      CollectionReference reference = Firestore.instance.collection('jobs');

      await reference.add({
        'company': _company,
        'position': _title,
        'date': DateTime.now(),
        'desc': _description,
        'req': _requirements,
        'link': _link,
        'name': name,
        'location': location,

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post new Job"),
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
                                    labelText: 'Company',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _company = val,
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
                                    labelText: 'Positon',
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
                                    labelText: 'Location',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => location = val,
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
                                onSaved: (val) => _description = val,
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
                                    labelText: 'Requirements',
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
                                    labelText: 'Job link',
                                    labelStyle: TextStyle(
                                        fontSize: 11
                                    )
                                ),
                                validator: (val) =>
                                val.isEmpty  ? null : null,
                                onSaved: (val) => _link = val,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                            child: MaterialButton(
                              onPressed: _submitCommand,
                              child: Text('Post Job',
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

class jobDetail extends StatefulWidget {
  String company;
  String desc;
  String location;
  String position;
  String req;
  String link;
  final index;

  jobDetail({

    this.company,
    this.desc,
    this.location,
    this.position,
    this.req,
    this.link,
    this.index
  });
  @override
  _jobDetailState createState() => _jobDetailState();
}

class _jobDetailState extends State<jobDetail> {

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
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Image.network(
              "https://cdn.pixabay.com/photo/2015/01/08/18/26/write-593333_960_720.jpg",
              fit: BoxFit.cover,
              color: Colors.black38,
              colorBlendMode: BlendMode.darken,
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * .7,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.position}",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Text(
                      "(${widget.company})",
                      style: Theme.of(context).textTheme.headline.apply(
                        color: Colors.pink[900],
                      ),
                    ),
                    Text(
                      "${widget.location}",
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .apply(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "Overview",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    Text(
                      "${widget.desc}",
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .apply(color: Colors.grey),
                    ),
                    Text(
                      "Requirements",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    Text(
                      "${widget.req}",
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .apply(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.height * .7,
                      height: 45,
                      child: RaisedButton(
                        child: Text(
                          "Job Link",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .apply(color: Colors.white),
                        ),
                        color: Colors.pink[900],
                        onPressed: () {
                         setState(() {
                           urlData = widget.link;
                         });

                         _launchURL();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("jobs").orderBy("date", descending: true).getDocuments();
    return qn.documents;

  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        StreamBuilder(
          stream: Firestore.instance.collection('jobs').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data.length == 0) {
              return Column(
                children: <Widget>[
                  Text(
                    "No Results Found.",
                  ),
                ],
              );
            } else {
              var results = snapshot.data;
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var result = results[index];
                  return ListTile(
                    title: Text(result.position),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');

        final results = snapshot.data.documents.where((DocumentSnapshot a) => a.data['position'].toString().contains(query));

        return ListView(
            children: results.map<Widget>((a) => ListTile(
              leading: new Icon(Icons.arrow_right),
              title: Text(a.data['position'].toString()),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new jobDetail(

                  company: a.data["company"],
                  position: a.data["position"],
                  desc: a.data["desc"],
                  location: a.data["location"],
                  req: a.data["req"],
                  link: a.data["link"],


                )));
              },
            )).toList()
        );
      },
    );
  }
}

