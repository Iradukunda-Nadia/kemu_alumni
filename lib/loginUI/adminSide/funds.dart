import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'eventfunds.dart';

class Funds extends StatefulWidget {
  @override
  _FundsState createState() => _FundsState();
}

class _FundsState extends State<Funds> {
  final _renderObjectKey = GlobalKey<ScaffoldState>();
  FirebaseUser user;
  FirebaseAuth _auth;

  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  String _btnText;
  bool _isSignedIn = false;
  String _cont;
  int _contri;
  String contString;
  int total = 0;
  int newTotal;


  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
    getTotal();
  }

  Future getData() async{

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("receipt").getDocuments();
    return qn.documents;

  }

  CollectionReference collectionReference =
  Firestore.instance.collection("receipt");


  Future _getCurrentUser() async {
    await _auth.currentUser().then((user) {
      //_getCartCount();
      if (user != null) {
        setState(() {
          _btnText = "Logout";
          _isSignedIn = true;
          email = user.email;
          fullName = user.displayName;
          profileImgUrl = user.photoUrl;
          user = user;

        });
      }
    });
  }
  Future getTotal() async {
    Firestore.instance.collection('receipt').where("event", isEqualTo: "KeMU AA ccontribution") // new entries first, date is one the entries btw
        .snapshots()
        .listen((QuerySnapshot querySnapshot){
      querySnapshot.documents.forEach((document)
      {
        setState(() {
          _cont = document['amount'];
          _contri = int.parse(_cont);
          newTotal = total += _contri;
          contString = newTotal.toString();
        });
      });
    }
    );
  }

  final formatCurrency = new NumberFormat.simpleCurrency();

  Future<void> _printScreen() async {
    final RenderRepaintBoundary boundary =
    _renderObjectKey.currentContext.findRenderObject();
    final ui.Image im = await boundary.toImage();
    final ByteData bytes =
    await im.toByteData(format: ui.ImageByteFormat.rawRgba);
    print('Print Screen ${im.width}x${im.height} ...');



    final bool result =
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) {
      final pdf.Document document = pdf.Document();

      final PdfImage image = PdfImage(document.document,
          image: bytes.buffer.asUint8List(),
          width: im.width,
          height: im.height);

      document.addPage(pdf.Page(
          pageFormat: format,
          build: (pdf.Context context) {
            return pdf.Center(
              child: pdf.Expanded(
                child: pdf.Image(image),
              ),
            ); // Center
          })); // Page

      return document.save();
    });

  }

  void htmlOpenLink() {
    String url = "https://restpack.io/html2pdf/save-as-pdf?private=true";
    html.window.print();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOTAL: KSH.${formatCurrency.format(newTotal)}', style: TextStyle(fontSize: 20),),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink[900],
        icon: Icon(Icons.attach_money),
        label: new Text('print report', style: TextStyle(fontSize: 20),),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () { MediaQuery.of(context).orientation == Orientation.portrait ? _printScreen() : htmlOpenLink();},
      ),
      body: RepaintBoundary(
        key: _renderObjectKey,
        child: Column(
          mainAxisSize:MainAxisSize.min,
          children: <Widget>[
            Center(
              child: new Text(
                "General Contribution",
                style: new TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w700),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: collectionReference.orderBy("date", descending: true).where("event", isEqualTo: "KeMU AA ccontribution").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data.documents.map((doc) {
                        return Column(
                          children: <Widget>[
                            new ListTile(
                              leading: new CircleAvatar(
                                child: new Icon(Icons.attach_money,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                              title: new Text("KSH. ${doc.data["amount"]}"),
                              subtitle: new Text("By: ${doc.data["email"]}.  \nDate: ${doc.data["date"]}."),
                              isThreeLine: true,


                            ),
                        Divider(),
                          ],
                        );



                      }).toList(),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class evFunds extends StatefulWidget {
  @override
  _evFundsState createState() => _evFundsState();
}

class _evFundsState extends State<evFunds> {
  TextEditingController dateCtl = TextEditingController();
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Events"),
        backgroundColor: Colors.pink[900],),
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
                          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new EventFundsDetail(


                            eventTitle: doc.data["title"],

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


