import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/plan_shift.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
import 'package:miel_work_web/widgets/custom_date_box.dart';
import 'package:miel_work_web/widgets/custom_time_box.dart';
import 'package:provider/provider.dart';

class PlanShiftAddScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;
  final String userId;
  final DateTime date;

  const PlanShiftAddScreen({
    required this.organization,
    required this.group,
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

  void _init() async {
    _groupChange(widget.group);
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
                '勤務予定を新しく追加する',
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
