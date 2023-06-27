import 'package:flutter/material.dart';
import 'package:to_do_list/util/extension/extension.dart';

class MemberEmailItem extends StatelessWidget {
  const MemberEmailItem(
      {Key? key, required this.deleteMemberEmail, required this.nameEmail})
      : super(key: key);

  final Function deleteMemberEmail;
  final String nameEmail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        nameEmail,
        textScaleFactor: 1.5,
        style: TextStyle(color: Colors.black, fontSize: 13),
      ),
      trailing: Icon(Icons.delete, color: Colors.redAccent).inkTap(
          onTap:() => {deleteMemberEmail()},
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
