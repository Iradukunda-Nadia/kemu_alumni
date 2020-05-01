import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var _scaffoldContext;
class finFeedback extends StatefulWidget {
  String name;
  finFeedback({
    this.name,
});

  @override
  _finFeedbackState createState() => _finFeedbackState();
}

class _finFeedbackState extends State<finFeedback> {

  final TextEditingController _textEditingController =
  new TextEditingController();
  bool _isComposingMessage = false;
  final reference = Firestore.instance.collection('finFeedback');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Feedback"),
          backgroundColor: Colors.pink[900],
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new StreamBuilder<QuerySnapshot> (
                  stream: reference
                      .orderBy('time').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    return snapshot.hasData ? new ListView(
                      reverse: false,
                      children: snapshot.data.documents.map((DocumentSnapshot messageSnapshot) {
                        return new ChatMessageListItem(
                          messageSnapshot: messageSnapshot,
                          name: widget.name,
                        );
                      }).toList(),
                    ): const CircularProgressIndicator();

                  },
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(
                  top: new BorderSide(
                    color: Colors.grey[200],
                  )))
              : null,
        ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });
    _sendMessage(messageText: text, imageUrl: null);
  }

  Future<void> _sendMessage({String messageText, String imageUrl}) async {
    reference.add({
      'text': messageText,
      'imageUrl': imageUrl,
      'senderName': widget.name,
      'time': DateTime.now(),
    });
  }
}

class ChatMessageListItem extends StatelessWidget {
  final DocumentSnapshot messageSnapshot;
  final Animation animation;
  String name;

  ChatMessageListItem({this.messageSnapshot, this.animation, this.name});




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children:  name == messageSnapshot.data['senderName']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
              child: new Text(messageSnapshot.data['senderName'],
                  style: new TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
            ),
            new Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.pink[900],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              margin: const EdgeInsets.only(top: 5.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: messageSnapshot.data['imageUrl'] != null
                    ? new Image.network(
                  messageSnapshot.data['imageUrl'],
                  width: 250.0,
                )
                    : new Text(messageSnapshot.data['text'], style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),

    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[

      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
              child: new Text(messageSnapshot.data['senderName'],
                  style: new TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
            ),
            new Container(
              decoration: BoxDecoration(
                  color: Colors.pink[900],
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              margin: const EdgeInsets.only(top: 5.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: messageSnapshot.data['imageUrl'] != null
                    ? new Image.network(
                  messageSnapshot.data['imageUrl'],
                  width: 250.0,
                )
                    : new Text(messageSnapshot.data['text'], style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

class acFeedback extends StatefulWidget {
  String name;
  acFeedback({
    this.name,
  });

  @override
  _acFeedbackState createState() => _acFeedbackState();
}

class _acFeedbackState extends State<acFeedback> {

  final TextEditingController _textEditingController =
  new TextEditingController();
  bool _isComposingMessage = false;
  final reference = Firestore.instance.collection('acFeedback');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Feedback"),
          backgroundColor: Colors.pink[900],
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new StreamBuilder<QuerySnapshot> (
                  stream: reference
                      .orderBy('time').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    return snapshot.hasData ? new ListView(
                      reverse: false,
                      children: snapshot.data.documents.map((DocumentSnapshot messageSnapshot) {
                        return new ChatMessageListItem(
                          messageSnapshot: messageSnapshot,
                          name: widget.name,
                        );
                      }).toList(),
                    ): const CircularProgressIndicator();

                  },
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(
                  top: new BorderSide(
                    color: Colors.grey[200],
                  )))
              : null,
        ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });
    _sendMessage(messageText: text, imageUrl: null);
  }

  Future<void> _sendMessage({String messageText, String imageUrl}) async {
    reference.add({
      'text': messageText,
      'imageUrl': imageUrl,
      'senderName': widget.name,
      'time': DateTime.now(),
    });
  }
}