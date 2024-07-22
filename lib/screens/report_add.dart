import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/report.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';

class ReportAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const ReportAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<ReportAddScreen> createState() => _ReportAddScreenState();
}

class _ReportAddScreenState extends State<ReportAddScreen> {
  DateTime createdAt = DateTime.now();

  @override
  void initState() {
    createdAt = widget.day;
    super.initState();
  }

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
          '${dateText('MM月dd日(E)', widget.day)}の日報',
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await reportProvider.create(
                organization: widget.loginProvider.organization,
                createdAt: createdAt,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
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
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('④'),
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
                                  child: Text('⑤'),
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
                                  child: Text('⑥'),
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
                                  child: Text('⑦'),
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
                                  child: Text('⑧'),
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '入場者数カウント',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
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
                        const Text(
                          'コインロッカー',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: IntrinsicColumnWidth(),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('連続使用'),
                                ),
                                FormValue(
                                  '無',
                                  onTap: () {},
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('忘れ物'),
                                ),
                                FormValue(
                                  '無',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                                  child: Text('回収'),
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
                        const Text(
                          'イベント',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('主'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('周辺'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '集客',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '取材・視察',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '広場出店',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('使用料'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('入金状況'),
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
                        const Text(
                          '打合せ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'メールチェック',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
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
                        const Text(
                          '警戒',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        const Text('19:45～'),
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
                                  child: Text('状態'),
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
                                  child: Text('対処'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('23:00～'),
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
                                  child: Text('状態'),
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
                                  child: Text('対処'),
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
                        const Text(
                          '立替',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
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
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '営繕ヶ所等',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '状態',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '対処・修理・結果',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '苦情・要望・問題',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '対処・対応策',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
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
              const SizedBox(height: 16),
              const Text(
                'パンフレット',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
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
                        child: Text('④'),
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
                        child: Text('⑤'),
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
                        child: Text('⑥'),
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
                        child: Text('⑦'),
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
              const SizedBox(height: 16),
              const Text(
                '備品発注・入荷',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
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
                        child: Text('発注／入荷'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('品名'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('業者'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('納期(納入数)'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('発注者'),
                      ),
                    ],
                  ),
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
                        child: Text('④'),
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
                        child: Text('⑤'),
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
                        child: Text('⑥'),
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
              const SizedBox(height: 16),
              const Text(
                '報告・連絡',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  TableRow(
                    children: [
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
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
                        child: Text('日報最終確認'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '申送り事項',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  TableRow(
                    children: [
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '確認',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
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
                                  child: Text('最終店舗最終終了時刻'),
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
                                  child: Text('食器センター終了'),
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
                                  child: Text('排気'),
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
                                  child: Text('天井扇SW'),
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
                                  child: Text('空調SW'),
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
                                  child: Text('トイレ確認'),
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
                                  child: Text('ベビーコーナー'),
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
                                  child: Text('PC・ゴミ'),
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
                                  child: Text('留守電'),
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
                                  child: Text('クーポン券確認'),
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
                                  child: Text('日付確認'),
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
                                  child: Text('両替確認'),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'パスポート押印',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                                  child: Text('昨日計'),
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
                                  child: Text('本日計'),
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
            ],
          ),
        ),
      ),
    );
  }
}
