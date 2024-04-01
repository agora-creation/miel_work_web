import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/category.dart';
import 'package:miel_work_web/screens/plan_timeline.dart';
import 'package:miel_work_web/services/category.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_calendar.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
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

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _calendarTap(sfc.CalendarTapDetails details) {
    Navigator.push(
      context,
      FluentPageRoute(
        builder: (context) => PlanTimelineScreen(
          loginProvider: widget.loginProvider,
          homeProvider: widget.homeProvider,
          date: details.date ?? DateTime.now(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchCategoriesChange();
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
    return Stack(
      children: [
        const AnimationBackground(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InfoLabel(
                      label: 'カテゴリ検索',
                      child: Button(
                        child: Text(searchText),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => SearchCategoryDialog(
                            loginProvider: widget.loginProvider,
                            searchCategoriesChange: _searchCategoriesChange,
                          ),
                        ),
                      ),
                    ),
                    CustomButtonSm(
                      icon: FluentIcons.bulleted_list,
                      labelText: 'カテゴリ管理',
                      labelColor: kWhiteColor,
                      backgroundColor: kCyanColor,
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: planService.streamList(
                      organizationId: widget.loginProvider.organization?.id,
                      groupId: widget.homeProvider.currentGroup?.id,
                      categories: searchCategories,
                    ),
                    builder: (context, snapshot) {
                      List<sfc.Appointment> appointments = [];
                      if (snapshot.hasData) {
                        appointments = planService.generateListAppointment(
                          data: snapshot.data,
                        );
                      }
                      return CustomCalendar(
                        dataSource: _DataSource(appointments),
                        onTap: _calendarTap,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
  final Function() searchCategoriesChange;

  const SearchCategoryDialog({
    required this.loginProvider,
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
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'カテゴリ検索',
        style: TextStyle(fontSize: 18),
      ),
      content: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kGrey300Color),
        ),
        height: 300,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            CategoryModel category = categories[index];
            return CustomCheckbox(
              label: category.name,
              labelColor: kWhiteColor,
              backgroundColor: category.color,
              checked: searchCategories.contains(category.name),
              onChanged: (value) {
                if (searchCategories.contains(category.name)) {
                  searchCategories.remove(category.name);
                } else {
                  searchCategories.add(category.name);
                }
                setState(() {});
              },
            );
          },
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
          labelText: '検索する',
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
