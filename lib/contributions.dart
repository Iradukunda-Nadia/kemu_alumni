import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mpesa/mpesa_flutter_plugin.dart';

class Contributions extends StatefulWidget {
  @override
  _ContributionsState createState() => _ContributionsState();
}

class _ContributionsState extends State<Contributions> {

  var number = TextEditingController();
  var amount = TextEditingController();
  DateTime now = DateTime.now();
  String formattedDate;

  String payment;
  ///Mpesa Checkout method
  ///This method requires the parameters User Phone and  the amount
  Future<void> startCheckout({String userPhone, int amount}) async {
    //Preferably expect 'dynamic', response type varies a lot!
    dynamic transactionInitialisation;

    //Better wrap in a try-catch for lots of reasons.
    try {
      //Run it
      transactionInitialisation =
      await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,

          ///Place the amount here
          amount: double.parse(amount.toString()),
          partyA: userPhone,
          partyB: "174379",
          callBackURL: Uri.parse("https://sandbox.safaricom.co.ke/"),
          accountReference: "KeMU AA",
          phoneNumber: userPhone,
          baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
          transactionDesc: "purchase",
          passKey:
          "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print("TRANSACTION RESULT: " + transactionInitialisation.toString());

      await FirebaseAuth.instance.currentUser()

          .then((user)=> Firestore.instance
          .collection("receipt")
          .document()
          .setData({
        "uid": user.uid,
        "email": user.email,
        "transaction ": transactionInitialisation.toString(),
        "status": "KeMU AA ccontribution",
        "event": "General contribution",
        "amount": payment,
        "date" : DateFormat(' dd MMM yyyy').format(now),
      })
          .then((result) =>
          Navigator.of(context).push(new CupertinoPageRoute(
              builder: (BuildContext context) => new  Detailed(
                itemNumber: user.email,
                itemAmount: payment,

              )
          )))

          .catchError((err) => print(err)))
          .catchError((err) => print(err));


      /*Update your db with the init data received from initialization response,
      * Remaining bit will be sent via callback url*/
      return transactionInitialisation;
    } catch (e) {
      //For now, console might be useful
      print("CAUGHT EXCEPTION: " + e.toString());
      return Text(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(

      body: Center(
        child: new Stack(
          alignment: Alignment.topCenter,
          children: [
            Stack(
              children: <Widget>[

                new Container(
                  height: 300.0,
                  decoration: new BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    borderRadius: new BorderRadius.only(
                      bottomRight: new Radius.circular(100.0),
                      bottomLeft: new Radius.circular(100.0),
                    ),
                  ),
                ),
                new SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      new SizedBox(
                        height: 50.0,
                      ),
                      new Card(
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 10.0,
                              ),
                              new Text("CONTRIBUTION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                              new SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Card(
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 10.0,
                              ),
                              new Text(
                                "Description",
                                style: new TextStyle(
                                    fontSize: 18.0, fontWeight: FontWeight.w700),
                              ),
                              new SizedBox(
                                height: 10.0,
                              ),
                              new Text(
                                "All contributions made go to further and improve processes in the university. If you believe the university paid a big part in making you the person you are today, why not give more people a chance to experience it for themselves? We accept financial support to facilitate organising of more beneficial forums for our Alumni. ",
                                style: new TextStyle(
                                    fontSize: 14.0, fontWeight: FontWeight.w400),
                              ),
                              new SizedBox(
                                height: 10.0,
                              ),
                              const SizedBox(height: 30),
                              RaisedButton(
                                onPressed: () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoActionSheet(
                                            title: Text(
                                                "Enter your mpesa number in the format defined"),
                                            message: Column(
                                              children: <Widget>[
                                                CupertinoTextField(
                                                  controller: number,
                                                  placeholder: '2547XXXXXXXX',
                                                ),
                                                new SizedBox(
                                                  height: 10.0,
                                                ),
                                                CupertinoTextField(
                                                  controller: amount,
                                                  placeholder: 'amount',
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              CupertinoButton(
                                                child: Text("Proceed"),
                                                onPressed: () {
                                                  setState(() {
                                                    payment = amount.text;
                                                  });
                                                  startCheckout(
                                                      userPhone: number.text,
                                                      amount: 1);
                                                },
                                              )
                                            ],
                                          ));

                                },
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF880E4F),
                                        Color(0xFFAD1457),
                                        Color(0xFFC2185B),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child:
                                  const Text('Make mpesa contribution', style: TextStyle(fontSize: 20)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Detailed extends StatefulWidget {


  String itemNumber;
  String itemAmount;

  Detailed({

    this.itemNumber,
    this.itemAmount,
  });



  @override
  _DetailedState createState() => _DetailedState();
}

class _DetailedState extends State<Detailed> {

  FirebaseUser user;
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text("Item Detail"),
        centerTitle: false,
      ),

      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 300.0,
            decoration: new BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(100.0),
                bottomLeft: new Radius.circular(100.0),
              ),
            ),
          ),
          new SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 50.0,
                ),
                new Card(
                  child: new Container(
                    width: screenSize.width,
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: new Text(
                            "Payment receipt",
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),

                      ],
                    ),
                  ),
                ),
                new Card(
                  child: new Container(
                    width: screenSize.width,
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Email",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemNumber,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 10.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Amount",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              "KSH.${widget.itemAmount}",
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 10.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Status",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              "Contribution made to KeMU AA",
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),





                        new SizedBox(
                          height: 10.0,
                        ),


                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Receipts extends StatefulWidget {
  @override
  _ReceiptsState createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {
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

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Receipts"),
        backgroundColor: Colors.pink[900],
      ),

      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference.where("email", isEqualTo:
            email).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.documents.map((doc) {
                    return new GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new ReceiptDetail(

                          itemEmail: doc.data["email"],
                          itemStatus: doc.data["status"],
                          itemDate: doc.data["date"].toString().substring(0,10),
                          itemAmount: doc.data["amount"],


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
                                  height:100.0 ,
                                  color: Colors.transparent,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:  new ListTile(
                                      leading: new CircleAvatar(
                                        child: new Icon(Icons.attach_money,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                      title: new Text("KSH. ${doc.data["amount"]}"),
                                      subtitle: new Text("Transaction date: ${doc.data["date"]}"),


                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return SizedBox();
              }
            }),

      ),
    );


  }
}

class ReceiptDetail extends StatefulWidget {

  String itemEmail;
  String itemStatus;
  String itemNumber;
  String itemDate;
  String itemAmount;
  String itemDescription;

  ReceiptDetail({

    this.itemEmail,
    this.itemStatus,
    this.itemNumber,
    this.itemDate,
    this.itemAmount,
    this.itemDescription
  });



  @override
  _ReceiptDetailState createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text("Item Detail"),
        centerTitle: false,
      ),

      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 300.0,
            decoration: new BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(100.0),
                bottomLeft: new Radius.circular(100.0),
              ),
            ),
          ),
          new SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 50.0,
                ),
                new Card(
                  child: new Container(
                    width: screenSize.width,
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: new Text(
                            "Payment receipt",
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),

                      ],
                    ),
                  ),
                ),
                new Card(
                  child: new Container(
                    width: screenSize.width,
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[




                        new SizedBox(
                          height: 10.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Amount",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              "KSH. ${widget.itemAmount}",
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 10.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Status",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemStatus,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 10.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Date",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemDate,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 10.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Email",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemEmail,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}