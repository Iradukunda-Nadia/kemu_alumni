import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Funds extends StatefulWidget {
  @override
  _FundsState createState() => _FundsState();
}

class _FundsState extends State<Funds> {
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
    Firestore.instance.collection('receipt') // new entries first, date is one the entries btw
        .snapshots()
        .listen((QuerySnapshot querySnapshot){
      querySnapshot.documents.forEach((document)
      {
        setState(() {
          _cont = document['amount'];
          _contri = int.parse(_cont);
          newTotal = total + _contri;
          contString = newTotal.toString();
        });
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contributions"),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink[900],
        icon: Icon(Icons.attach_money),
        label: new Text('TOTAL: KSH.${contString}', style: TextStyle(fontSize: 20),),
        //Widget to display inside Floating Action Button, can be `Text`, `Icon` or any widget.
        onPressed: () {},
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference.orderBy("date", descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.documents.map((doc) {
                    return new GestureDetector(
                      onTap: (){},
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
                                      subtitle: new Text("By: ${doc.data["email"]}"),


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
