import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemu_alumni/loginUI/auth.dart';
import 'package:kemu_alumni/loginUI/root.dart';
import 'mpesa/mpesa_flutter_plugin.dart';


void main(){
  MpesaFlutterPlugin.setConsumerKey('hwjt1AQ4c7lRDexArlWwgtjfQYlraMMO');
  MpesaFlutterPlugin.setConsumerSecret('fauvPwIHPhGmUl3E');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeMU-AA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home: new RootPage(auth: new Auth())
    );
  }
}

