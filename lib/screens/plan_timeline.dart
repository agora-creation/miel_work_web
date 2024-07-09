import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/plan_add.dart';
import 'package:miel_work_web/screens/plan_mod.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/plan_list.dart';

class PlanTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime date;

  const PlanTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.date,
    super.key,
  });

  @override
  State<PlanTimelineScreen> createState() => _PlanTimelineScreenState();
}

class _PlanTimelineScreenState extends State<PlanTimelineScreen> {
  PlanService planService = PlanService();
  List<String> searchCategories = [];

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchCategoriesChange();
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                dateText('yyyy年MM月dd日(E)', widget.date),
                style: const TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '予定の追加',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () => Navigator.push(
                  context,
                  FluentPageRoute(
                    builder: (context) => PlanAddScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      date: widget.date,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: planService.streamList(
            organizationId: widget.loginProvider.organization?.id,
            categories: searchCategories,
          ),
          builder: (context, snapshot) {
            List<PlanModel> plans = [];
            if (snapshot.hasData) {
              plans = planService.generateList(
                data: snapshot.data,
                currentGroup: widget.homeProvider.currentGroup,
                date: widget.date,
              );
            }
            if (plans.isEmpty) {
              return const Center(child: Text('予定はありません'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                PlanModel plan = plans[index];
                return PlanList(
                  plan: plan,
                  groups: widget.homeProvider.groups,
                  onTap: () => Navigator.push(
                    context,
                    FluentPageRoute(
                      builder: (context) => PlanModScreen(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        planId: plan.id,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
