import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/user.dart';

class UserList extends StatelessWidget {
  final UserModel user;

  const UserList({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        title: Text(user.name),
      ),
    );
  }
}
