import 'package:chat_app/widgets/groups/new_group_fields.dart';
import 'package:flutter/material.dart';

class NewGroupForm extends StatelessWidget {
  static const routeName = "/new-group";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Group"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: null,
            ),
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.image),
                label: Text("Group Icon")),
            NewGroupFields(),
          ],
        ),
      ),
    );
  }
}
