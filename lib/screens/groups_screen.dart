import 'package:chat_app/providers/user.dart' as luser;
import 'package:chat_app/widgets/groups/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  List<String> arr = [];

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text("Groups"),
      ),
      body: StreamBuilder(
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final userRef = FirebaseFirestore.instance.collection('groups');
          final userId =
              Provider.of<luser.User>(context, listen: false).userId.toString();
          print(FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("userGroups")
              .doc());

          userRef.get().then(
            (value) {
              value.docs.forEach(
                (element) {
                  widget.arr.add(element['documentId']);
                },
              );
            },
          );
          final chatDocs = chatSnapshot.data.documents;
          return ListView.builder(
            itemBuilder: (context, index) {
              print(index.toString());
              return GroupTile(chatDocs[index]['groupName'], widget.arr[index]);
            },
            itemCount: chatDocs.length,
          );
        },
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      ),
    );
  }
}
