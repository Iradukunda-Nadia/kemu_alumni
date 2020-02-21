

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final FirebaseMessaging _messaging = FirebaseMessaging();

  TabController controller;
  Future getVideo() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("news").orderBy('date').getDocuments();
    return qn.documents;
  }

  Future getNew() async{
    var firestore = Firestore.instance;
    QuerySnapshot snap = await firestore.collection("news").orderBy('date', descending: true).limit(1).getDocuments();
    return snap.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("Articles"),
          centerTitle: true,
          backgroundColor: Colors.pink[900],
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[


            new Flexible(
              child: FutureBuilder(
                  future: getNew(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading... Please wait"),
                      );
                    }if (snapshot.data == null){
                      return Center(
                        child: Text("The are no Articles"),);
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[


                                  new GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new videoDetail(

                                        itemImage: snapshot.data[index].data["image"],
                                        itemName: snapshot.data[index].data["title"],
                                        itemDate: snapshot.data[index].data["date"],
                                        itemDescription: snapshot.data[index].data["article"],
                                        subTitle: snapshot.data[index].data["subtitle"],
                                        index: index,


                                      )));
                                    },
                                    child: new Card(
                                      child: Stack(
                                        alignment: FractionalOffset.topLeft,
                                        children: <Widget>[
                                          new Stack(
                                            alignment: FractionalOffset.bottomCenter,
                                            children: <Widget>[
                                              new Container(
                                                height:250.0 ,
                                                decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fitHeight,
                                                        image: new NetworkImage(snapshot.data[index].data["image"]))
                                                ),

                                              ),
                                              new Container(
                                                height:70.0 ,
                                                color: Colors.black.withAlpha(90),
                                                child: new Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: new Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 250,
                                                        child: Column(
                                                          children: <Widget>[
                                                            new Text("${snapshot.data[index].data["title"]}",
                                                        textAlign: TextAlign.left,
                                                              softWrap: true,
                                                              style: new TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 20.0,
                                                                  color: Colors.white),),

                                                          ],
                                                        ),
                                                      ),

                                                      Container(
                                                        padding: const EdgeInsets.all(5.0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.white)
                                                        ),
                                                        child: new Text("NEW",
                                                          style: new TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w400),),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              new SizedBox(
                                height: 10.0,
                              ),
                            ],
                          );

                        },
                      );

                    }
                  }),),

            new SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Previous Articles", style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black),),
                ],
              ),
            ),

            new Flexible(
              child: FutureBuilder(
                  future: getVideo(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading... Please wait"),
                      );
                    }if (snapshot.data == null){
                      return Center(
                        child: Text("The are no Articles"),);
                    }else{
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  new SizedBox(
                                    height: 10.0,
                                  ),


                                  new GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new videoDetail(

                                        itemImage: snapshot.data[index].data["image"],
                                        itemName: snapshot.data[index].data["title"],
                                        itemDate: snapshot.data[index].data["date"],
                                        itemDescription: snapshot.data[index].data["article"],
                                        subTitle: snapshot.data[index].data["subtitle"],
                                        index: index,


                                      )));
                                    },
                                    child: new Card(
                                      elevation:5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Stack(
                                            alignment: FractionalOffset.topLeft,
                                            children: <Widget>[
                                              new Container(
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                height: MediaQuery.of(context).size.height * 0.2,
                                                decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fitHeight,
                                                        image: new NetworkImage(snapshot.data[index].data["image"]))
                                                ),

                                              ),

                                            ],
                                          ),
                                          new Container(
                                            height:65.0 ,
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            color: Colors.white,
                                            child: new Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Column(
                                                      children: <Widget>[
                                                        new Text("${snapshot.data[index].data["title"]}",
                                                          style: new TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 14.0,
                                                              color: Colors.black),),

                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              new SizedBox(
                                height: 10.0,
                              ),
                            ],
                          );

                        },
                      );

                    }
                  }),),

          ],
        )

    );
  }
}


class videoDetail extends StatefulWidget {
  String itemName;
  String itemDate;
  String itemImage;
  String itemDescription;
  String subTitle;
  final index;

  videoDetail({

    this.itemName,
    this.itemDate,
    this.itemImage,
    this.itemDescription,
    this.subTitle,
    this.index
  });


  @override
  _videoDetailState createState() => _videoDetailState();
}

class _videoDetailState extends State<videoDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),

      body: Column(
       children: <Widget>[
         Stack(
           children: <Widget>[
             Container(
                 padding: EdgeInsets.only(left: 10.0),
                 height: MediaQuery.of(context).size.width * 0.5,
                 decoration: new BoxDecoration(
                   image: new DecorationImage(
                     image: new NetworkImage(widget.itemImage),
                     fit: BoxFit.cover,
                   ),
                 )),
           ],
         ),

         Expanded(
           child: SingleChildScrollView(
             child: new Column(
               children: <Widget>[
                 Container(
                   // height: MediaQuery.of(context).size.height,
                   width: MediaQuery.of(context).size.width,
                   // color: Theme.of(context).primaryColor,
                   padding: EdgeInsets.all(10.0),
                   child: Column(
                     children: <Widget>[
                       Text(
                         widget.itemName,
                         softWrap: true,
                         style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                       ),

                       ListTile(
                         leading: new Icon(Icons.access_time),
                         title: new Text(widget.itemDate, style: TextStyle(color: Colors.blueGrey, fontSize: 10.0),),
                       ),

                       Text(
                         widget.itemDescription,
                         softWrap: true,
                         style: TextStyle(fontSize: 18.0,),
                       ),
                     ],
                   ),
                 )
               ],
             ),
           ),
         ),


       ],
      ),
    );
  }


}

