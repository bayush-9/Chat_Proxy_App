import 'package:chat_app/providers/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDetails extends StatelessWidget {
  static const routeName = '/group-details-screen';

  @override
  Widget build(BuildContext context) {
    CollectionReference users = Firestore.instance.collection('groups');

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
            return Column(
              children: [
                Text("Created on : ${dateTime.toString()} "),
                Text("Unique Joining code: ${data['uniqueId']}")
              ],
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}
