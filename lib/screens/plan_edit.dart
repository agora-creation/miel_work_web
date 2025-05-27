import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan.dart';
import 'package:miel_work_web/services/category.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:provider/provider.dart';

class PlanEditScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanModel? plan;

  const PlanEditScreen({
    required this.loginProvider,
    required this.homeProvider,
    this.plan,
    super.key,
  });

  @override
  State<PlanEditScreen> createState() => _PlanEditScreenState();
}

class _PlanEditScreenState extends State<PlanEditScreen> {
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
    if (widget.plan != null) {
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        if (group.id == widget.plan!.groupId) {
          selectedGroup = group;
        }
      }
      categories = await categoryService.selectList(
        organizationId: widget.loginProvider.organization?.id,
      );
      selectedCategory =
          categories.firstWhere((e) => e.name == widget.plan!.category);
      subjectController.text = widget.plan!.subject;
      startedAt = widget.plan!.startedAt;
      endedAt = widget.plan!.endedAt;
      allDay = widget.plan!.allDay;
      repeat = widget.plan!.repeat;
      repeatInterval = widget.plan!.repeatInterval;
      repeatEveryController.text = widget.plan!.repeatEvery.toString();
      repeatWeeks = widget.plan!.repeatWeeks;
      memoController.text = widget.plan!.memo;
      alertMinute = widget.plan!.alertMinute;
    } else {
      selectedGroup = widget.homeProvider.currentGroup;
      categories = await categoryService.selectList(
        organizationId: widget.loginProvider.organization?.id,
      );
      selectedCategory = categories.first;
      startedAt = DateTime.now();
      endedAt = startedAt.add(const Duration(hours: 1));
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
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const DropdownMenuItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(DropdownMenuItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
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
          '予定の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          widget.plan != null
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '削除する',
                  labelColor: kWhiteColor,
                  backgroundColor: kRedColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DelPlanDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      plan: widget.plan!,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(width: 4),
          widget.plan != null
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保存する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () async {
                    String? error = await planProvider.update(
                      plan: widget.plan!,
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
                      loginUser: widget.loginProvider.user,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '予定が変更されました', true);
                    Navigator.pop(context);
                  },
                )
              : Container(),
          const SizedBox(width: 4),
          widget.plan == null
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '以下の内容で保存する',
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
                      loginUser: widget.loginProvider.user,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '新しい予定が追加されました', true);
                    Navigator.pop(context);
                  },
                )
              : Container(),
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
                  Expanded(
                    child: FormLabel(
                      '公開グループ',
                      child: DropdownButton<OrganizationGroupModel>(
                        isExpanded: true,
                        value: selectedGroup,
                        items: groupItems,
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      'カテゴリ',
                      child: DropdownButton<CategoryModel>(
                        isExpanded: true,
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
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
                      ),
                    ),
                  ),
                ],
              ),
              FormLabel(
                '件名',
                child: CustomTextField(
                  controller: subjectController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '予定時間帯を設定',
                child: DatetimeRangeForm(
                  startedAt: startedAt,
                  startedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    pickerType: DateTimePickerType.datetime,
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
                    pickerType: DateTimePickerType.datetime,
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
              FormLabel(
                '社内メモ',
                child: CustomTextField(
                  controller: memoController,
                  textInputType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '事前アラート通知',
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: alertMinute,
                  items: kAlertMinutes.map((value) {
                    return DropdownMenuItem(
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
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class DelPlanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanModel plan;

  const DelPlanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.plan,
    super.key,
  });

  @override
  State<DelPlanDialog> createState() => _DelPlanDialogState();
}

class _DelPlanDialogState extends State<DelPlanDialog> {
  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
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
            String? error = await planProvider.delete(
              plan: widget.plan,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '予定を削除しました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
