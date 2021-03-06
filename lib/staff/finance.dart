import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kemu_alumni/loginUI/adminSide/funds.dart';
import 'package:kemu_alumni/loginUI/auth.dart';
import 'package:kemu_alumni/loginUI/background.dart';
import 'package:kemu_alumni/loginUI/home.dart';
import 'package:kemu_alumni/loginUI/root.dart';

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';


class finance extends StatefulWidget {
  @override
  _financeState createState() => _financeState();
}

class _financeState extends State<finance> {
  bool isLoggedIn = false;


  logout() async {

    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new RootPage(auth: new Auth())
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[900],

      body: Column(
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              WavyHeader(),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Text("Finance",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 54.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 40,
                left: 300,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                left: 300,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        PopupMenuButton(
                          icon: new Icon(Icons.person, color: Colors.white,),
                          onSelected: (String value) {
                            switch (value) {
                              case 'logout':
                                logout();
                                break;
                            // Other cases for other menu options
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              value: "logout",
                              child: Row(
                                children: <Widget>[
                                  Text("LOGOUT"),
                                  Icon(Icons.exit_to_app, color: Colors.pink[900],),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(FadeRouteBuilder(page: new Funds()));
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      child: Container(
                        width: 200,
                        height: 200.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Icon(Icons.attach_money, size: 50.0, color: Colors.pink[900],)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Funds', style: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _GridItemWidget extends StatelessWidget {
  final GridItem gridItem;

  _GridItemWidget(this.gridItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(FadeRouteBuilder(page: gridItem.widgetScreen)),
      child: GridTile(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.025),
          child: new Material(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.shortestSide * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(
                      flex: 5,
                    ),
                    Hero(
                      tag: gridItem.title,
                      child: Text(
                        gridItem.title,
                        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
                      ),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                    Icon(
                      gridItem.icon,
                      size: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white,
                    ),
                    Spacer(
                      flex: 5,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - (size.width / 4),
      size.height,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class GridItem {
  final List<Color> colorList;
  final IconData icon;
  final String title;
  final Widget widgetScreen;

  GridItem(this.colorList, this.icon, this.title, this.widgetScreen);
}