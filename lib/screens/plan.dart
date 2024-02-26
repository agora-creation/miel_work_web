import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const PlanScreen({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: sfc.SfCalendar(
          view: sfc.CalendarView.month,
          showNavigationArrow: true,
          headerDateFormat: 'yyyy年MM月',
          onTap: (calendarTapDetails) {},
        ),
      ),
    );
  }
}
