import 'package:chat_app/providers/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDetails extends StatelessWidget {
  static const routeName = '/group-details-screen';

  @override
  Widget build(BuildContext context) {
    CollectionReference users = Firestore.instance.collection('groups');
    Widget listTile(String txt1, String txt2) {
      return ListTile(
        title: Text(txt1 + txt2),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(Provider.of<Groups>(context, listen: false).activeGroup.name),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users
            .document(Provider.of<Groups>(context, listen: false).activeGroupId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data;
            final Timestamp timestamp = snapshot.data['timeStamp'] as Timestamp;
            final DateTime dateTime = timestamp.toDate();
            return ListView(
              children: [
                listTile("Created on : ", dateTime.toString()),
                listTile("Unique Joining code: ", data['uniqueId'])
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
