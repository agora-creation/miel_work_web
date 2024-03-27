import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/plan.dart';
import 'package:miel_work_web/screens/plan_shift_add.dart';
import 'package:miel_work_web/screens/plan_shift_mod.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/services/plan_shift.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_calendar_shift.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanShiftScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanShiftScreen({
    required this.loginProvider,
    required this.homeProvider,
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
  List<String> searchCategories = [];

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _calendarTap(sfc.CalendarTapDetails details) {
    sfc.CalendarElement element = details.targetElement;
    switch (element) {
      case sfc.CalendarElement.appointment:
      case sfc.CalendarElement.agenda:
        sfc.Appointment appointmentDetails = details.appointments![0];
        String type = appointmentDetails.notes ?? '';
        if (type == 'plan') {
          showDialog(
            context: context,
            builder: (context) => PlanDialog(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
              planId: '${appointmentDetails.id}',
            ),
          );
        } else if (type == 'planShift') {
          Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => PlanShiftModScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                planShiftId: '${appointmentDetails.id}',
              ),
            ),
          );
        }
        break;
      case sfc.CalendarElement.calendarCell:
        final userId = details.resource?.id;
        if (userId == null) return;
        Navigator.push(
          context,
          FluentPageRoute(
            builder: (context) => PlanShiftAddScreen(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
              userId: '$userId',
              date: details.date ?? DateTime.now(),
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  void _getUsers() async {
    List<UserModel> users = [];
    if (widget.homeProvider.currentGroup == null) {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.homeProvider.currentGroup?.userIds ?? [],
      );
    }
    if (users.isNotEmpty) {
      for (UserModel user in users) {
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
    _searchCategoriesChange();
  }

  @override
  Widget build(BuildContext context) {
    var stream1 = planService.streamList(
      organizationId: widget.loginProvider.organization?.id,
      groupId: widget.homeProvider.currentGroup?.id,
      categories: searchCategories,
    );
    var stream2 = planShiftService.streamList(
      organizationId: widget.loginProvider.organization?.id,
      groupId: widget.homeProvider.currentGroup?.id,
    );
    return Stack(
      children: [
        const AnimationBackground(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButtonSm(
                      icon: FluentIcons.search,
                      labelText: 'カテゴリから予定検索',
                      labelColor: kWhiteColor,
                      backgroundColor: kLightBlueColor,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SearchCategoryDialog(
                          loginProvider: widget.loginProvider,
                          searchCategoriesChange: _searchCategoriesChange,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
                      QuerySnapshot<Map<String, dynamic>>>(
                    streams: StreamTuple2(stream1!, stream2!),
                    builder: (context, snapshot) {
                      List<sfc.Appointment> source = [];
                      if (snapshot.snapshot1.hasData) {
                        source = planService.generateListAppointment(
                          data: snapshot.snapshot1.data,
                          shift: true,
                        );
                      }
                      if (snapshot.snapshot2.hasData) {
                        source.addAll(planShiftService.generateListAppointment(
                          data: snapshot.snapshot2.data,
                        ));
                      }
                      return CustomCalendarShift(
                        dataSource: _ShiftDataSource(source, resourceColl),
                        onTap: _calendarTap,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String planId;

  const PlanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.planId,
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
    for (OrganizationGroupModel group in widget.homeProvider.groups) {
      if (group.id == plan.groupId) {
        groupText = group.name;
      }
    }
    dateTimeText =
        '${dateText('yyyy/MM/dd HH:mm', plan.startedAt)}〜${dateText('yyyy/MM/dd HH:mm', plan.endedAt)}';
    color = plan.categoryColor;
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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: color,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Text(
                titleText,
                style: const TextStyle(color: kWhiteColor),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '公開グループ',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(groupText),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '予定期間',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(dateTimeText),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'メモ',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(memoText),
              ),
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
