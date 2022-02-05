import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.userName, this.message, this.isMe, this.userId);

  final String message;
  final String userName;
  final bool isMe;
  final String userId;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future:
          Firestore.instance.collection('users').document(userId.trim()).get(),
      builder: (context, snapshot) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: isMe ? Colors.grey[300] : Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft:
                          !isMe ? Radius.circular(0) : Radius.circular(12),
                      bottomRight:
                          isMe ? Radius.circular(0) : Radius.circular(12),
                    ),
                  ),
                  // width: width / 2.5,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        message,
                        style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: -10,
              left: isMe ? width - 43 : 3,
              child: CircleAvatar(
                backgroundImage: snapshot.data != null
                    ? NetworkImage(snapshot.data['userImage'])
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
