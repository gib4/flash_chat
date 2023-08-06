import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User loggedInUser;
  String messageText;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
      getCurrentUser();
    });

  }

  void getMessages() async{
    try{
      final messages = await _firestore.collection('messages').get();
      for (var message in messages.docs)
        {
          print (message.data());
        }
    }
    catch(e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()){
      for (var message in snapshot.docs)
      {
        print (message.data());
      }
    }
  }

  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print (loggedInUser.email);
      }
    }
    catch(e)
    {
      print (e);
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
                messagesStream();
                //_auth.signOut();
                //Navigator.pop(context);
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center (
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data.docs;
                List<Text> messageWidgets = [];
                for (var message in messages){
                  final messageText = message.get('text');
                  final messageSender = message.get('sender');

                  final messageWidget = Text('$messageText from $messageSender');
                  messageWidgets.add(messageWidget);
                }
                return Column(
                  children: messageWidgets,
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({'text': messageText, 'sender':loggedInUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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
