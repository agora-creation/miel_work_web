import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/models/report_check.dart';
import 'package:miel_work_web/models/report_equipment.dart';
import 'package:miel_work_web/models/report_locker.dart';
import 'package:miel_work_web/models/report_pamphlet.dart';
import 'package:miel_work_web/models/report_plan.dart';
import 'package:miel_work_web/models/report_problem.dart';
import 'package:miel_work_web/models/report_repair.dart';
import 'package:miel_work_web/models/report_visitor.dart';
import 'package:miel_work_web/models/report_worker.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/report.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/services/problem.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/report_confirm_button.dart';
import 'package:miel_work_web/widgets/report_table_button.dart';
import 'package:miel_work_web/widgets/report_table_th.dart';
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
  PlanService planService = PlanService();
  ProblemService problemService = ProblemService();
  DateTime createdAt = DateTime.now();
  List<ReportWorkerModel> reportWorkers = [];
  ReportVisitorModel reportVisitor = ReportVisitorModel.fromMap({});
  ReportLockerModel reportLocker = ReportLockerModel.fromMap({});
  List<ReportPlanModel> reportPlans = [];
  ReportCheckModel reportCheck = ReportCheckModel.fromMap({});
  int advancePayment1 = 0;
  int advancePayment2 = 0;
  List<ReportRepairModel> reportRepairs = [];
  List<ReportProblemModel> reportProblems = [];
  List<ReportPamphletModel> reportPamphlets = [];
  List<ReportEquipmentModel> reportEquipments = [];
  String passport = '';
  int passportCount = 0;
  String remarks = '';
  String agenda = '';
  bool lastConfirmShop = false;
  DateTime lastConfirmShopAt = DateTime.now();
  String lastConfirmShopName = '';
  bool lastConfirmCenter = false;
  DateTime lastConfirmCenterAt = DateTime.now();
  bool lastConfirmExhaust = false;
  DateTime lastConfirmExhaustAt = DateTime.now();
  bool lastConfirmRoof = false;
  DateTime lastConfirmRoofAt = DateTime.now();
  bool lastConfirmAirCon = false;
  DateTime lastConfirmAirConAt = DateTime.now();
  bool lastConfirmToilet = false;
  DateTime lastConfirmToiletAt = DateTime.now();
  bool lastConfirmBaby = false;
  DateTime lastConfirmBabyAt = DateTime.now();
  bool lastConfirmPC = false;
  DateTime lastConfirmPCAt = DateTime.now();
  bool lastConfirmTel = false;
  DateTime lastConfirmTelAt = DateTime.now();
  bool lastConfirmCoupon = false;
  DateTime lastConfirmCouponAt = DateTime.now();
  bool lastConfirmCalendar = false;
  DateTime lastConfirmCalendarAt = DateTime.now();
  bool lastConfirmMoney = false;
  DateTime lastConfirmMoneyAt = DateTime.now();
  bool lastConfirmLock = false;
  DateTime lastConfirmLockAt = DateTime.now();
  bool lastConfirmUser = false;
  DateTime lastConfirmUserAt = DateTime.now();
  String lastConfirmUserName = '';

  void _showTextField({
    required String text,
    TextInputType textInputType = TextInputType.text,
    required Function(String)? onChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: TextEditingController(text: text),
              textInputType: textInputType,
              maxLines: textInputType == TextInputType.text ? 1 : null,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirm({
    required bool confirm,
    String? confirmLabel,
    Function(String)? onChanged,
    required Function() yesAction,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              confirm ? '確認済みをキャンセルしますか？' : '確認済みにしますか？',
              style: const TextStyle(
                color: kRedColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            !confirm && confirmLabel != null
                ? CustomTextField(
                    controller: TextEditingController(text: confirmLabel),
                    textInputType: TextInputType.text,
                    maxLines: 1,
                    onChanged: onChanged,
                  )
                : Container(),
          ],
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: 'いいえ',
            labelColor: kWhiteColor,
            backgroundColor: kGreyColor,
            onPressed: () => Navigator.pop(context),
          ),
          CustomButton(
            type: ButtonSizeType.sm,
            label: 'はい',
            labelColor: kWhiteColor,
            backgroundColor: kCyanColor,
            onPressed: () {
              yesAction();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _init() async {
    createdAt = widget.day;
    reportWorkers.add(ReportWorkerModel.fromMap({}));
    List<PlanModel> plans = await planService.selectList(
      organizationId: widget.loginProvider.organization?.id,
      date: widget.day,
    );
    if (plans.isNotEmpty) {
      for (PlanModel plan in plans) {
        reportPlans.add(ReportPlanModel.fromMap({
          'title': '[${plan.category}]${plan.subject}',
          'time':
              '${dateText('HH:mm', plan.startedAt)}～${dateText('HH:mm', plan.endedAt)}',
        }));
      }
    }
    reportRepairs.add(ReportRepairModel.fromMap({}));
    reportProblems.add(ReportProblemModel.fromMap({}));
    List<ProblemModel> problems = await problemService.selectList(
      organizationId: widget.loginProvider.organization?.id,
      date: widget.day,
    );
    if (problems.isNotEmpty) {
      reportProblems.clear();
      for (ProblemModel problem in problems) {
        reportProblems.add(ReportProblemModel.fromMap({
          'title': '[${problem.type}]${problem.title}',
          'deal': '',
        }));
      }
    }
    reportPamphlets.add(ReportPamphletModel.fromMap({}));
    reportEquipments.add(ReportEquipmentModel.fromMap({}));
    setState(() {});
  }

  @override
  void initState() {
    _init();
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
        title: const Text(
          '日報を作成',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await reportProvider.create(
                organization: widget.loginProvider.organization,
                createdAt: createdAt,
                reportWorkers: reportWorkers,
                reportVisitor: reportVisitor,
                reportLocker: reportLocker,
                reportPlans: reportPlans,
                reportCheck: reportCheck,
                advancePayment1: advancePayment1,
                advancePayment2: advancePayment2,
                reportRepairs: reportRepairs,
                reportProblems: reportProblems,
                reportPamphlets: reportPamphlets,
                reportEquipments: reportEquipments,
                passport: passport,
                passportCount: passportCount,
                remarks: remarks,
                agenda: agenda,
                lastConfirmShop: lastConfirmShop,
                lastConfirmShopAt: lastConfirmShopAt,
                lastConfirmShopName: lastConfirmShopName,
                lastConfirmCenter: lastConfirmCenter,
                lastConfirmCenterAt: lastConfirmCenterAt,
                lastConfirmExhaust: lastConfirmExhaust,
                lastConfirmExhaustAt: lastConfirmExhaustAt,
                lastConfirmRoof: lastConfirmRoof,
                lastConfirmRoofAt: lastConfirmRoofAt,
                lastConfirmAirCon: lastConfirmAirCon,
                lastConfirmAirConAt: lastConfirmAirConAt,
                lastConfirmToilet: lastConfirmToilet,
                lastConfirmToiletAt: lastConfirmToiletAt,
                lastConfirmBaby: lastConfirmBaby,
                lastConfirmBabyAt: lastConfirmBabyAt,
                lastConfirmPC: lastConfirmPC,
                lastConfirmPCAt: lastConfirmPCAt,
                lastConfirmTel: lastConfirmTel,
                lastConfirmTelAt: lastConfirmTelAt,
                lastConfirmCoupon: lastConfirmCoupon,
                lastConfirmCouponAt: lastConfirmCouponAt,
                lastConfirmCalendar: lastConfirmCalendar,
                lastConfirmCalendarAt: lastConfirmCalendarAt,
                lastConfirmMoney: lastConfirmMoney,
                lastConfirmMoneyAt: lastConfirmMoneyAt,
                lastConfirmLock: lastConfirmLock,
                lastConfirmLockAt: lastConfirmLockAt,
                lastConfirmUser: lastConfirmUser,
                lastConfirmUserAt: lastConfirmUserAt,
                lastConfirmUserName: lastConfirmUserName,
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
        shape: Border(bottom: BorderSide(color: kBorderColor)),
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
                          '作成日',
                          style: kReportHeaderStyle,
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  dateText('yyyy/MM/dd', createdAt),
                                  onTap: () async =>
                                      await CustomDateTimePicker().picker(
                                    context: context,
                                    init: createdAt,
                                    title: '作成日を選択',
                                    onChanged: (value) {
                                      setState(() {
                                        createdAt = value;
                                      });
                                    },
                                    datetime: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Container()),
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
                          '出勤者',
                          style: kReportHeaderStyle,
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            const TableRow(
                              children: [
                                ReportTableTh('名前'),
                                ReportTableTh('時間帯'),
                              ],
                            ),
                            ...reportWorkers.map((reportWorker) {
                              return TableRow(
                                children: [
                                  FormValue(
                                    reportWorker.name,
                                    onTap: () => _showTextField(
                                      text: reportWorker.name,
                                      onChanged: (value) {
                                        reportWorker.name = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  FormValue(
                                    reportWorker.time,
                                    onTap: () => _showTextField(
                                      text: reportWorker.time,
                                      onChanged: (value) {
                                        reportWorker.time = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ReportTableButton(
                              label: '削除',
                              color: kRedColor.withOpacity(0.3),
                              onPressed: () {
                                reportWorkers.removeLast();
                                setState(() {});
                              },
                            ),
                            const SizedBox(width: 4),
                            ReportTableButton(
                              label: '追加',
                              color: kBlueColor.withOpacity(0.3),
                              onPressed: () {
                                reportWorkers
                                    .add(ReportWorkerModel.fromMap({}));
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '入場者数',
                          style: kReportHeaderStyle,
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
                                ReportTableTh(''),
                                ReportTableTh('12:30'),
                                ReportTableTh('20:00'),
                                ReportTableTh('22:00'),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('お城下広場'),
                                FormValue(
                                  '${reportVisitor.floor1_12}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor1_12}',
                                    onChanged: (value) {
                                      reportVisitor.floor1_12 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor1_20}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor1_20}',
                                    onChanged: (value) {
                                      reportVisitor.floor1_20 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor1_22}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor1_22}',
                                    onChanged: (value) {
                                      reportVisitor.floor1_22 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('いごっそう'),
                                FormValue(
                                  '${reportVisitor.floor2_12}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor2_12}',
                                    onChanged: (value) {
                                      reportVisitor.floor2_12 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor2_20}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor2_20}',
                                    onChanged: (value) {
                                      reportVisitor.floor2_20 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor2_22}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor2_22}',
                                    onChanged: (value) {
                                      reportVisitor.floor2_22 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('自由広場'),
                                FormValue(
                                  '${reportVisitor.floor3_12}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor3_12}',
                                    onChanged: (value) {
                                      reportVisitor.floor3_12 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor3_20}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor3_20}',
                                    onChanged: (value) {
                                      reportVisitor.floor3_20 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor3_22}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor3_22}',
                                    onChanged: (value) {
                                      reportVisitor.floor3_22 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('東通路'),
                                FormValue(
                                  '${reportVisitor.floor4_12}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor4_12}',
                                    onChanged: (value) {
                                      reportVisitor.floor4_12 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor4_20}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor4_20}',
                                    onChanged: (value) {
                                      reportVisitor.floor4_20 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                FormValue(
                                  '${reportVisitor.floor4_22}',
                                  onTap: () => _showTextField(
                                    text: '${reportVisitor.floor4_22}',
                                    onChanged: (value) {
                                      reportVisitor.floor4_22 =
                                          int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('合計'),
                                ReportTableTh(
                                  '${reportVisitor.floor1_12 + reportVisitor.floor2_12 + reportVisitor.floor3_12 + reportVisitor.floor4_12}',
                                ),
                                ReportTableTh(
                                  '${reportVisitor.floor1_20 + reportVisitor.floor2_20 + reportVisitor.floor3_20 + reportVisitor.floor4_20}',
                                ),
                                ReportTableTh(
                                  '${reportVisitor.floor1_22 + reportVisitor.floor2_22 + reportVisitor.floor3_22 + reportVisitor.floor4_22}',
                                ),
                              ],
                            ),
                            const TableRow(
                              children: [
                                ReportTableTh('前年同曜日'),
                                ReportTableTh('0'),
                                ReportTableTh('0'),
                                ReportTableTh('0'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'コインロッカー',
                          style: kReportHeaderStyle,
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
                                const ReportTableTh('連続使用'),
                                CheckboxListTile(
                                  title: const Text('有'),
                                  value: reportLocker.use,
                                  onChanged: (value) {
                                    reportLocker.use = value ?? false;
                                    setState(() {});
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  tileColor: kGreyColor.withOpacity(0.3),
                                ),
                                const ReportTableTh('忘れ物'),
                                CheckboxListTile(
                                  title: const Text('有'),
                                  value: reportLocker.lost,
                                  onChanged: (value) {
                                    reportLocker.lost = value ?? false;
                                    setState(() {});
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  tileColor: kGreyColor.withOpacity(0.3),
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
                                const ReportTableTh('回収'),
                                FormValue(
                                  reportLocker.recovery,
                                  onTap: () => _showTextField(
                                    text: reportLocker.recovery,
                                    textInputType: TextInputType.multiline,
                                    onChanged: (value) {
                                      reportLocker.recovery = value;
                                      setState(() {});
                                    },
                                  ),
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
                          '予定',
                          style: kReportHeaderStyle,
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: IntrinsicColumnWidth(),
                          },
                          children: [
                            const TableRow(
                              children: [
                                ReportTableTh('内容'),
                                ReportTableTh('時間帯'),
                              ],
                            ),
                            ...reportPlans.map((reportPlan) {
                              return TableRow(
                                children: [
                                  ReportTableTh(reportPlan.title),
                                  ReportTableTh(reportPlan.time),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'メールチェック',
                          style: kReportHeaderStyle,
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
                            const TableRow(
                              children: [
                                ReportTableTh('時間'),
                                ReportTableTh('名前'),
                                ReportTableTh('時間'),
                                ReportTableTh('名前'),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('10:30'),
                                FormValue(
                                  reportCheck.mail10,
                                  onTap: () => _showTextField(
                                    text: reportCheck.mail10,
                                    onChanged: (value) {
                                      reportCheck.mail10 = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const ReportTableTh('12:00'),
                                FormValue(
                                  reportCheck.mail12,
                                  onTap: () => _showTextField(
                                    text: reportCheck.mail12,
                                    onChanged: (value) {
                                      reportCheck.mail12 = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('18:00'),
                                FormValue(
                                  reportCheck.mail18,
                                  onTap: () => _showTextField(
                                    text: reportCheck.mail18,
                                    onChanged: (value) {
                                      reportCheck.mail18 = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const ReportTableTh('22:00'),
                                FormValue(
                                  reportCheck.mail22,
                                  onTap: () => _showTextField(
                                    text: reportCheck.mail22,
                                    onChanged: (value) {
                                      reportCheck.mail22 = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '警戒チェック',
                          style: kReportHeaderStyle,
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
                                const ReportTableTh('状態'),
                                FormValue(
                                  reportCheck.warning19State,
                                  onTap: () => _showTextField(
                                    text: reportCheck.warning19State,
                                    onChanged: (value) {
                                      reportCheck.warning19State = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('対処'),
                                FormValue(
                                  reportCheck.warning19Deal,
                                  onTap: () => _showTextField(
                                    text: reportCheck.warning19Deal,
                                    onChanged: (value) {
                                      reportCheck.warning19Deal = value;
                                      setState(() {});
                                    },
                                  ),
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
                                const ReportTableTh('状態'),
                                FormValue(
                                  reportCheck.warning23State,
                                  onTap: () => _showTextField(
                                    text: reportCheck.warning23State,
                                    onChanged: (value) {
                                      reportCheck.warning23State = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('対処'),
                                FormValue(
                                  reportCheck.warning23Deal,
                                  onTap: () => _showTextField(
                                    text: reportCheck.warning23Deal,
                                    onChanged: (value) {
                                      reportCheck.warning23Deal = value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '立替金',
                          style: kReportHeaderStyle,
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
                                const ReportTableTh('立替'),
                                FormValue(
                                  '$advancePayment1',
                                  onTap: () => _showTextField(
                                    text: '$advancePayment1',
                                    onChanged: (value) {
                                      advancePayment1 = int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('現金'),
                                FormValue(
                                  '$advancePayment2',
                                  onTap: () => _showTextField(
                                    text: '$advancePayment2',
                                    onChanged: (value) {
                                      advancePayment2 = int.parse(value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('合計'),
                                ReportTableTh(
                                  '${advancePayment1 + advancePayment2}',
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
                '営繕ヶ所等',
                style: kReportHeaderStyle,
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  const TableRow(
                    children: [
                      ReportTableTh('内容'),
                      ReportTableTh('対処'),
                    ],
                  ),
                  ...reportRepairs.map((reportRepair) {
                    return TableRow(
                      children: [
                        FormValue(
                          reportRepair.title,
                          onTap: () => _showTextField(
                            text: reportRepair.title,
                            textInputType: TextInputType.multiline,
                            onChanged: (value) {
                              reportRepair.title = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportRepair.deal,
                          onTap: () => _showTextField(
                            text: reportRepair.deal,
                            textInputType: TextInputType.multiline,
                            onChanged: (value) {
                              reportRepair.deal = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReportTableButton(
                    label: '削除',
                    color: kRedColor.withOpacity(0.3),
                    onPressed: () {
                      reportRepairs.removeLast();
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 4),
                  ReportTableButton(
                    label: '追加',
                    color: kBlueColor.withOpacity(0.3),
                    onPressed: () {
                      reportRepairs.add(ReportRepairModel.fromMap({}));
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'クレーム／要望等',
                style: kReportHeaderStyle,
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  const TableRow(
                    children: [
                      ReportTableTh('内容'),
                      ReportTableTh('対処'),
                    ],
                  ),
                  ...reportProblems.map((reportProblem) {
                    return TableRow(
                      children: [
                        FormValue(
                          reportProblem.title,
                          onTap: () => _showTextField(
                            text: reportProblem.title,
                            textInputType: TextInputType.multiline,
                            onChanged: (value) {
                              reportProblem.title = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportProblem.deal,
                          onTap: () => _showTextField(
                            text: reportProblem.deal,
                            textInputType: TextInputType.multiline,
                            onChanged: (value) {
                              reportProblem.deal = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReportTableButton(
                    label: '削除',
                    color: kRedColor.withOpacity(0.3),
                    onPressed: () {
                      reportProblems.removeLast();
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 4),
                  ReportTableButton(
                    label: '追加',
                    color: kBlueColor.withOpacity(0.3),
                    onPressed: () {
                      reportProblems.add(ReportProblemModel.fromMap({}));
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'パンフレット',
                style: kReportHeaderStyle,
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  const TableRow(
                    children: [
                      ReportTableTh('種別'),
                      ReportTableTh('内容'),
                      ReportTableTh('金額'),
                    ],
                  ),
                  ...reportPamphlets.map((reportPamphlet) {
                    return TableRow(
                      children: [
                        FormValue(
                          reportPamphlet.type,
                          onTap: () => _showTextField(
                            text: reportPamphlet.type,
                            onChanged: (value) {
                              reportPamphlet.type = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportPamphlet.title,
                          onTap: () => _showTextField(
                            text: reportPamphlet.title,
                            onChanged: (value) {
                              reportPamphlet.title = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportPamphlet.price,
                          onTap: () => _showTextField(
                            text: reportPamphlet.price,
                            onChanged: (value) {
                              reportPamphlet.price = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReportTableButton(
                    label: '削除',
                    color: kRedColor.withOpacity(0.3),
                    onPressed: () {
                      reportPamphlets.removeLast();
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 4),
                  ReportTableButton(
                    label: '追加',
                    color: kBlueColor.withOpacity(0.3),
                    onPressed: () {
                      reportPamphlets.add(ReportPamphletModel.fromMap({}));
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '備品発注・入荷',
                style: kReportHeaderStyle,
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  const TableRow(
                    children: [
                      ReportTableTh('種別'),
                      ReportTableTh('品名'),
                      ReportTableTh('業者'),
                      ReportTableTh('納期'),
                      ReportTableTh('納入数'),
                      ReportTableTh('発注者'),
                    ],
                  ),
                  ...reportEquipments.map((reportEquipment) {
                    return TableRow(
                      children: [
                        FormValue(
                          reportEquipment.type,
                          onTap: () => _showTextField(
                            text: reportEquipment.type,
                            onChanged: (value) {
                              reportEquipment.type = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportEquipment.name,
                          onTap: () => _showTextField(
                            text: reportEquipment.name,
                            onChanged: (value) {
                              reportEquipment.name = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportEquipment.vendor,
                          onTap: () => _showTextField(
                            text: reportEquipment.vendor,
                            onChanged: (value) {
                              reportEquipment.vendor = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportEquipment.deliveryDate,
                          onTap: () => _showTextField(
                            text: reportEquipment.deliveryDate,
                            onChanged: (value) {
                              reportEquipment.deliveryDate = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportEquipment.deliveryNum,
                          onTap: () => _showTextField(
                            text: reportEquipment.deliveryNum,
                            onChanged: (value) {
                              reportEquipment.deliveryNum = value;
                              setState(() {});
                            },
                          ),
                        ),
                        FormValue(
                          reportEquipment.client,
                          onTap: () => _showTextField(
                            text: reportEquipment.client,
                            onChanged: (value) {
                              reportEquipment.client = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReportTableButton(
                    label: '削除',
                    color: kRedColor.withOpacity(0.3),
                    onPressed: () {
                      reportEquipments.removeLast();
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 4),
                  ReportTableButton(
                    label: '追加',
                    color: kBlueColor.withOpacity(0.3),
                    onPressed: () {
                      reportEquipments.add(ReportEquipmentModel.fromMap({}));
                      setState(() {});
                    },
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
                          'パスポート',
                          style: kReportHeaderStyle,
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  passport,
                                  onTap: () => _showTextField(
                                    text: passport,
                                    textInputType: TextInputType.multiline,
                                    onChanged: (value) {
                                      passport = value;
                                      setState(() {});
                                    },
                                  ),
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
                            const TableRow(
                              children: [
                                ReportTableTh('前日の合計'),
                                ReportTableTh('0'),
                              ],
                            ),
                            TableRow(
                              children: [
                                const ReportTableTh('合計'),
                                FormValue(
                                  '$passportCount',
                                  onTap: () => _showTextField(
                                    text: '$passportCount',
                                    onChanged: (value) {
                                      passportCount = int.parse(value);
                                      setState(() {});
                                    },
                                  ),
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
                          'その他報告・連絡',
                          style: kReportHeaderStyle,
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  remarks,
                                  onTap: () => _showTextField(
                                    text: remarks,
                                    textInputType: TextInputType.multiline,
                                    onChanged: (value) {
                                      remarks = value;
                                      setState(() {});
                                    },
                                  ),
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
                '申送事項',
                style: kReportHeaderStyle,
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  TableRow(
                    children: [
                      FormValue(
                        agenda,
                        onTap: () => _showTextField(
                          text: agenda,
                          textInputType: TextInputType.multiline,
                          onChanged: (value) {
                            agenda = value;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '最終確認チェック',
                style: kReportHeaderStyle,
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  const TableRow(
                    children: [
                      ReportTableTh('最終店舗終了'),
                      ReportTableTh('食器センター終了'),
                      ReportTableTh('排気'),
                      ReportTableTh('天井扇'),
                      ReportTableTh('空調'),
                      ReportTableTh('トイレ'),
                      ReportTableTh('ベビーコーナー'),
                    ],
                  ),
                  TableRow(
                    children: [
                      ReportConfirmButton(
                        confirm: lastConfirmShop,
                        confirmTime: dateText('HH:mm', lastConfirmShopAt),
                        confirmLabel: lastConfirmShopName,
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmShop,
                          confirmLabel: lastConfirmShopName,
                          onChanged: (value) {
                            lastConfirmShopName = value;
                            setState(() {});
                          },
                          yesAction: () {
                            lastConfirmShop = !lastConfirmShop;
                            lastConfirmShopAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmCenter,
                        confirmTime: dateText('HH:mm', lastConfirmCenterAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmCenter,
                          yesAction: () {
                            lastConfirmCenter = !lastConfirmCenter;
                            lastConfirmCenterAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmExhaust,
                        confirmTime: dateText('HH:mm', lastConfirmExhaustAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmExhaust,
                          yesAction: () {
                            lastConfirmExhaust = !lastConfirmExhaust;
                            lastConfirmExhaustAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmRoof,
                        confirmTime: dateText('HH:mm', lastConfirmRoofAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmRoof,
                          yesAction: () {
                            lastConfirmRoof = !lastConfirmRoof;
                            lastConfirmRoofAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmAirCon,
                        confirmTime: dateText('HH:mm', lastConfirmAirConAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmAirCon,
                          yesAction: () {
                            lastConfirmAirCon = !lastConfirmAirCon;
                            lastConfirmAirConAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmToilet,
                        confirmTime: dateText('HH:mm', lastConfirmToiletAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmToilet,
                          yesAction: () {
                            lastConfirmToilet = !lastConfirmToilet;
                            lastConfirmToiletAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmBaby,
                        confirmTime: dateText('HH:mm', lastConfirmBabyAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmBaby,
                          yesAction: () {
                            lastConfirmBaby = !lastConfirmBaby;
                            lastConfirmBabyAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  const TableRow(
                    children: [
                      ReportTableTh('PC／ゴミ'),
                      ReportTableTh('留守電'),
                      ReportTableTh('クーポン券'),
                      ReportTableTh('日付確認'),
                      ReportTableTh('両替'),
                      ReportTableTh('施錠'),
                      ReportTableTh('日報最終確認'),
                    ],
                  ),
                  TableRow(
                    children: [
                      ReportConfirmButton(
                        confirm: lastConfirmPC,
                        confirmTime: dateText('HH:mm', lastConfirmPCAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmPC,
                          yesAction: () {
                            lastConfirmPC = !lastConfirmPC;
                            lastConfirmPCAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmTel,
                        confirmTime: dateText('HH:mm', lastConfirmTelAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmTel,
                          yesAction: () {
                            lastConfirmTel = !lastConfirmTel;
                            lastConfirmTelAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmCoupon,
                        confirmTime: dateText('HH:mm', lastConfirmCouponAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmCoupon,
                          yesAction: () {
                            lastConfirmCoupon = !lastConfirmCoupon;
                            lastConfirmCouponAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmCalendar,
                        confirmTime: dateText('HH:mm', lastConfirmCalendarAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmCalendar,
                          yesAction: () {
                            lastConfirmCalendar = !lastConfirmCalendar;
                            lastConfirmCalendarAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmMoney,
                        confirmTime: dateText('HH:mm', lastConfirmMoneyAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmMoney,
                          yesAction: () {
                            lastConfirmMoney = !lastConfirmMoney;
                            lastConfirmMoneyAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmLock,
                        confirmTime: dateText('HH:mm', lastConfirmLockAt),
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmLock,
                          yesAction: () {
                            lastConfirmLock = !lastConfirmLock;
                            lastConfirmLockAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                      ReportConfirmButton(
                        confirm: lastConfirmUser,
                        confirmTime: dateText('HH:mm', lastConfirmUserAt),
                        confirmLabel: lastConfirmUserName,
                        onPressed: () => _showConfirm(
                          confirm: lastConfirmUser,
                          confirmLabel: lastConfirmUserName,
                          onChanged: (value) {
                            lastConfirmUserName = value;
                            setState(() {});
                          },
                          yesAction: () {
                            lastConfirmUser = !lastConfirmUser;
                            lastConfirmUserAt = DateTime.now();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
