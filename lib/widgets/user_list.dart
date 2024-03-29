import 'package:fluent_ui/fluent_ui.dart';
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
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      child: ListTile(
        title: Text(user.name),
      ),
    );
  }
}
