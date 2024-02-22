import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';

class PlanShiftScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const PlanShiftScreen({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<PlanShiftScreen> createState() => _PlanShiftScreenState();
}

class _PlanShiftScreenState extends State<PlanShiftScreen> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('シフト表形式で、団体・グループ・個人の予定を表示します。'),
            Text('グループを選択している場合は、選択したグループの予定と、そのグループに所属している個人の予定のみ表示します。'),
            Text('グループを選択していない場合は、全ての予定を表示します。'),
          ],
        ),
      ),
    );
  }
}
