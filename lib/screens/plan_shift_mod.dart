import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan_shift.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/plan_shift.dart';
import 'package:miel_work_web/services/plan_shift.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
import 'package:miel_work_web/widgets/custom_date_box.dart';
import 'package:miel_work_web/widgets/custom_time_box.dart';
import 'package:provider/provider.dart';

class PlanShiftModScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final String planShiftId;
  final List<OrganizationGroupModel> groups;

  const PlanShiftModScreen({
    required this.organization,
    required this.planShiftId,
    required this.groups,
    super.key,
  });

  @override
  State<PlanShiftModScreen> createState() => _PlanShiftModScreenState();
}

class _PlanShiftModScreenState extends State<PlanShiftModScreen> {
  PlanShiftService planShiftService = PlanShiftService();
  UserService userService = UserService();
  OrganizationGroupModel? selectedGroup;
  List<UserModel> users = [];
  List<String> selectedUserIds = [];
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;

  void _init() async {
    PlanShiftModel? planShift = await planShiftService.selectData(
      id: widget.planShiftId,
    );
    if (planShift == null) {
      if (!mounted) return;
      showMessage(context, '勤務予定データの取得に失敗しました', false);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }
    for (OrganizationGroupModel group in widget.groups) {
      if (group.id == planShift.groupId) {
        selectedGroup = group;
      }
    }
    _groupChange(selectedGroup);
    selectedUserIds = planShift.userIds;
    startedAt = planShift.startedAt;
    endedAt = planShift.endedAt;
    allDay = planShift.allDay;
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
        userIds: widget.organization?.userIds ?? [],
      );
    }
    setState(() {});
  }

  void _allDayChange(bool? value) {
    setState(() {
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
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final planShiftProvider = Provider.of<PlanShiftProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in homeProvider.groups) {
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
                '勤務予定を編集する',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  CustomButtonSm(
                    labelText: '削除',
                    labelColor: kWhiteColor,
                    backgroundColor: kRedColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DelPlanShiftDialog(
                        planShiftId: widget.planShiftId,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  CustomButtonSm(
                    labelText: '入力内容を保存',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await planShiftProvider.update(
                        planShiftId: widget.planShiftId,
                        organization: widget.organization,
                        group: selectedGroup,
                        userIds: selectedUserIds,
                        startedAt: startedAt,
                        endedAt: endedAt,
                        allDay: allDay,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, '勤務予定を編集しました', true);
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
            const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }
}

class DelPlanShiftDialog extends StatefulWidget {
  final String planShiftId;

  const DelPlanShiftDialog({
    required this.planShiftId,
    super.key,
  });

  @override
  State<DelPlanShiftDialog> createState() => _DelPlanShiftDialogState();
}

class _DelPlanShiftDialogState extends State<DelPlanShiftDialog> {
  @override
  Widget build(BuildContext context) {
    final planShiftProvider = Provider.of<PlanShiftProvider>(context);
    return ContentDialog(
      title: const Text(
        '勤務予定を削除する',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('本当に削除しますか？')),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await planShiftProvider.delete(
              planShiftId: widget.planShiftId,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '勤務予定を削除しました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
