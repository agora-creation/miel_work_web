import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan_guardsman.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan_guardsman.dart';
import 'package:miel_work_web/screens/plan_guardsman_timeline.dart';
import 'package:miel_work_web/services/plan_guardsman.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_calendar.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlanGuardsmanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanGuardsmanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanGuardsmanScreen> createState() => _PlanGuardsmanScreenState();
}

class _PlanGuardsmanScreenState extends State<PlanGuardsmanScreen> {
  EventController controller = EventController();
  GlobalKey<MonthViewState> globalKey = GlobalKey<MonthViewState>();
  PlanGuardsmanService guardsmanService = PlanGuardsmanService();
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
          '警備員勤務表',
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
                      locale: const Locale('ja'),
                    );
                    if (selected == null) return;
                    _changeMonth(selected);
                  },
                ),
                Row(
                  children: [
                    CustomIconTextButton(
                      label: '1週間テンプレート設定',
                      labelColor: kWhiteColor,
                      backgroundColor: kGreyColor,
                      leftIcon: FontAwesomeIcons.calendarWeek,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: '勤務予定を追加',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      leftIcon: FontAwesomeIcons.plus,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddGuardsmanDialog(
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
                stream: guardsmanService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: days.first,
                  searchEnd: days.last,
                ),
                builder: (context, snapshot) {
                  controller = EventController();
                  List<PlanGuardsmanModel> guardsMans = [];
                  if (snapshot.hasData) {
                    guardsMans = guardsmanService.generateList(
                      data: snapshot.data,
                    );
                  }
                  if (guardsMans.isNotEmpty) {
                    List<CalendarEventData> events = [];
                    for (final guardsman in guardsMans) {
                      events.add(CalendarEventData(
                        title:
                            '${dateText('HH:mm', guardsman.startedAt)}〜${dateText('HH:mm', guardsman.endedAt)}',
                        date: guardsman.startedAt,
                        startTime: guardsman.startedAt,
                        endTime: guardsman.endedAt,
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
                          child: PlanGuardsmanTimelineScreen(
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

class AddGuardsmanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const AddGuardsmanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<AddGuardsmanDialog> createState() => _AddGuardsmanDialogState();
}

class _AddGuardsmanDialogState extends State<AddGuardsmanDialog> {
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();

  @override
  void initState() {
    startedAt = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      9,
    );
    endedAt = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      23,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final guardsmanProvider = Provider.of<PlanGuardsmanProvider>(context);
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            FormLabel(
              '予定日時',
              child: DatetimeRangeForm(
                startedAt: startedAt,
                startedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
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
            String? error = await guardsmanProvider.create(
              organization: widget.loginProvider.organization,
              startedAt: startedAt,
              endedAt: endedAt,
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
