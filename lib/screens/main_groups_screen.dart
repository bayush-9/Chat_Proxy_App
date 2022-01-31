import 'package:chat_app/providers/group.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/widgets/groups/group_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Work2 extends StatefulWidget {
  List<GroupId> groupIdList = [];
  @override
  State<Work2> createState() => _Work2State();
}

class _Work2State extends State<Work2> {
  bool isloading = true;

  bool _checkConfiguration() => true;
  @override
  void initState() {
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero, () async {
        List<GroupId> groupIdListL = [];
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        final userId = user.uid;
        Provider.of<User>(context, listen: false).setUserId(userId);
        await Firestore.instance
            .collection("users")
            .document(userId.trim())
            .get()
            .then((value) {
          Provider.of<User>(context, listen: false)
              .setEmail(value.data['email']);
          Provider.of<User>(context, listen: false)
              .setUserName(value.data['username']);
          List.from(value.data['userGroups']).forEach((element) {
            var data = new GroupId(element.toString());
            print(data);
            groupIdListL.add(data);
          });
        });
        Provider.of<Groups>(context, listen: false)
            .setTotalGroups(groupIdListL);
        print("printing from provider");
        print(Provider.of<Groups>(context, listen: false).groupsList);
        setState(() {
          isloading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.groupIdList = Provider.of<Groups>(context).groupsList;
    print(widget.groupIdList);
    print("here");
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
      body: isloading
          ? CircularProgressIndicator()
          : GroupList(Provider.of<Groups>(context, listen: false).groupsList),
    );
  }
}