import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan_center.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan_center.dart';
import 'package:miel_work_web/screens/plan_center_timeline.dart';
import 'package:miel_work_web/services/plan_center.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_calendar.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlanCenterScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanCenterScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanCenterScreen> createState() => _PlanCenterScreenState();
}

class _PlanCenterScreenState extends State<PlanCenterScreen> {
  EventController controller = EventController();
  PlanCenterService centerService = PlanCenterService();
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
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '食器センター予定表',
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
                CustomIconTextButton(
                  label: '食器センター予定を追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  leftIcon: FontAwesomeIcons.plus,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddCenterDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      day: DateTime.now(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: centerService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: days.first,
                  searchEnd: days.last,
                ),
                builder: (context, snapshot) {
                  List<PlanCenterModel> centers = [];
                  if (snapshot.hasData) {
                    centers = centerService.generateList(
                      data: snapshot.data,
                    );
                  }
                  if (centers.isNotEmpty) {
                    for (final center in centers) {
                      controller.add(CalendarEventData(
                        title: center.content,
                        date: center.eventAt,
                      ));
                    }
                  }
                  return CustomCalendar(
                    controller: controller,
                    initialMonth: searchMonth,
                    cellAspectRatio: 1,
                    onCellTap: (events, day) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: PlanCenterTimelineScreen(
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

class AddCenterDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const AddCenterDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<AddCenterDialog> createState() => _AddGarbagemanDialogState();
}

class _AddGarbagemanDialogState extends State<AddCenterDialog> {
  TextEditingController contentController = TextEditingController();
  DateTime eventAt = DateTime.now();

  @override
  void initState() {
    eventAt = widget.day;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final centerProvider = Provider.of<PlanCenterProvider>(context);
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormLabel(
              '内容',
              child: CustomTextField(
                controller: contentController,
                textInputType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            FormLabel(
              '予定日',
              child: FormValue(
                dateText('yyyy/MM/dd', eventAt),
                onTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  init: eventAt,
                  title: '予定日を選択',
                  onChanged: (value) {
                    setState(() {
                      eventAt = value;
                    });
                  },
                  datetime: false,
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
            String? error = await centerProvider.create(
              organization: widget.loginProvider.organization,
              content: contentController.text,
              eventAt: eventAt,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '食器センター予定が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
