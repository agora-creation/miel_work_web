import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/problem_add.dart';
import 'package:miel_work_web/screens/problem_mod.dart';
import 'package:miel_work_web/services/problem.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/problem_list.dart';
import 'package:page_transition/page_transition.dart';

class ProblemScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ProblemScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  ProblemService problemService = ProblemService();
  DateTime? searchStart;
  DateTime? searchEnd;

  @override
  Widget build(BuildContext context) {
    String searchText = '指定なし';
    if (searchStart != null && searchEnd != null) {
      searchText =
          '${dateText('yyyy/MM/dd', searchStart)}～${dateText('yyyy/MM/dd', searchEnd)}';
    }
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          'クレーム／要望',
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
                  label: '期間検索: $searchText',
                  labelColor: kWhiteColor,
                  backgroundColor: kLightBlueColor,
                  leftIcon: FontAwesomeIcons.searchengin,
                  onPressed: () async {
                    var selected = await showDataRangePickerDialog(
                      context: context,
                      startValue: searchStart,
                      endValue: searchEnd,
                    );
                    if (selected != null &&
                        selected.first != null &&
                        selected.last != null) {
                      var diff = selected.last!.difference(selected.first!);
                      int diffDays = diff.inDays;
                      if (diffDays > 31) {
                        if (!mounted) return;
                        showMessage(context, '1ヵ月以上の範囲が選択されています', false);
                        return;
                      }
                      searchStart = selected.first;
                      searchEnd = selected.last;
                      setState(() {});
                    }
                  },
                ),
                CustomIconTextButton(
                  label: '新規追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  leftIcon: FontAwesomeIcons.plus,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ProblemAddScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: problemService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                ),
                builder: (context, snapshot) {
                  List<ProblemModel> problems = [];
                  if (snapshot.hasData) {
                    problems = problemService.generateList(data: snapshot.data);
                  }
                  return ListView.builder(
                    itemCount: problems.length,
                    itemBuilder: (context, index) {
                      ProblemModel problem = problems[index];
                      return ProblemList(
                        problem: problem,
                        user: widget.loginProvider.user,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ProblemModScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                problem: problem,
                              ),
                            ),
                          );
                        },
                      );
                    },
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
