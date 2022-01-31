import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  ChatBubble(this.message);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 150,
              padding: EdgeInsets.all(5),
              child: Text(message),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
