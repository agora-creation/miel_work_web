import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';

class ApprovalUserList extends StatelessWidget {
  final ApprovalUserModel approvalUser;

  const ApprovalUserList({
    required this.approvalUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        title: Text(
          approvalUser.userName,
          style: approvalUser.userPresident
              ? const TextStyle(
                  color: kRedColor,
                  fontWeight: FontWeight.bold,
                )
              : null,
        ),
        trailing: Text(
          dateText('yyyy/MM/dd HH:mm', approvalUser.approvedAt),
          style: const TextStyle(
            color: kRedColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
