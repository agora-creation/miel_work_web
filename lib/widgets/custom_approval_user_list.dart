import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';

class CustomApprovalUserList extends StatelessWidget {
  final ApprovalUserModel approvalUser;

  const CustomApprovalUserList({
    required this.approvalUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      child: ListTile(
        title: Text(approvalUser.userName),
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
