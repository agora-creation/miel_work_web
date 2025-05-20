import 'package:board_datetime_picker/board_datetime_picker.dart';
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
import 'package:miel_work_web/screens/plan_guardsman_week.dart';
import 'package:miel_work_web/services/plan_guardsman.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/day_list.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  AutoScrollController controller = AutoScrollController();
  PlanGuardsmanService guardsmanService = PlanGuardsmanService();
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
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
    controller.scrollToIndex(
      DateTime.now().day,
      preferPosition: AutoScrollPosition.begin,
    );
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
                        PlanGuardsmanWeekScreen(
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
                  List<PlanGuardsmanModel> guardsMans = [];
                  if (snapshot.hasData) {
                    guardsMans = guardsmanService.generateList(
                      data: snapshot.data,
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                    ),
                    child: ListView.builder(
                      controller: controller,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        DateTime day = days[index];
                        return AutoScrollTag(
                          key: ValueKey(day.day),
                          controller: controller,
                          index: day.day,
                          child: DayList(
                            day,
                            child: Container(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            //     stream: guardsmanService.streamList(
            //       organizationId: widget.loginProvider.organization?.id,
            //       searchStart: days.first,
            //       searchEnd: days.last,
            //     ),
            //     builder: (context, snapshot) {
            //       controller = EventController();
            //       List<PlanGuardsmanModel> guardsMans = [];
            //       if (snapshot.hasData) {
            //         guardsMans = guardsmanService.generateList(
            //           data: snapshot.data,
            //         );
            //       }
            //       if (guardsMans.isNotEmpty) {
            //         List<CalendarEventData> events = [];
            //         for (final guardsman in guardsMans) {
            //           events.add(
            //             CalendarEventData(
            //               title:
            //                   '${dateText('HH:mm', guardsman.startedAt)}〜${dateText('HH:mm', guardsman.endedAt)} ${guardsman.remarks}',
            //               date: guardsman.startedAt,
            //               startTime: guardsman.startedAt,
            //               endTime: guardsman.endedAt,
            //             ),
            //           );
            //         }
            //         controller.addAll(events);
            //       }
            //       return CustomCalendar(
            //         controller: controller,
            //         globalKey: globalKey,
            //         initialMonth: searchMonth,
            //         cellAspectRatio: 1.5,
            //         onCellTap: (events, day) {
            //           Navigator.push(
            //             context,
            //             PageTransition(
            //               type: PageTransitionType.rightToLeft,
            //               child: PlanGuardsmanTimelineScreen(
            //                 loginProvider: widget.loginProvider,
            //                 homeProvider: widget.homeProvider,
            //                 day: day,
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
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
  TextEditingController remarksController = TextEditingController();

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
            String? error = await guardsmanProvider.create(
              organization: widget.loginProvider.organization,
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
