import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mpesa/mpesa_flutter_plugin.dart';

class newEvents extends StatefulWidget {
  @override
  _newEventsState createState() => _newEventsState();
}

class _newEventsState extends State<newEvents> {
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("events").where("status", isEqualTo: "active").getDocuments();
    return qn.documents;

  }
  var number = TextEditingController();
  var amount = TextEditingController();
  String payment;
  String title;
  String eventdate;

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
        "status": "Rsvp for $title,",
        "event": title,
        "amount": payment,
        "date" : DateFormat(' dd MMM yyyy').format(DateTime.now()),
      }));

      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await Firestore.instance
          .collection("rsvp")
          .add({
        "event": title,
        "date": eventdate,
        "status": "RSVP",
        "name": user.email,
      }).then((result) =>
          showDialog(
            context: context,
            builder: (BuildContext context) {
// return object of type Dialog
              return AlertDialog(
                title: Text("Rsvp Confirmed!"),
                content: new Text("THANKYOU FOR YOUR CONTRIBUTION."),
                actions: <Widget>[
// usually buttons at the bottom of the dialog

                  new FlatButton(
                    child: new Text("CLOSE"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          )
      );


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
    return Scaffold(

      body: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          new Column(
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
                          child: Text("The are no saved events"),);
                      }else{
                        return Scrollbar(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: new Card(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Container(
                                        width: 200,
                                        height: 300.0,
                                        decoration: BoxDecoration(
                                            color: Colors.pink[50],
                                            borderRadius: BorderRadius.circular(20.0),
                                            border: Border.all(color: Colors.grey.withOpacity(.3), width: .2)),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                            Image.network(snapshot.data[index].data["image"], width: 281.0, height: 191.0),
                                            Text(snapshot.data[index].data["title"], style: TextStyle(fontSize: 24.0, fontFamily: "Raleway",color: Colors.white)),
                                            Text(snapshot.data[index].data["date"], style: TextStyle(fontSize: 12.0, fontFamily: "Raleway")),
                                            Container(
                                              height: 18,
                                              child: RaisedButton(
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
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              CupertinoButton(
                                                                child: Text("Proceed"),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    payment = snapshot.data[index].data["amount"];
                                                                    title = snapshot.data[index].data["title"];
                                                                    eventdate = snapshot.data[index].data["date"];
                                                                  });
                                                                  startCheckout(
                                                                      userPhone: number.text,
                                                                      amount: 1);
                                                                  Navigator.of(context).pop();
                                                                },
                                                              )
                                                            ],
                                                          ));

                                                },

                                                child: Text(
                                                  "RSVP- KSH:${snapshot.data[index].data["amount"]}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .apply(color: Colors.white, fontSizeDelta: 2),

                                                ),
                                                color: Colors.pink[900],

                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),

                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              );

                            },
                          ),
                        );

                      }
                    }),)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScrollThumb() {
    return new Container(
      height: 40.0,
      width: 20.0,
      color: Colors.pink[900],
    );
  }
}