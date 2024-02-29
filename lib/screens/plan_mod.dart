import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/plan.dart';
import 'package:miel_work_web/services/category.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_date_box.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/custom_time_box.dart';
import 'package:provider/provider.dart';

class PlanModScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final String planId;
  final List<OrganizationGroupModel> groups;

  const PlanModScreen({
    required this.organization,
    required this.planId,
    required this.groups,
    super.key,
  });

  @override
  State<PlanModScreen> createState() => _PlanModScreenState();
}

class _PlanModScreenState extends State<PlanModScreen> {
  PlanService planService = PlanService();
  CategoryService categoryService = CategoryService();
  OrganizationGroupModel? selectedGroup;
  List<CategoryModel> categories = [];
  String? selectedCategory;
  TextEditingController subjectController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;
  String color = kPlanColors.first.value.toRadixString(16);
  TextEditingController memoController = TextEditingController();
  PlatformFile? pickedFile;

  void _init() async {
    PlanModel? plan = await planService.selectData(id: widget.planId);
    if (plan == null) {
      if (!mounted) return;
      showMessage(context, '予定データの取得に失敗しました', false);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }
    for (OrganizationGroupModel group in widget.groups) {
      if (group.id == plan.groupId) {
        selectedGroup = group;
      }
    }
    List<CategoryModel> tmpCategories = await categoryService.selectList(
      organizationId: widget.organization?.id,
    );
    categories = tmpCategories;
    selectedCategory = plan.category;
    subjectController.text = plan.subject;
    startedAt = plan.startedAt;
    endedAt = plan.endedAt;
    allDay = plan.allDay;
    color = plan.color.value.toRadixString(16);
    memoController.text = plan.memo;
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
    final planProvider = Provider.of<PlanProvider>(context);
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
                '予定を編集する',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  CustomButtonSm(
                    labelText: '削除',
                    labelColor: kWhiteColor,
                    backgroundColor: kRedColor,
                    onPressed: () async {
                      String? error = await planProvider.delete(
                        planId: widget.planId,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, '予定を削除しました', true);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  CustomButtonSm(
                    labelText: '入力内容を保存',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await planProvider.update(
                        planId: widget.planId,
                        organization: widget.organization,
                        group: selectedGroup,
                        category: selectedCategory,
                        subject: subjectController.text,
                        startedAt: startedAt,
                        endedAt: endedAt,
                        allDay: allDay,
                        color: color,
                        memo: memoController.text,
                        pickedFile: pickedFile,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, '予定を編集しました', true);
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
              label: '公開グループ',
              child: ComboBox<OrganizationGroupModel>(
                isExpanded: true,
                value: selectedGroup,
                items: groupItems,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
                placeholder: const Text('グループ未選択'),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'カテゴリ',
              child: ComboBox<String>(
                isExpanded: true,
                value: selectedCategory,
                items: categories.map((category) {
                  return ComboBoxItem(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                placeholder: const Text('カテゴリ未選択'),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '件名',
              child: CustomTextBox(
                controller: subjectController,
                placeholder: '',
                keyboardType: TextInputType.text,
                maxLines: 1,
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
            const SizedBox(height: 8),
            InfoLabel(
              label: '色',
              child: ComboBox<String>(
                isExpanded: true,
                value: color,
                items: kPlanColors.map((Color value) {
                  return ComboBoxItem(
                    value: value.value.toRadixString(16),
                    child: Container(
                      color: value,
                      width: double.infinity,
                      height: 25,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    color = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'メモ',
              child: CustomTextBox(
                controller: memoController,
                placeholder: '',
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
