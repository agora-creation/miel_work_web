import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan_shift.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
import 'package:miel_work_web/widgets/custom_date_box.dart';
import 'package:miel_work_web/widgets/custom_time_box.dart';
import 'package:provider/provider.dart';

class PlanShiftAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String userId;
  final DateTime date;

  const PlanShiftAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.userId,
    required this.date,
    super.key,
  });

  @override
  State<PlanShiftAddScreen> createState() => _PlanShiftAddScreenState();
}

class _PlanShiftAddScreenState extends State<PlanShiftAddScreen> {
  UserService userService = UserService();
  OrganizationGroupModel? selectedGroup;
  List<UserModel> users = [];
  List<String> selectedUserIds = [];
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;
  int alertMinute = 0;

  void _init() async {
    _groupChange(widget.homeProvider.currentGroup);
    selectedUserIds.add(widget.userId);
    startedAt = widget.date;
    endedAt = startedAt.add(const Duration(hours: 1));
    setState(() {});
  }

  void _groupChange(OrganizationGroupModel? value) async {
    selectedGroup = value;
    if (selectedGroup != null) {
      users = await userService.selectList(
        userIds: selectedGroup?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    }
    setState(() {});
  }

  void _allDayChange(bool? value) {
    allDay = value ?? false;
    if (allDay) {
      startedAt = DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
        0,
        0,
        0,
      );
      endedAt = DateTime(
        endedAt.year,
        endedAt.month,
        endedAt.day,
        23,
        59,
        59,
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final planShiftProvider = Provider.of<PlanShiftProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '勤務予定を新しく追加',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  CustomButtonSm(
                    labelText: '入力内容を保存',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await planShiftProvider.create(
                        organization: widget.loginProvider.organization,
                        group: selectedGroup,
                        userIds: selectedUserIds,
                        startedAt: startedAt,
                        endedAt: endedAt,
                        allDay: allDay,
                        alertMinute: alertMinute,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, '勤務予定を追加しました', true);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InfoLabel(
              label: 'グループからスタッフ検索',
              child: ComboBox<OrganizationGroupModel>(
                isExpanded: true,
                value: selectedGroup,
                items: groupItems,
                onChanged: (value) {
                  selectedUserIds.clear();
                  _groupChange(value);
                },
                placeholder: const Text('グループ未選択'),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'スタッフ選択',
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: kGrey300Color),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserModel user = users[index];
                    return CustomCheckbox(
                      label: user.name,
                      checked: selectedUserIds.contains(user.id),
                      onChanged: (value) {
                        if (selectedUserIds.contains(user.id)) {
                          selectedUserIds.remove(user.id);
                        } else {
                          selectedUserIds.add(user.id);
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            InfoLabel(
              label: '開始日時',
              child: Column(
                children: [
                  CustomDateBox(
                    value: startedAt,
                    onTap: () async {
                      final result =
                          await CustomDateTimePicker().showDateChange(
                        context: context,
                        value: startedAt,
                      );
                      setState(() {
                        startedAt = result;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomTimeBox(
                    value: startedAt,
                    onTap: () async {
                      final result =
                          await CustomDateTimePicker().showTimeChange(
                        context: context,
                        value: startedAt,
                      );
                      setState(() {
                        startedAt = result;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '終了日時',
              child: Column(
                children: [
                  CustomDateBox(
                    value: endedAt,
                    onTap: () async {
                      final result =
                          await CustomDateTimePicker().showDateChange(
                        context: context,
                        value: endedAt,
                      );
                      setState(() {
                        endedAt = result;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomTimeBox(
                    value: endedAt,
                    onTap: () async {
                      final result =
                          await CustomDateTimePicker().showTimeChange(
                        context: context,
                        value: endedAt,
                      );
                      setState(() {
                        endedAt = result;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Checkbox(
              checked: allDay,
              onChanged: _allDayChange,
              content: const Text('終日'),
            ),
            const SizedBox(height: 40),
            InfoLabel(
              label: '事前アラート通知',
              child: ComboBox<int>(
                isExpanded: true,
                value: alertMinute,
                items: kAlertMinutes.map((value) {
                  return ComboBoxItem(
                    value: value,
                    child: value == 0 ? const Text('無効') : Text('$value分前'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    alertMinute = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
