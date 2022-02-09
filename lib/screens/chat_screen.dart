import 'package:chat_app/providers/group.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/screens/group_details_screen.dart';
import 'package:chat_app/screens/proxy_managing_screen.dart';
import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chats-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String username;

  var _enteredMessage = '';

  var _message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScrollController listScrollController = ScrollController();

    final activeGroup = Provider.of<Groups>(context, listen: false).activeGroup;
    final userId = Provider.of<User>(context, listen: false).userId;
    void _sendMessage() {
      if (listScrollController.hasClients) {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      }
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Provider.of<Groups>(context, listen: false).unactivateGroup();
            Navigator.of(context).pop();
          },
        ),
        title: InkWell(
          child: Text(
              Provider.of<Groups>(context, listen: false).activeGroup.name),
          onTap: () => Navigator.pushNamed(context, GroupDetails.routeName),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ProxyManagementScreen.routeName),
              icon: Icon(Icons.precision_manufacturing_outlined))
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    StreamBuilder(
                      builder: (ctx, chatSnapshot) {
                        // if (chatSnapshot.connectionState == ConnectionState.waiting) {
                        //   return Container(height: 200, child: CircularProgressIndicator());
                        // }
                        final chatDocs = chatSnapshot.data.documents;
                        if (chatDocs.length == 0) {
                          return Text("NO message yet");
                        }
                        if (listScrollController.hasClients) {
                          final position =
                              listScrollController.position.maxScrollExtent;
                          listScrollController.jumpTo(position);
                        }
                        return ListView.builder(
                          controller: listScrollController,
                          itemBuilder: (context, index) => MessageBubble(
                            chatDocs[index]['username'],
                            chatDocs[index]['text'],
                            chatDocs[index]['userId'] == userId,
                            chatDocs[index]['userId'].toString().trim(),
                          ),
                          itemCount: chatDocs.length,
                        );
                      },
                      stream: Firestore.instance
                          .collection('groups')
                          .document(activeGroup.id)
                          .collection('chats')
                          .orderBy('timeStamp')
                          .snapshots(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 50.0,
                          left: MediaQuery.of(context).size.width - 40),
                      child: FloatingActionButton(
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        elevation: 0,
                        child: Container(
                            height: 50,
                            child: Icon(Icons.arrow_downward_rounded)),
                        backgroundColor: Colors.blue.withOpacity(0.5),
                        onPressed: () {
                          if (listScrollController.hasClients) {
                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                          }
                        },
                      ),
                    ),
                  ]),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration:
                          InputDecoration(labelText: 'Send a message..'),
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.blue),
                    onPressed:
                        _enteredMessage.trim().isEmpty ? null : _sendMessage,
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
