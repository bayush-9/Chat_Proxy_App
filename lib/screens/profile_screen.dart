import 'package:chat_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activeUser = Provider.of<User>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("My profile"),
        ),
        body: Column(
          children: [
            Text(activeUser.email),
            Text(activeUser.userName),
          ],
        ));
  }
}
