import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:kemu_alumni/tabs.dart';
import 'package:path/path.dart' as Path;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String name;
  String email;
  String reg;
  String img;
  String id;
  File _image;
  String _uploadedFileURL;


  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask upload = storageReference.putFile(_image,);
    StorageTaskSnapshot taskSnapshot=await upload.onComplete;

    String Imageurl = await taskSnapshot.ref.getDownloadURL();
    await Firestore.instance
        .collection('users')
        .document(id)
        .updateData({
      'img': Imageurl,
    });
    print('File Uploaded');
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new tabView()
    ));
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

      } else {
        querySnapshot.documents.forEach((document)
        async {


          setState(() {
            name = document['userName'];
            email = user.email;
            reg = document['reg'];
            img = document['img'];
            id = document.documentID;

          });



        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      backgroundColor: Colors.pink[900],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  CircleAvatar(
                    radius: 70,
                    child: img == null ? new Icon(Icons.person, color: Colors.white, size: 50,):
                    Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(img),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        )),
                  ),
                  GestureDetector(
                    onTap: (){
                      chooseFile();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.edit,
                        color: Colors.teal[900],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SourceSansPro',
                  color: Colors.red[400],
                  letterSpacing: 2.5,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 200,
                child: Divider(
                  color: Colors.teal[100],
                ),
              ),
              Text("We appreciate the support"),
              Card(
                  color: Colors.white,
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.assignment_ind,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      reg,
                      style:
                      TextStyle(fontFamily: 'BalooBhai', fontSize: 20.0),
                    ),
                  )),
              Card(
                color: Colors.white,
                margin:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.teal[900],
                  ),
                  title: Text(
                    email,
                    style: TextStyle(fontSize: 20.0, fontFamily: 'Neucha'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}