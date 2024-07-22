import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/report.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/report.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';

class ReportModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ReportModel report;

  const ReportModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.report,
    super.key,
  });

  @override
  State<ReportModScreen> createState() => _ReportModScreenState();
}

class _ReportModScreenState extends State<ReportModScreen> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: kBlackColor,
            size: 16,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${dateText('MM月dd日(E)', widget.report.createdAt)}の日報',
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '削除する',
            labelColor: kWhiteColor,
            backgroundColor: kRedColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelReportDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                report: widget.report,
              ),
            ),
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await reportProvider.update(
                report: widget.report,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '日報が保存されました', true);
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '本日の出勤者',
                          style: TextStyle(fontSize: 18),
                        ),
                        const Text('インフォメーション'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('①'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('②'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('③'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('④'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑤'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑥'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑦'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑧'),
                                ),
                                FormValue(
                                  '浜田',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '8:00～17:00',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text('清掃'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('①'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('②'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('③'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text('警備'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('①'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('②'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('③'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text('自転車整理'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('①'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('②'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('③'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '入場者数カウント',
                          style: TextStyle(fontSize: 18),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(''),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('12:30'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('20:00'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('22:00'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('お城下広場'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('いごっそう'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('自由広場'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('東通路(バル)'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('計'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('前年同曜日'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          'コインロッカー',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormLabel(
                          '連続使用',
                          child: FormValue(
                            '',
                            onTap: () {},
                          ),
                        ),
                        FormLabel(
                          '忘れ物',
                          child: FormValue(
                            '',
                            onTap: () {},
                          ),
                        ),
                        FormLabel(
                          '回収',
                          child: FormValue(
                            '',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'イベント',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormLabel(
                          '主',
                          child: FormValue(
                            '',
                            onTap: () {},
                          ),
                        ),
                        FormLabel(
                          '周辺',
                          child: FormValue(
                            '',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '集客',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '取材・視察',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '広場出店',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        FormLabel(
                          '使用料',
                          child: FormValue(
                            '',
                            onTap: () {},
                          ),
                        ),
                        FormLabel(
                          '入金状況',
                          child: FormValue(
                            '',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '打合せ',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          'メールチェック',
                          style: TextStyle(fontSize: 18),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('10:30'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('12:00'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('18:00'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('22:00'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '警戒',
                          style: TextStyle(fontSize: 18),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('19:45～'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('23:00～'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '立替',
                          style: TextStyle(fontSize: 18),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('立替'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('現金'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('合計'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: kGreyColor, height: 1),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '営繕ヶ所等',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '苦情・要望・問題',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '状態',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '対処・対応策',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '対処・修理・結果',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kGreyColor, height: 1),
                        const SizedBox(height: 8),
                        const Text(
                          '報告・連絡',
                          style: TextStyle(fontSize: 18),
                        ),
                        FormValue(
                          '',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'パンフレット',
                        style: TextStyle(fontSize: 18),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: kGreyColor, height: 1),
                      const SizedBox(height: 8),
                      const Text(
                        '備品発注・入荷',
                        style: TextStyle(fontSize: 18),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: kGreyColor, height: 1),
              const SizedBox(height: 8),
              const Text(
                '申送り事項',
                style: TextStyle(fontSize: 18),
              ),
              FormValue(
                '',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              const Divider(color: kGreyColor, height: 1),
              const SizedBox(height: 8),
              const Text(
                '確認',
                style: TextStyle(fontSize: 18),
              ),
              FormValue(
                '',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DelReportDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ReportModel report;

  const DelReportDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.report,
    super.key,
  });

  @override
  State<DelReportDialog> createState() => _DelReportDialogState();
}

class _DelReportDialogState extends State<DelReportDialog> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
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
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await reportProvider.delete(
              report: widget.report,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '日報が削除されました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
