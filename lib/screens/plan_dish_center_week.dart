import 'dart:convert';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan_dish_center_week.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/organization_group.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:miel_work_web/widgets/plan_work_list.dart';
import 'package:miel_work_web/widgets/report_table_td.dart';
import 'package:miel_work_web/widgets/report_table_th.dart';
import 'package:miel_work_web/widgets/time_range_form.dart';

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
  List<PlanDishCenterWeekModel> planDishCenterWeeks = [];

  Future _getData() async {
    planDishCenterWeeks.clear();
    List<String> result = await getPrefsList('planDishCenterWeeks') ?? [];
    if (result.isNotEmpty) {
      planDishCenterWeeks = result
          .map((e) => PlanDishCenterWeekModel.fromMap(json.decode(e)))
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: planDishCenterWeeks.map((e) {
                            if (e.week != '日') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                  '[${e.userName}]${e.startedTime}～${e.endedTime}'),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddDishCenterWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              week: '日',
                              planDishCenterWeeks: planDishCenterWeeks,
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
                          children: planDishCenterWeeks.map((e) {
                            if (e.week != '月') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                  '[${e.userName}]${e.startedTime}～${e.endedTime}'),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddDishCenterWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              week: '月',
                              planDishCenterWeeks: planDishCenterWeeks,
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
                          children: planDishCenterWeeks.map((e) {
                            if (e.week != '火') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                  '[${e.userName}]${e.startedTime}～${e.endedTime}'),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddDishCenterWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              week: '火',
                              planDishCenterWeeks: planDishCenterWeeks,
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
                          children: planDishCenterWeeks.map((e) {
                            if (e.week != '水') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                  '[${e.userName}]${e.startedTime}～${e.endedTime}'),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddDishCenterWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              week: '水',
                              planDishCenterWeeks: planDishCenterWeeks,
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
                          children: planDishCenterWeeks.map((e) {
                            if (e.week != '木') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                  '[${e.userName}]${e.startedTime}～${e.endedTime}'),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddDishCenterWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              week: '木',
                              planDishCenterWeeks: planDishCenterWeeks,
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
                          children: planDishCenterWeeks.map((e) {
                            if (e.week != '金') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                  '[${e.userName}]${e.startedTime}～${e.endedTime}'),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddDishCenterWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              week: '金',
                              planDishCenterWeeks: planDishCenterWeeks,
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
                          children: planDishCenterWeeks.map((e) {
                            if (e.week != '土') return Container();
                            return GestureDetector(
                              child: PlanWorkList(
                                  '[${e.userName}]${e.startedTime}～${e.endedTime}'),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        LinkText(
                          label: '追加',
                          color: kBlueColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AddDishCenterWeekDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              week: '土',
                              planDishCenterWeeks: planDishCenterWeeks,
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
                  label: '上記内容を『2025年01月』の1ヵ月分に反映する',
                  labelColor: kWhiteColor,
                  backgroundColor: kCyanColor,
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

class AddDishCenterWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String week;
  final List<PlanDishCenterWeekModel> planDishCenterWeeks;
  final Function() getData;

  const AddDishCenterWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.week,
    required this.planDishCenterWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<AddDishCenterWeekDialog> createState() =>
      _AddDishCenterWeekDialogState();
}

class _AddDishCenterWeekDialogState extends State<AddDishCenterWeekDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;
  String startedTime = '09:00';
  String endedTime = '17:00';

  void _init() async {
    OrganizationGroupModel? group = await groupService.selectDataName(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      name: '食器センター',
    );
    if (group != null) {
      users = await userService.selectList(
        userIds: group.userIds,
      );
    }
    if (users.isNotEmpty) {
      selectedUser = users.first;
    }
    startedTime = '09:00';
    endedTime = '17:00';
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
            FormLabel('曜日', child: FormValue(widget.week)),
            const SizedBox(height: 8),
            FormLabel(
              'スタッフ選択',
              child: DropdownButton<UserModel?>(
                isExpanded: true,
                value: selectedUser,
                items: users.map((user) {
                  return DropdownMenuItem(
                    value: user,
                    child: Text(user.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUser = value;
                  });
                },
              ),
            ),
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
            if (widget.planDishCenterWeeks.isNotEmpty) {
              for (final planDishCenterWeek in widget.planDishCenterWeeks) {
                maps.add(planDishCenterWeek.toMap());
              }
            }
            maps.add({
              'id': dateText('yyyyMMddHHmm', DateTime.now()),
              'week': widget.week,
              'userId': selectedUser?.id,
              'userName': selectedUser?.name,
              'startedTime': startedTime,
              'endedTime': endedTime,
            });
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('planDishCenterWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModDishCenterWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanDishCenterWeekModel planDishCenterWeek;
  final List<PlanDishCenterWeekModel> planDishCenterWeeks;
  final Function() getData;

  const ModDishCenterWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.planDishCenterWeek,
    required this.planDishCenterWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<ModDishCenterWeekDialog> createState() =>
      _ModDishCenterWeekDialogState();
}

class _ModDishCenterWeekDialogState extends State<ModDishCenterWeekDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;
  String startedTime = '09:00';
  String endedTime = '17:00';

  void _init() async {
    OrganizationGroupModel? group = await groupService.selectDataName(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      name: '食器センター',
    );
    if (group != null) {
      users = await userService.selectList(
        userIds: group.userIds,
      );
    }
    selectedUser =
        users.singleWhere((e) => e.id == widget.planDishCenterWeek.userId);
    startedTime = widget.planDishCenterWeek.startedTime;
    endedTime = widget.planDishCenterWeek.endedTime;
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
            FormLabel('曜日', child: FormValue(widget.planDishCenterWeek.week)),
            const SizedBox(height: 8),
            FormLabel(
              'スタッフ選択',
              child: DropdownButton<UserModel?>(
                isExpanded: true,
                value: selectedUser,
                items: users.map((user) {
                  return DropdownMenuItem(
                    value: user,
                    child: Text(user.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUser = value;
                  });
                },
              ),
            ),
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
            if (widget.planDishCenterWeeks.isNotEmpty) {
              for (final planDishCenterWeek in widget.planDishCenterWeeks) {
                if (widget.planDishCenterWeek.id == planDishCenterWeek.id) {
                  continue;
                }
                maps.add(planDishCenterWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('planDishCenterWeeks', jsonMaps);
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
            if (widget.planDishCenterWeeks.isNotEmpty) {
              for (final planDishCenterWeek in widget.planDishCenterWeeks) {
                if (widget.planDishCenterWeek.id == planDishCenterWeek.id) {
                  planDishCenterWeek.userId = selectedUser?.id ?? '';
                  planDishCenterWeek.userName = selectedUser?.name ?? '';
                  planDishCenterWeek.startedTime = startedTime;
                  planDishCenterWeek.endedTime = endedTime;
                }
                maps.add(planDishCenterWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('planDishCenterWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
