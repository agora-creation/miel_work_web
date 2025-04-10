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
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
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
  bool searchProcessed = false;

  void _getProcessed() async {
    searchProcessed = await getPrefsBool('processed') ?? false;
    setState(() {});
  }

  @override
  void initState() {
    _getProcessed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String searchText = '指定なし';
    if (searchStart != null && searchEnd != null) {
      searchText =
          '${dateText('yyyy/MM/dd', searchStart)}～${dateText('yyyy/MM/dd', searchEnd)}';
    }
    String searchProcessedText = '処理待';
    if (searchProcessed) {
      searchProcessedText = '処理済';
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
                      label: '期間検索: $searchText',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
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
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: '処理状況検索: $searchProcessedText',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SearchProcessedDialog(
                          getProcessed: _getProcessed,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomIconTextButton(
                  label: 'クレーム／要望を追加',
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
                  processed: searchProcessed,
                ),
                builder: (context, snapshot) {
                  List<ProblemModel> problems = [];
                  if (snapshot.hasData) {
                    problems = problemService.generateList(data: snapshot.data);
                  }
                  if (problems.isEmpty) {
                    return const Center(
                        child: Text(
                      'クレーム／要望はありません',
                      style: TextStyle(fontSize: 24),
                    ));
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

class SearchProcessedDialog extends StatefulWidget {
  final Function() getProcessed;

  const SearchProcessedDialog({
    required this.getProcessed,
    super.key,
  });

  @override
  State<SearchProcessedDialog> createState() => _SearchProcessedDialogState();
}

class _SearchProcessedDialogState extends State<SearchProcessedDialog> {
  bool processed = false;

  void _getProcessed() async {
    processed = await getPrefsBool('processed') ?? false;
    setState(() {});
  }

  @override
  void initState() {
    _getProcessed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            RadioListTile(
              title: const Text('処理待'),
              value: false,
              groupValue: processed,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  processed = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('処理済'),
              value: true,
              groupValue: processed,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  processed = value;
                });
              },
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
          label: '検索する',
          labelColor: kWhiteColor,
          backgroundColor: kSearchColor,
          onPressed: () async {
            await setPrefsBool('processed', processed);
            widget.getProcessed();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
