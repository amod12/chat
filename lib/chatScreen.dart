import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _store = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller : controller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      controller.clear();
                      _store.collection('mesg').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Stream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.collection('mesg').orderBy('time',descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final message = snapshot.data!.docs;
            List<BubbleText> messageWidgets = [];
            for (var a in message) {
              final text = a.get('text');
              final sender = a.get('sender');
              final currentUser = loggedInUser.email;
              final time = a.get('time').toString();
              final b = BubbleText(sender, text, currentUser==sender, time);
              messageWidgets.add(b);

            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                children: messageWidgets,
              ),
            );
          } else {
            return SizedBox(
              height: 48.0,
            );
          }
        });
  }
}

class BubbleText extends StatelessWidget {
  String s = '';
  String t = '';
  String time='';
  bool isMe;

  BubbleText(this.s, this.t, this.isMe, this.time);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          //Text(time,
            //style: TextStyle(
              //fontSize: 15.0,
             // color: Colors.black,
            //),),
          Text(s,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),),
          Material(
            color: isMe? Colors.lightBlueAccent: Colors.white70,
            elevation: 5.0,
            borderRadius: isMe? BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ):
            BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),

            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                t,
                style: TextStyle(
                  color: isMe? Colors.white70: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
