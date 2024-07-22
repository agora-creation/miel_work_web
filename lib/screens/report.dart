import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/report.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/report_add.dart';
import 'package:miel_work_web/screens/report_mod.dart';
import 'package:miel_work_web/services/report.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/report_list.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';

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
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
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
                  backgroundColor: kLightBlueColor,
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
                Container(),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: reportService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchMonth: searchMonth,
                ),
                builder: (context, snapshot) {
                  List<ReportModel> reports = [];
                  if (snapshot.hasData) {
                    reports = reportService.generateList(
                      data: snapshot.data,
                    );
                  }
                  return ListView.builder(
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
                      return ReportList(
                        day: day,
                        isReport: report != null,
                        onTap: () {
                          if (report != null) {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ReportModScreen(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  report: report,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ReportAddScreen(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  day: day,
                                ),
                              ),
                            );
                          }
                        },
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
