import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[900],
      appBar: AppBar(
        title: Text("Help and support"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.pink[900],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpansionTile(title: Text("Login / Sign up"),
            children: <Widget>[
              ListTile(
                title: Text("How do I signup?", style: TextStyle(fontWeight: FontWeight.bold,),),
                subtitle: Flexible (child: Text(' If you have not previously logged into our system then click on -Create account - found below the login button at the bottom of the page and once the account is created, sign in using your created detail. You might have to wait for a short while for the system admin to approve your registration.')),
              ),
              ListTile(
                title: Text("What are the signup requirements?", style: TextStyle(fontWeight: FontWeight.bold,),),
                subtitle: Flexible (child: Text('To sign up, you need to \n • Be an alumni of KeMU, with a valid registration number. \n • Have a valid email Address. \n • use a password that has atleast 5 characters.')),
              )
            ],
            ),
            ExpansionTile(title: Text("About KeMU-AA"),
              children: <Widget>[
                ListTile(
                  title: Text("What is KeMU-AA", style: TextStyle(fontWeight: FontWeight.bold,),),
                  subtitle: Flexible (child: Text(' KeMUAA android application is the application that will help former student to know and to be updated of the events going through. It will allow administrative to post those kind of event, when and where the events will take place.')),
                ),
                ListTile(
                  title: Text("What are the different interfaces?", style: TextStyle(fontWeight: FontWeight.bold,),),
                  subtitle: Flexible (child: Text('The interfaces included are: \n • Home page- The central navigation point for all other interfaces \n • News- Get updated on news about the university. \n • Courses- Further your studies by looking at the courses offered at the university. \n • Jobs- see job postings by your fellow alumni. \n • Contributions- Make a donation to help us carry out more events and programs. \n • Elections- Participate in electing the next leaders. \n • Events- RSVP to attend events organized by the alumni associationm.')),
                )
              ],
            ),


          ],
        ),
      ),
    );
  }
}
