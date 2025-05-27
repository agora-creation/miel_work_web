import 'dart:convert';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan_guardsman_week.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan_guardsman.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:miel_work_web/widgets/plan_work_list.dart';
import 'package:miel_work_web/widgets/report_table_td.dart';
import 'package:miel_work_web/widgets/report_table_th.dart';
import 'package:miel_work_web/widgets/time_range_form.dart';
import 'package:provider/provider.dart';

class PlanGuardsmanWeekScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<DateTime> days;

  const PlanGuardsmanWeekScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.days,
    super.key,
  });

  @override
  State<PlanGuardsmanWeekScreen> createState() =>
      _PlanGuardsmanWeekScreenState();
}

class _PlanGuardsmanWeekScreenState extends State<PlanGuardsmanWeekScreen> {
  List<PlanGuardsmanWeekModel> guardsmanWeeks = [];

  Future _getData() async {
    guardsmanWeeks.clear();
    List<String> result = await getPrefsList('guardsmanWeeks') ?? [];
    if (result.isNotEmpty) {
      guardsmanWeeks = result
          .map((e) => PlanGuardsmanWeekModel.fromMap(json.decode(e)))
          .toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final guardsmanProvider = Provider.of<PlanGuardsmanProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '警備員勤務表：1週間分の予定を設定',
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: guardsmanWeeks.map((e) {
                            if (e.week != '日') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                '${e.startedTime}～${e.endedTime}',
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGuardsmanWeekDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  guardsmanWeek: e,
                                  guardsmanWeeks: guardsmanWeeks,
                                  getData: _getData,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddGuardsmanWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              currentWeek: '日',
                              guardsmanWeeks: guardsmanWeeks,
                              getData: _getData,
                            ),
                          ),
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: guardsmanWeeks.map((e) {
                            if (e.week != '月') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                '${e.startedTime}～${e.endedTime}',
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGuardsmanWeekDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  guardsmanWeek: e,
                                  guardsmanWeeks: guardsmanWeeks,
                                  getData: _getData,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddGuardsmanWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              currentWeek: '日',
                              guardsmanWeeks: guardsmanWeeks,
                              getData: _getData,
                            ),
                          ),
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: guardsmanWeeks.map((e) {
                            if (e.week != '火') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                '${e.startedTime}～${e.endedTime}',
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGuardsmanWeekDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  guardsmanWeek: e,
                                  guardsmanWeeks: guardsmanWeeks,
                                  getData: _getData,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddGuardsmanWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              currentWeek: '日',
                              guardsmanWeeks: guardsmanWeeks,
                              getData: _getData,
                            ),
                          ),
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: guardsmanWeeks.map((e) {
                            if (e.week != '水') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                '${e.startedTime}～${e.endedTime}',
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGuardsmanWeekDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  guardsmanWeek: e,
                                  guardsmanWeeks: guardsmanWeeks,
                                  getData: _getData,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddGuardsmanWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              currentWeek: '日',
                              guardsmanWeeks: guardsmanWeeks,
                              getData: _getData,
                            ),
                          ),
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: guardsmanWeeks.map((e) {
                            if (e.week != '木') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                '${e.startedTime}～${e.endedTime}',
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGuardsmanWeekDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  guardsmanWeek: e,
                                  guardsmanWeeks: guardsmanWeeks,
                                  getData: _getData,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddGuardsmanWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              currentWeek: '日',
                              guardsmanWeeks: guardsmanWeeks,
                              getData: _getData,
                            ),
                          ),
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: guardsmanWeeks.map((e) {
                            if (e.week != '金') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                '${e.startedTime}～${e.endedTime}',
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGuardsmanWeekDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  guardsmanWeek: e,
                                  guardsmanWeeks: guardsmanWeeks,
                                  getData: _getData,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddGuardsmanWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              currentWeek: '日',
                              guardsmanWeeks: guardsmanWeeks,
                              getData: _getData,
                            ),
                          ),
                        ),
                      ],
                    )),
                    ReportTableTd(Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: guardsmanWeeks.map((e) {
                            if (e.week != '土') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                '${e.startedTime}～${e.endedTime}',
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGuardsmanWeekDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  guardsmanWeek: e,
                                  guardsmanWeeks: guardsmanWeeks,
                                  getData: _getData,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddGuardsmanWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              currentWeek: '日',
                              guardsmanWeeks: guardsmanWeeks,
                              getData: _getData,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  type: ButtonSizeType.sm,
                  label:
                      '上記内容を『${dateText('yyyy年MM月', widget.days.first)}』の1ヵ月分に反映する',
                  labelColor: kWhiteColor,
                  backgroundColor: kCyanColor,
                  onPressed: () async {
                    String? error = await guardsmanProvider.createWeeks(
                      organization: widget.loginProvider.organization,
                      guardsmanWeeks: guardsmanWeeks,
                      days: widget.days,
                      loginUser: widget.loginProvider.user,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '1ヵ月分に反映しました', true);
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

class AddGuardsmanWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String currentWeek;
  final List<PlanGuardsmanWeekModel> guardsmanWeeks;
  final Function() getData;

  const AddGuardsmanWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.currentWeek,
    required this.guardsmanWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<AddGuardsmanWeekDialog> createState() => _AddGuardsmanWeekDialogState();
}

class _AddGuardsmanWeekDialogState extends State<AddGuardsmanWeekDialog> {
  String startedTime = '09:00';
  String endedTime = '23:00';

  void _init() async {
    startedTime = '09:00';
    endedTime = '23:00';
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            FormLabel('曜日', child: FormValue(widget.currentWeek)),
            const SizedBox(height: 8),
            FormLabel(
              '予定時間',
              child: TimeRangeForm(
                startedTime: startedTime,
                startedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.time,
                  init: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    int.parse(startedTime.split(':')[0]),
                    int.parse(startedTime.split(':')[1]),
                  ),
                  title: '予定開始時間を選択',
                  onChanged: (value) {
                    setState(() {
                      startedTime = dateText('HH:mm', value);
                    });
                  },
                ),
                endedTime: endedTime,
                endedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.time,
                  init: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    int.parse(endedTime.split(':')[0]),
                    int.parse(endedTime.split(':')[1]),
                  ),
                  title: '予定終了時間を選択',
                  onChanged: (value) {
                    setState(() {
                      endedTime = dateText('HH:mm', value);
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
            List<Map> maps = [];
            if (widget.guardsmanWeeks.isNotEmpty) {
              for (final data in widget.guardsmanWeeks) {
                maps.add(data.toMap());
              }
            }
            maps.add({
              'id': dateText('yyyyMMddHHmm', DateTime.now()),
              'week': widget.currentWeek,
              'startedTime': startedTime,
              'endedTime': endedTime,
            });
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('guardsmanWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModGuardsmanWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanGuardsmanWeekModel guardsmanWeek;
  final List<PlanGuardsmanWeekModel> guardsmanWeeks;
  final Function() getData;

  const ModGuardsmanWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.guardsmanWeek,
    required this.guardsmanWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<ModGuardsmanWeekDialog> createState() => _ModGuardsmanWeekDialogState();
}

class _ModGuardsmanWeekDialogState extends State<ModGuardsmanWeekDialog> {
  String startedTime = '09:00';
  String endedTime = '23:00';

  void _init() async {
    startedTime = widget.guardsmanWeek.startedTime;
    endedTime = widget.guardsmanWeek.endedTime;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            FormLabel('曜日', child: FormValue(widget.guardsmanWeek.week)),
            const SizedBox(height: 8),
            FormLabel(
              '予定時間',
              child: TimeRangeForm(
                startedTime: startedTime,
                startedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.time,
                  init: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    int.parse(startedTime.split(':')[0]),
                    int.parse(startedTime.split(':')[1]),
                  ),
                  title: '予定開始時間を選択',
                  onChanged: (value) {
                    setState(() {
                      startedTime = dateText('HH:mm', value);
                    });
                  },
                ),
                endedTime: endedTime,
                endedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.time,
                  init: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    int.parse(endedTime.split(':')[0]),
                    int.parse(endedTime.split(':')[1]),
                  ),
                  title: '予定終了時間を選択',
                  onChanged: (value) {
                    setState(() {
                      endedTime = dateText('HH:mm', value);
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
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            List<Map> maps = [];
            if (widget.guardsmanWeeks.isNotEmpty) {
              for (final guardsmanWeek in widget.guardsmanWeeks) {
                if (widget.guardsmanWeek.id == guardsmanWeek.id) {
                  continue;
                }
                maps.add(guardsmanWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('guardsmanWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            List<Map> maps = [];
            if (widget.guardsmanWeeks.isNotEmpty) {
              for (final guardsmanWeek in widget.guardsmanWeeks) {
                if (widget.guardsmanWeek.id == guardsmanWeek.id) {
                  guardsmanWeek.startedTime = startedTime;
                  guardsmanWeek.endedTime = endedTime;
                }
                maps.add(guardsmanWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('guardsmanWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
