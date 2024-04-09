import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan.dart';
import 'package:miel_work_web/services/category.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/repeat_select_form.dart';
import 'package:provider/provider.dart';

class PlanAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime date;

  const PlanAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.date,
    super.key,
  });

  @override
  State<PlanAddScreen> createState() => _PlanAddScreenState();
}

class _PlanAddScreenState extends State<PlanAddScreen> {
  CategoryService categoryService = CategoryService();
  OrganizationGroupModel? selectedGroup;
  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;
  TextEditingController subjectController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;
  bool repeat = false;
  String repeatInterval = kRepeatIntervals.first;
  TextEditingController repeatEveryController = TextEditingController(
    text: '1',
  );
  List<String> repeatWeeks = [];
  TextEditingController memoController = TextEditingController();
  int alertMinute = kAlertMinutes[1];

  void _init() async {
    selectedGroup = widget.homeProvider.currentGroup;
    categories = await categoryService.selectList(
      organizationId: widget.loginProvider.organization?.id,
    );
    selectedCategory = categories.first;
    startedAt = widget.date;
    endedAt = startedAt.add(const Duration(hours: 1));
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
    final planProvider = Provider.of<PlanProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
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
              IconButton(
                icon: const Icon(FluentIcons.chevron_left),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                '予定を新しく追加',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '入力内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await planProvider.create(
                    organization: widget.loginProvider.organization,
                    group: selectedGroup,
                    category: selectedCategory,
                    subject: subjectController.text,
                    startedAt: startedAt,
                    endedAt: endedAt,
                    allDay: allDay,
                    repeat: repeat,
                    repeatInterval: repeatInterval,
                    repeatEvery: int.parse(repeatEveryController.text),
                    repeatWeeks: repeatWeeks,
                    memo: memoController.text,
                    alertMinute: alertMinute,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '予定を追加しました', true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 200,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '※『公開グループ』が未選択の場合、全てのスタッフが対象になります。',
                  style: TextStyle(
                    color: kRedColor,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  '※『公開グループ』を指定した場合、そのグループのスタッフのみ閲覧が可能になります。',
                  style: TextStyle(
                    color: kRedColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InfoLabel(
                      label: '公開グループ',
                      child: ComboBox<OrganizationGroupModel>(
                        value: selectedGroup,
                        items: groupItems,
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value;
                          });
                        },
                        placeholder: const Text(
                          'グループの指定なし',
                          style: TextStyle(color: kGreyColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InfoLabel(
                      label: 'カテゴリ',
                      child: ComboBox<CategoryModel>(
                        value: selectedCategory,
                        items: categories.map((category) {
                          return ComboBoxItem(
                            value: category,
                            child: Container(
                              color: category.color,
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              child: Text(
                                category.name,
                                style: const TextStyle(color: kWhiteColor),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        placeholder: const Text(
                          'カテゴリ未選択',
                          style: TextStyle(color: kGreyColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InfoLabel(
                        label: '件名',
                        child: CustomTextBox(
                          controller: subjectController,
                          placeholder: '',
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InfoLabel(
                  label: '予定時間帯を設定',
                  child: DatetimeRangeForm(
                    startedAt: startedAt,
                    startedOnTap: () async =>
                        await CustomDateTimePicker().picker(
                      context: context,
                      init: startedAt,
                      title: '予定開始日時を選択',
                      onChanged: (value) {
                        setState(() {
                          startedAt = value;
                          endedAt = startedAt.add(const Duration(hours: 1));
                        });
                      },
                    ),
                    endedAt: endedAt,
                    endedOnTap: () async => await CustomDateTimePicker().picker(
                      context: context,
                      init: endedAt,
                      title: '予定終了日時を選択',
                      onChanged: (value) {
                        setState(() {
                          endedAt = value;
                        });
                      },
                    ),
                    allDay: allDay,
                    allDayOnChanged: _allDayChange,
                  ),
                ),
                const SizedBox(height: 8),
                InfoLabel(
                  label: '繰り返し設定',
                  child: RepeatSelectForm(
                    repeat: repeat,
                    repeatOnChanged: (value) {
                      setState(() {
                        repeat = value!;
                      });
                    },
                    interval: repeatInterval,
                    intervalOnChanged: (value) {
                      setState(() {
                        repeatInterval = value;
                      });
                    },
                    everyController: repeatEveryController,
                    weeks: repeatWeeks,
                    weeksOnChanged: (value) {
                      if (repeatWeeks.contains(value)) {
                        repeatWeeks.remove(value);
                      } else {
                        repeatWeeks.add(value);
                      }
                      setState(() {});
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
                const SizedBox(height: 8),
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
        ),
      ),
    );
  }
}
