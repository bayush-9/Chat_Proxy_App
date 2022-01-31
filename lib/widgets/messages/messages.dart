import 'package:chat_app/providers/group.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String username;

  @override
  Widget build(BuildContext context) {
    final activeGroup = Provider.of<Groups>(context, listen: false).activeGroup;
    final userId = Provider.of<User>(context, listen: false).userId;
    ScrollController listScrollController = ScrollController();
    return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
      StreamBuilder(
        builder: (ctx, chatSnapshot) {
          // if (chatSnapshot.connectionState == ConnectionState.waiting) {
          //   return Container(height: 200, child: CircularProgressIndicator());
          // }
          final chatDocs = chatSnapshot.data.documents;
          if (chatDocs.length == 0) {
            return Text("NO message yet");
          }
          return ListView.builder(
            controller: listScrollController,
            itemBuilder: (context, index) => MessageBubble(
                chatDocs[index]['username'],
                chatDocs[index]['text'],
                chatDocs[index]['userId'] == userId),
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
            bottom: 50.0, left: MediaQuery.of(context).size.width - 40),
        child: FloatingActionButton(
          elevation: 0,
          child: Icon(Icons.arrow_downward_rounded),
          backgroundColor: Colors.blue.withOpacity(0.5),
          onPressed: () {
            if (listScrollController.hasClients) {
              final position = listScrollController.position.maxScrollExtent;
              listScrollController.jumpTo(position);
            }
          },
        ),
      ),
    ]);
  }
}