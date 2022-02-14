import 'package:chat_app/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activeUser = Provider.of<User>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("My profile"),
          shadowColor: Colors.blue,
        ),
        body: FutureBuilder(
            future: Firestore.instance
                .collection('users')
                .document(activeUser.userId.trim())
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    backgroundImage: NetworkImage(snapshot.data['userImage']),
                    radius: MediaQuery.of(context).size.width / 3,
                  ),
                  Card(
                    child: ListTile(
                      tileColor: Colors.black,
                      leading: Text(
                        "User Name: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).textTheme.headline1.color),
                      ),
                      title: Text(activeUser.userName,
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Text(
                        "Email Id: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      title: Text(activeUser.email,
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              );
            }));
  }
}
