import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kemu_alumni/loginUI/adminSide/funds.dart';

class fundDiv extends StatefulWidget {
  @override
  _fundDivState createState() => _fundDivState();
}

class _fundDivState extends State<fundDiv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(

        children: <Widget>[
          new Container(
            height: 250.0,
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.only(top: 20.0, bottom: 0.0),
                    height: 70.0,
                    width: 100.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Finance",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 36.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ),

                ],
              ),
            ),
            decoration: new BoxDecoration(
                color: Colors.pink[900],
                borderRadius: new BorderRadius.only(
                    bottomLeft: new Radius.circular(20.0),
                    bottomRight: new Radius.circular(20.0))),

          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
            child: new InkWell(
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new  evFunds()
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
                          "Event payment",
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
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new  Funds()
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
                          "General Contribution",
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
    );
  }
}
