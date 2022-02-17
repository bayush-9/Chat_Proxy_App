import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  String lectureName;
  Function addPerson;
  Function removePerson;
  List<dynamic> userIds;
  int present;
  int absent;
  bool hasUpdated;

  SubjectTile(
      {this.lectureName,
      this.present,
      this.removePerson,
      this.userIds,
      this.absent,
      this.hasUpdated,
      this.addPerson});
  @override
  Widget build(BuildContext context) {
    showInfo() {
      print(userIds);
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("List of people"),
          content: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child:
                // Text("data")
                ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    print(snapshot.data['username']);
                    return Text(snapshot.data['username']);
                  },
                  future: Firestore.instance
                      .collection('users')
                      .document(userIds[index].toString().trim())
                      .get(),
                );
              },
              itemCount: userIds.length,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("okay"),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lectureName + "      ",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        IconButton(
          onPressed: showInfo,
          icon: Icon(Icons.info_outline_rounded),
        ),
        Text(
          present.toString() + "/" + absent.toString() + "   ",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        IconButton(
          icon: Icon(!hasUpdated
              ? Icons.group_add_sharp
              : Icons.person_remove_alt_1_outlined),
          onPressed: !hasUpdated ? addPerson : removePerson,
        ),
      ],
    );
  }
}
