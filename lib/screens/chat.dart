import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/home.dart';

class ChatScreen extends StatefulWidget {
  final HomeProvider homeProvider;
  final OrganizationModel? organization;

  const ChatScreen({
    required this.homeProvider,
    required this.organization,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: kGreyColor)),
          child: Row(
            children: [
              Container(
                width: 250,
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: kGreyColor)),
                ),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: kGreyColor)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('スタッフ$index'),
                        trailing: const Icon(FluentIcons.chevron_right),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: kGrey200Color,
                  child: const Center(
                    child: Text('左側でスタッフもしくはグループを選んで、チャットする'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
