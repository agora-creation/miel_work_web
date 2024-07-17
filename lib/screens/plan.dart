import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/category.dart';
import 'package:miel_work_web/screens/plan_timeline.dart';
import 'package:miel_work_web/screens/shift_setting.dart';
import 'package:miel_work_web/services/category.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/category_checkbox_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_calendar.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  PlanService planService = PlanService();
  List<String> searchCategories = [];
  sfc.CalendarController calendarController = sfc.CalendarController();

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _calendarTap(sfc.CalendarLongPressDetails details) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: PlanTimelineScreen(
          loginProvider: widget.loginProvider,
          homeProvider: widget.homeProvider,
          date: details.date ?? DateTime.now(),
        ),
      ),
    );
  }

  @override
  void initState() {
    calendarController.selectedDate = DateTime.now();
    _searchCategoriesChange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String searchText = '指定なし';
    if (searchCategories.isNotEmpty) {
      searchText = '';
      for (String category in searchCategories) {
        if (searchText != '') searchText += ',';
        searchText += category;
      }
    }
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          'スケジュール',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomIconTextButton(
                  label: 'カテゴリ検索: $searchText',
                  labelColor: kWhiteColor,
                  backgroundColor: kLightBlueColor,
                  leftIcon: FontAwesomeIcons.searchengin,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SearchCategoryDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      searchCategoriesChange: _searchCategoriesChange,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomIconTextButton(
                      label: 'シフト表専用画面設定',
                      labelColor: kWhiteColor,
                      backgroundColor: kLightGreenColor,
                      leftIcon: FontAwesomeIcons.gear,
                      onPressed: () => showBottomUpScreen(
                        context,
                        ShiftSettingScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: 'カテゴリ管理',
                      labelColor: kWhiteColor,
                      backgroundColor: kCyanColor,
                      leftIcon: FontAwesomeIcons.tag,
                      onPressed: () => showBottomUpScreen(
                        context,
                        CategoryScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: planService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  categories: searchCategories,
                ),
                builder: (context, snapshot) {
                  List<sfc.Appointment> appointments = [];
                  if (snapshot.hasData) {
                    appointments = planService.generateListAppointment(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  return CustomCalendar(
                    dataSource: _DataSource(appointments),
                    onLongPress: _calendarTap,
                    controller: calendarController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataSource extends sfc.CalendarDataSource {
  _DataSource(List<sfc.Appointment> source) {
    appointments = source;
  }
}

class SearchCategoryDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function() searchCategoriesChange;

  const SearchCategoryDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.searchCategoriesChange,
    super.key,
  });

  @override
  State<SearchCategoryDialog> createState() => _SearchCategoryDialogState();
}

class _SearchCategoryDialogState extends State<SearchCategoryDialog> {
  CategoryService categoryService = CategoryService();
  List<CategoryModel> categories = [];
  List<String> searchCategories = [];

  void _init() async {
    categories = await categoryService.selectList(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
    );
    searchCategories = await getPrefsList('categories') ?? [];
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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: categories.map((category) {
            return CategoryCheckboxList(
              category: category,
              value: searchCategories.contains(category.name),
              onChanged: (value) {
                if (searchCategories.contains(category.name)) {
                  searchCategories.remove(category.name);
                } else {
                  searchCategories.add(category.name);
                }
                setState(() {});
              },
            );
          }).toList(),
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
          label: '検索実行',
          labelColor: kBlue600Color,
          backgroundColor: kBlue100Color,
          onPressed: () async {
            await setPrefsList('categories', searchCategories);
            widget.searchCategoriesChange();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
