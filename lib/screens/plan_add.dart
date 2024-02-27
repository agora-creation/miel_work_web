import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';

class PlanAddScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;
  final DateTime date;

  const PlanAddScreen({
    required this.organization,
    required this.group,
    required this.date,
    super.key,
  });

  @override
  State<PlanAddScreen> createState() => _PlanAddScreenState();
}

class _PlanAddScreenState extends State<PlanAddScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
          border: Border(bottom: BorderSide(color: kGrey300Color)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '予定の追加',
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoLabel(
              label: '件名',
            ),
          ],
        ),
      ),
    );
  }
}
