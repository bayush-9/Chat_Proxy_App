import 'package:chat_app/providers/group.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupTile extends StatelessWidget {
  final String groupName;
  final String groupId;
  GroupTile(this.groupName, this.groupId);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 4,
        shadowColor: Colors.blue,
        child: ListTile(
          tileColor: Theme.of(context).backgroundColor,
          onTap: () {
            Provider.of<Groups>(context, listen: false)
                .setActiveGroup(groupId, groupName);
            Navigator.of(context).pushNamed(ChatScreen.routeName);
          },
          leading: CircleAvatar(),
          title: Text(
            groupName,
            style: TextStyle(
                color: Theme.of(context).textTheme.button.color,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
