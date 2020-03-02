import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class courseSec extends StatefulWidget {
  @override
  _courseSecState createState() => _courseSecState();
}

class _courseSecState extends State<courseSec> {
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
                      builder: (BuildContext context) => new Applications()
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
                            "MASTERS",
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
                            "PHD",
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


class Applications extends StatefulWidget {
  @override
  _ApplicationsState createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  
  String _cat;



  Future getSchool() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("school").orderBy("name" , descending: false).getDocuments();
    return qn.documents;

  }

  Future getCourse() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("courses").where("cat", isEqualTo: _cat ).where("type", isEqualTo: "masters").getDocuments();
    return qn.documents;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _cat = "Agriculture";
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Masters"), backgroundColor: Colors.pink[900], centerTitle: true,),
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
                              minHeight: 30.0,
                              maxHeight: 60.0,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      child: MaterialButton(
                                        onPressed: (){
                                          setState(() {
                                            _cat = snapshot.data[index].data["name"];
                                          });
                                        },
                                        child: Text(snapshot.data[index].data["name"],
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'SFUIDisplay',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        color: Colors.pink[900],
                                        elevation: 10.0,
                                        minWidth: 80,
                                        height: 30,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                      ),
                                    ),
                                  ],
                                );

                              },
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
                                onTap: (){
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new courseDetail(

                                    title: snapshot.data[index].data["title"],
                                    deadline: snapshot.data[index].data["deadline"],
                                    desc: snapshot.data[index].data["desc"],
                                    location: snapshot.data[index].data["offered"],
                                    intake: snapshot.data[index].data["intake"],
                                    content: snapshot.data[index].data["content"],
                                    index: index,


                                  )));
                                },
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

class courseDetail extends StatefulWidget {
  String title;
  String desc;
  String location;
  String content;
  String deadline;
  String intake;
  final index;

  courseDetail({

    this.title,
    this.desc,
    this.location,
    this.content,
    this.deadline,
    this.intake,
    this.index
  });
  @override
  _courseDetailState createState() => _courseDetailState();
}

class _courseDetailState extends State<courseDetail> {

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
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * .9,
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
                      "${widget.title}",
                      style: Theme.of(context).textTheme.headline.apply(fontWeightDelta: 100),
                    ),
                    Text(
                      "(Offered at ${widget.location})",
                      style: Theme.of(context).textTheme.body1.apply(color: Colors.pink[900]),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Intake: ${widget.intake}",
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .apply(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Deadline: ${widget.deadline}",
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .apply(color: Colors.grey),
                        ),
                      ],
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
                      "Course content",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    Text(
                      "${widget.content}",
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
                          "Contact For more Information",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .apply(color: Colors.white),
                        ),
                        color: Colors.pink[900],
                        onPressed: () {

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
