import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/category.dart';
import 'package:miel_work_web/screens/plan_timeline.dart';
import 'package:miel_work_web/services/category.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/category_checkbox_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/day_list.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
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
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];
  sfc.CalendarController calendarController = sfc.CalendarController();

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _init() {
    days = generateDays(searchMonth);
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
    _init();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CustomIconTextButton(
                      label: '年月検索: ${dateText('yyyy年MM月', searchMonth)}',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () async {
                        DateTime? selected = await showMonthPicker(
                          context: context,
                          initialDate: searchMonth,
                          locale: const Locale('ja'),
                        );
                        if (selected == null) return;
                        _changeMonth(selected);
                      },
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: 'カテゴリ検索: $searchText',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SearchCategoryDialog(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          searchCategoriesChange: _searchCategoriesChange,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomIconTextButton(
                      label: 'カテゴリ一覧',
                      labelColor: kWhiteColor,
                      backgroundColor: kAmberColor,
                      leftIcon: FontAwesomeIcons.tag,
                      onPressed: () => showBottomUpScreen(
                        context,
                        CategoryScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: '予定を追加',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      leftIcon: FontAwesomeIcons.plus,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kBorderColor),
                ),
                child: ListView.builder(
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    DateTime day = days[index];
                    return DayList(
                      day,
                      child: Container(),
                    );
                  },
                ),
              ),
            ),
            // Expanded(
            //   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            //     stream: planService.streamList(
            //       organizationId: widget.loginProvider.organization?.id,
            //       categories: searchCategories,
            //     ),
            //     builder: (context, snapshot) {
            //       List<sfc.Appointment> appointments = [];
            //       if (snapshot.hasData) {
            //         appointments = planService.generateListAppointment(
            //           data: snapshot.data,
            //           currentGroup: widget.homeProvider.currentGroup,
            //         );
            //       }
            //       return CustomCalendar(
            //         dataSource: _DataSource(appointments),
            //         onLongPress: _calendarTap,
            //         controller: calendarController,
            //       );
            //     },
            //   ),
            // ),
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
          label: '検索する',
          labelColor: kWhiteColor,
          backgroundColor: kSearchColor,
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
