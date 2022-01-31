import 'package:chat_app/providers/group.dart';
import 'package:chat_app/screens/group_details_screen.dart';
import 'package:chat_app/screens/proxy_managing_screen.dart';
import 'package:chat_app/widgets/messages/messages.dart';
import 'package:chat_app/widgets/messages/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chats-screen';

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Messages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
