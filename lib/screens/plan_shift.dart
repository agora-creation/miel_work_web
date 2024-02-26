import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanShiftScreen extends StatefulWidget {
  final HomeProvider homeProvider;
  final OrganizationModel? organization;

  const PlanShiftScreen({
    required this.homeProvider,
    required this.organization,
    super.key,
  });

  @override
  State<PlanShiftScreen> createState() => _PlanShiftScreenState();
}

class _PlanShiftScreenState extends State<PlanShiftScreen> {
  UserService userService = UserService();
  List<sfc.CalendarResource> resourceColl = [];
  List<sfc.Appointment> source = [];

  void _getUsers() async {
    List<UserModel> tmpUsers = [];
    if (widget.homeProvider.currentGroup == null) {
      tmpUsers = await userService.selectList(
        userIds: widget.organization?.userIds ?? [],
      );
    } else {
      tmpUsers = await userService.selectList(
        userIds: widget.homeProvider.currentGroup?.userIds ?? [],
      );
    }
    if (tmpUsers.isNotEmpty) {
      for (UserModel user in tmpUsers) {
        resourceColl.add(sfc.CalendarResource(
          displayName: user.name,
          id: user.id,
          color: kGrey300Color,
        ));
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

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
            displayNameTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          cellBorderColor: kGrey600Color,
          dataSource: _ShiftDataSource(source, resourceColl),
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
