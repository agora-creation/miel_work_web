import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/report.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/report_edit.dart';
import 'package:miel_work_web/services/report.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/day_list.dart';
import 'package:miel_work_web/widgets/report_list.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ReportScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ReportScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  AutoScrollController controller = AutoScrollController();
  ReportService reportService = ReportService();
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
          '業務日報',
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
                CustomIconTextButton(
                  label: '日報を作成',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  leftIcon: FontAwesomeIcons.plus,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ReportEditScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: reportService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: DateTime(
                    searchMonth.year,
                    searchMonth.month,
                    1,
                  ),
                  searchEnd: DateTime(
                    searchMonth.year,
                    searchMonth.month + 1,
                    1,
                  ).add(
                    const Duration(days: -1),
                  ),
                ),
                builder: (context, snapshot) {
                  List<ReportModel> reports = [];
                  if (snapshot.hasData) {
                    reports = reportService.generateList(
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
                        ReportModel? report;
                        if (reports.isNotEmpty) {
                          for (ReportModel tmpReport in reports) {
                            String dayKey = dateText(
                              'yyyy-MM-dd',
                              tmpReport.createdAt,
                            );
                            if (day == DateTime.parse(dayKey)) {
                              report = tmpReport;
                            }
                          }
                        }
                        return AutoScrollTag(
                          key: ValueKey(day.day),
                          controller: controller,
                          index: day.day,
                          child: DayList(
                            day,
                            child: ReportList(
                              report: report,
                              user: widget.loginProvider.user,
                              onTap: () {
                                if (report == null) return;
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ReportEditScreen(
                                      loginProvider: widget.loginProvider,
                                      homeProvider: widget.homeProvider,
                                      report: report,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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
