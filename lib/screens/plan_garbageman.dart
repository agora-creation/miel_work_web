import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan_garbageman.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan_garbageman.dart';
import 'package:miel_work_web/screens/plan_garbageman_timeline.dart';
import 'package:miel_work_web/screens/plan_garbageman_week.dart';
import 'package:miel_work_web/services/organization_group.dart';
import 'package:miel_work_web/services/plan_garbageman.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_calendar.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlanGarbagemanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanGarbagemanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanGarbagemanScreen> createState() => _PlanGarbagemanScreenState();
}

class _PlanGarbagemanScreenState extends State<PlanGarbagemanScreen> {
  EventController controller = EventController();
  GlobalKey<MonthViewState> globalKey = GlobalKey<MonthViewState>();
  PlanGarbagemanService garbagemanService = PlanGarbagemanService();
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    if (globalKey.currentState != null) {
      globalKey.currentState?.jumpToMonth(searchMonth);
    }
    setState(() {});
  }

  void _init() {
    days = generateDays(searchMonth);
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '清掃員勤務表',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomIconTextButton(
                  label: '年月検索: ${dateText('yyyy年MM月', searchMonth)}',
                  labelColor: kWhiteColor,
                  backgroundColor: kSearchColor,
                  leftIcon: FontAwesomeIcons.magnifyingGlass,
                  onPressed: () async {
                    DateTime? selected = await showMonthPicker(
                      context: context,
                      initialDate: searchMonth,
                      monthPickerDialogSettings:
                          const MonthPickerDialogSettings(
                        dialogSettings: PickerDialogSettings(
                          locale: Locale('ja'),
                        ),
                      ),
                    );
                    if (selected == null) return;
                    _changeMonth(selected);
                  },
                ),
                Row(
                  children: [
                    CustomIconTextButton(
                      label: '1週間分の予定を設定',
                      labelColor: kWhiteColor,
                      backgroundColor: kGreyColor,
                      leftIcon: FontAwesomeIcons.calendarWeek,
                      onPressed: () => showBottomUpScreen(
                        context,
                        PlanGarbagemanWeekScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          days: days,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: '勤務予定を追加',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      leftIcon: FontAwesomeIcons.plus,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddGarbagemanDialog(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          day: DateTime.now(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: garbagemanService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: days.first,
                  searchEnd: days.last,
                ),
                builder: (context, snapshot) {
                  controller = EventController();
                  List<PlanGarbagemanModel> garbageMans = [];
                  if (snapshot.hasData) {
                    garbageMans = garbagemanService.generateList(
                      data: snapshot.data,
                    );
                  }
                  if (garbageMans.isNotEmpty) {
                    List<CalendarEventData> events = [];
                    for (final garbageman in garbageMans) {
                      events.add(CalendarEventData(
                        title:
                            '[${garbageman.userName}]${dateText('HH:mm', garbageman.startedAt)}〜${dateText('HH:mm', garbageman.endedAt)} ${garbageman.remarks}',
                        date: garbageman.startedAt,
                        startTime: garbageman.startedAt,
                        endTime: garbageman.endedAt,
                      ));
                    }
                    controller.addAll(events);
                  }
                  return CustomCalendar(
                    controller: controller,
                    globalKey: globalKey,
                    initialMonth: searchMonth,
                    cellAspectRatio: 1.5,
                    onCellTap: (events, day) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: PlanGarbagemanTimelineScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            day: day,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddGarbagemanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const AddGarbagemanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<AddGarbagemanDialog> createState() => _AddGarbagemanDialogState();
}

class _AddGarbagemanDialogState extends State<AddGarbagemanDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  TextEditingController remarksController = TextEditingController();

  void _init() async {
    OrganizationGroupModel? group = await groupService.selectDataName(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      name: '清掃員',
    );
    if (group != null) {
      users = await userService.selectList(
        userIds: group.userIds,
      );
    }
    if (users.isNotEmpty) {
      selectedUser = users.first;
    }
    startedAt = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      8,
    );
    endedAt = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      20,
    );
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final garbagemanProvider = Provider.of<PlanGarbagemanProvider>(context);
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            FormLabel(
              'スタッフ選択',
              child: DropdownButton<UserModel?>(
                isExpanded: true,
                value: selectedUser,
                items: users.map((user) {
                  return DropdownMenuItem(
                    value: user,
                    child: Text(user.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUser = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            FormLabel(
              '予定日時',
              child: DatetimeRangeForm(
                startedAt: startedAt,
                startedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.datetime,
                  init: startedAt,
                  title: '予定開始日時を選択',
                  onChanged: (value) {
                    setState(() {
                      startedAt = value;
                    });
                  },
                ),
                endedAt: endedAt,
                endedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.datetime,
                  init: endedAt,
                  title: '予定終了日時を選択',
                  onChanged: (value) {
                    setState(() {
                      endedAt = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            FormLabel(
              '備考',
              child: CustomTextField(
                controller: remarksController,
                textInputType: TextInputType.text,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await garbagemanProvider.create(
              organization: widget.loginProvider.organization,
              user: selectedUser,
              startedAt: startedAt,
              endedAt: endedAt,
              remarks: remarksController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '勤務予定が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
