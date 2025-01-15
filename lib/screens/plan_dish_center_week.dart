import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:miel_work_web/widgets/plan_work_list.dart';
import 'package:miel_work_web/widgets/report_table_td.dart';
import 'package:miel_work_web/widgets/report_table_th.dart';

class PlanDishCenterWeekScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanDishCenterWeekScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanDishCenterWeekScreen> createState() =>
      _PlanDishCenterWeekScreenState();
}

class _PlanDishCenterWeekScreenState extends State<PlanDishCenterWeekScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '食器センター勤務表：1週間分の予定を設定',
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
            Table(
              border: TableBorder.all(color: kGreyColor),
              children: [
                const TableRow(
                  children: [
                    ReportTableTh('日'),
                    ReportTableTh('月'),
                    ReportTableTh('火'),
                    ReportTableTh('水'),
                    ReportTableTh('木'),
                    ReportTableTh('金'),
                    ReportTableTh('土'),
                  ],
                ),
                TableRow(
                  children: [
                    ReportTableTd(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                          ],
                        ),
                        LinkText(
                          label: '新規追加',
                          color: kBlueColor,
                          onTap: () {},
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [],
                        ),
                        LinkText(
                          label: '新規追加',
                          color: kBlueColor,
                          onTap: () {},
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                          ],
                        ),
                        LinkText(
                          label: '新規追加',
                          color: kBlueColor,
                          onTap: () {},
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                          ],
                        ),
                        LinkText(
                          label: '新規追加',
                          color: kBlueColor,
                          onTap: () {},
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                          ],
                        ),
                        LinkText(
                          label: '新規追加',
                          color: kBlueColor,
                          onTap: () {},
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                          ],
                        ),
                        LinkText(
                          label: '新規追加',
                          color: kBlueColor,
                          onTap: () {},
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: const PlanWorkList('[田中]00:00～00:00'),
                              onTap: () {},
                            ),
                          ],
                        ),
                        LinkText(
                          label: '新規追加',
                          color: kBlueColor,
                          onTap: () {},
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  type: ButtonSizeType.sm,
                  label: '上記内容を『2025年01月』の1ヵ月分に反映する',
                  labelColor: kWhiteColor,
                  backgroundColor: kCyanColor,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                const SizedBox(width: 4),
                CustomButton(
                  type: ButtonSizeType.sm,
                  label: '上記内容で保存する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
