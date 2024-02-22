import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';

class ChatScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const ChatScreen({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('各個人やグループ、団体に対してやりとりができるチャットルームを表示します。'),
            Text('グループを選択している場合は、選択したグループと、そのグループに所属している個人のみ表示します。'),
            Text('グループを選択していない場合は、全てのグループと個人を表示します。'),
            SizedBox(height: 8),
            Text('左側にルーム一覧、右側にチャット画面'),
          ],
        ),
      ),
    );
  }
}
