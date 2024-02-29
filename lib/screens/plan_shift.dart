import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/services/plan.dart';
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
  PlanService planService = PlanService();
  UserService userService = UserService();
  List<sfc.CalendarResource> resourceColl = [];

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
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: planService.streamList(
            organizationId: widget.organization?.id,
            groupId: group?.id,
          ),
          builder: (context, snapshot) {
            List<sfc.Appointment> source = [];
            if (snapshot.hasData) {
              for (DocumentSnapshot<Map<String, dynamic>> doc
                  in snapshot.data!.docs) {
                PlanModel plan = PlanModel.fromSnapshot(doc);
                source.add(sfc.Appointment(
                  id: plan.id,
                  resourceIds: plan.userIds,
                  subject: '[${plan.category}]${plan.subject}',
                  startTime: plan.startedAt,
                  endTime: plan.endedAt,
                  isAllDay: plan.allDay,
                  color: plan.color.withOpacity(0.5),
                  notes: plan.memo,
                ));
              }
            }
            source.add(sfc.Appointment(
              id: 'error',
              resourceIds: ['46uoaVOB1GdcFrIokYKi'],
              subject: '勤務',
              startTime: DateTime.now(),
              endTime: DateTime.now().add(const Duration(hours: 3)),
              isAllDay: false,
              color: kBlueColor,
              notes: '',
            ));
            return sfc.SfCalendar(
              view: sfc.CalendarView.timelineMonth,
              showNavigationArrow: true,
              showDatePickerButton: true,
              headerDateFormat: 'yyyy年MM月',
              onTap: (calendarTapDetails) {},
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
            );
          },
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
