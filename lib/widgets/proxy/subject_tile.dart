import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  String lectureName;
  Function addPerson;
  int present;
  int absent;
  SubjectTile({this.lectureName, this.present, this.absent, this.addPerson});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lectureName + "      "),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.info_outline_rounded),
        ),
        Text(
          present.toString() + "/" + absent.toString() + "   ",
        ),
        IconButton(
          icon: Icon(Icons.group_add_sharp),
          onPressed: addPerson,
        ),
      ],
    );
  }
}
