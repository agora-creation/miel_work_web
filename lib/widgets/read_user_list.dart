import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/read_user.dart';

class ReadUserList extends StatelessWidget {
  final ReadUserModel readUser;

  const ReadUserList({
    required this.readUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      child: ListTile(
        title: Text(readUser.userName),
        trailing: Text(
          dateText('yyyy/MM/dd HH:mm', readUser.createdAt),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
