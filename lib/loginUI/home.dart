import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kemu_alumni/events.dart';
import 'package:kemu_alumni/homeUI.dart';
import 'package:kemu_alumni/jobs.dart';
import 'package:kemu_alumni/newEvent.dart';
import 'package:kemu_alumni/news.dart';
import 'package:kemu_alumni/scholarships.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  void initState() {
    _messaging.subscribeToTopic('student');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: CustomPaint(
              painter: ShapesPainter(),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: GridView.count(crossAxisCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16.0),
                  childAspectRatio: 9.0 / 9.0,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(FadeRouteBuilder(page: News()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Icon(Icons.assignment
                                  , size: 50.0, color: Colors.pink[900],)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('News', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(FadeRouteBuilder(page: new Jobs()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Icon(Icons.business, size: 50.0, color: Colors.pink[900],)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Jobs', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(FadeRouteBuilder(page: new Scholarships()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Icon(Icons.import_contacts, size: 50.0, color: Colors.pink[900],)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Scholarships', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(FadeRouteBuilder(page: new Events()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Icon(Icons.layers, size: 50.0, color: Colors.pink[900],)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Applications', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(FadeRouteBuilder(page: new Events()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Icon(Icons.monetization_on, size: 50.0, color: Colors.pink[900],)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Contributions', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(FadeRouteBuilder(page: new Events()));
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Icon(Icons.poll, size: 50.0, color: Colors.pink[900],)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Elections', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),





                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
    pageBuilder: (context, animation1, animation2) => page,
    transitionsBuilder: (context, animation1, animation2, child) {
      return FadeTransition(opacity: animation1, child: child);
    },
  );
}