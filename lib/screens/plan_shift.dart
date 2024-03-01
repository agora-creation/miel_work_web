import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/models/plan_shift.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/screens/plan_shift_add.dart';
import 'package:miel_work_web/screens/plan_shift_mod.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/services/plan_shift.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_calendar_shift.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
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
  PlanShiftService planShiftService = PlanShiftService();
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
    var stream1 = planService.streamList(
      organizationId: widget.organization?.id,
      groupId: group?.id,
    );
    var stream2 = planShiftService.streamList(
      organizationId: widget.organization?.id,
      groupId: group?.id,
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
            QuerySnapshot<Map<String, dynamic>>>(
          streams: StreamTuple2(stream1!, stream2!),
          builder: (context, snapshot) {
            List<sfc.Appointment> source = [];
            if (snapshot.snapshot1.hasData) {
              for (DocumentSnapshot<Map<String, dynamic>> doc
                  in snapshot.snapshot1.data!.docs) {
                PlanModel plan = PlanModel.fromSnapshot(doc);
                source.add(sfc.Appointment(
                  id: plan.id,
                  resourceIds: plan.userIds,
                  subject: '[${plan.category}]${plan.subject}',
                  startTime: plan.startedAt,
                  endTime: plan.endedAt,
                  isAllDay: plan.allDay,
                  color: plan.color.withOpacity(0.5),
                  notes: 'plan',
                ));
              }
            }
            if (snapshot.snapshot2.hasData) {
              for (DocumentSnapshot<Map<String, dynamic>> doc
                  in snapshot.snapshot2.data!.docs) {
                PlanShiftModel planShift = PlanShiftModel.fromSnapshot(doc);
                source.add(sfc.Appointment(
                  id: planShift.id,
                  resourceIds: planShift.userIds,
                  subject: '勤務予定',
                  startTime: planShift.startedAt,
                  endTime: planShift.endedAt,
                  isAllDay: planShift.allDay,
                  color: kBlueColor,
                  notes: 'planShift',
                ));
              }
            }
            return CustomCalendarShift(
              dataSource: _ShiftDataSource(source, resourceColl),
              onTap: (details) {
                if (details.targetElement == sfc.CalendarElement.appointment ||
                    details.targetElement == sfc.CalendarElement.agenda) {
                  final sfc.Appointment appointmentDetails =
                      details.appointments![0];
                  String type = appointmentDetails.notes ?? '';
                  if (type == 'plan') {
                    showDialog(
                      context: context,
                      builder: (context) => PlanDialog(
                        planId: '${appointmentDetails.id}',
                        groups: widget.homeProvider.groups,
                      ),
                    );
                  } else if (type == 'planShift') {
                    showBottomUpScreen(
                      context,
                      PlanShiftModScreen(
                        organization: widget.organization,
                        planShiftId: '${appointmentDetails.id}',
                        groups: widget.homeProvider.groups,
                      ),
                    );
                  }
                } else if (details.targetElement ==
                    sfc.CalendarElement.calendarCell) {
                  DateTime? date = details.date;
                  if (date == null) return;
                  final userId = details.resource?.id;
                  if (userId == null) return;
                  showBottomUpScreen(
                    context,
                    PlanShiftAddScreen(
                      organization: widget.organization,
                      group: group,
                      userId: '$userId',
                      date: date,
                    ),
                  );
                }
              },
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

class PlanDialog extends StatefulWidget {
  final String planId;
  final List<OrganizationGroupModel> groups;

  const PlanDialog({
    required this.planId,
    required this.groups,
    super.key,
  });

  @override
  State<PlanDialog> createState() => _PlanDialogState();
}

class _PlanDialogState extends State<PlanDialog> {
  PlanService planService = PlanService();
  String titleText = '';
  String groupText = '';
  String dateTimeText = '';
  Color color = Colors.transparent;
  String memoText = '';

  void _init() async {
    PlanModel? plan = await planService.selectData(id: widget.planId);
    if (plan == null) {
      if (!mounted) return;
      showMessage(context, '予定データの取得に失敗しました', false);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }
    titleText = '[${plan.category}]${plan.subject}';
    for (OrganizationGroupModel group in widget.groups) {
      if (group.id == plan.groupId) {
        groupText = group.name;
      }
    }
    dateTimeText =
        '${dateText('yyyy/MM/dd HH:mm', plan.startedAt)}〜${dateText('yyyy/MM/dd HH:mm', plan.endedAt)}';
    color = plan.color;
    memoText = plan.memo;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        titleText,
        style: const TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: '公開グループ',
              child: Text(groupText),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '予定期間',
              child: Text(dateTimeText),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '色',
              child: Container(
                height: 20,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'メモ',
              child: Text(memoText),
            ),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
