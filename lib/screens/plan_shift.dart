import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: sfc.SfCalendar(
          view: sfc.CalendarView.timelineMonth,
          showNavigationArrow: true,
          showDatePickerButton: true,
          headerDateFormat: 'yyyy年MM月',
          onTap: (calendarTapDetails) {
            print(calendarTapDetails.date);
          },
          onViewChanged: (viewChangedDetails) {
            print(viewChangedDetails.visibleDates);
          },
          resourceViewSettings: const sfc.ResourceViewSettings(
            visibleResourceCount: 5,
            showAvatar: false,
          ),
          dataSource: _ShiftDataSource(
            [],
            [
              sfc.CalendarResource(
                displayName: 'テスト一郎',
                id: '0001',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト二郎',
                id: '0002',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト三郎',
                id: '0003',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト四郎',
                id: '0004',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト五郎',
                id: '0005',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト六郎',
                id: '0006',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト七郎',
                id: '0007',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト八郎',
                id: '0008',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト九郎',
                id: '0009',
                color: kGrey300Color,
              ),
              sfc.CalendarResource(
                displayName: 'テスト十郎',
                id: '0010',
                color: kGrey300Color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShiftDataSource extends sfc.CalendarDataSource {
  _ShiftDataSource(
    List<sfc.Appointment> source,
    List<sfc.CalendarResource> resourceColl,
  ) {
    appointments = source;
    resources = resourceColl;
  }
}
