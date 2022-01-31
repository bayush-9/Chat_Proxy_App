import 'package:chat_app/providers/group.dart';
import 'package:chat_app/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var _enteredMessage = '';
  var _message = new TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    var activeGroupId =
        Provider.of<Groups>(context, listen: false).activeGroupId;
    var userId = Provider.of<User>(context, listen: false).userId;
    var userName = Provider.of<User>(context, listen: false).userName;
    Firestore.instance
        .collection('groups')
        .document(activeGroupId)
        .collection('chats')
        .add(
      {
        'text': _enteredMessage,
        'timeStamp': DateTime.now(),
        'userId': userId,
        'username': userName
      },
    );
    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _message,
              decoration: InputDecoration(labelText: 'Send a message..'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
