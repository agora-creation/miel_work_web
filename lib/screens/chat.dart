import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: kGreyColor)),
          child: Row(
            children: [
              Container(
                width: 300,
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: kGreyColor)),
                ),
                child: ListView.builder(
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: kGreyColor)),
                      ),
                      child: ListTile(title: Text('スタッフ$index')),
                    );
                  },
                ),
              ),
              Expanded(child: Container(color: kGrey200Color)),
            ],
          ),
        ),
      ),
    );
  }
}
