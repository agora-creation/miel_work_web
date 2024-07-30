import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_add.dart';
import 'package:miel_work_web/screens/apply_history.dart';
import 'package:miel_work_web/screens/apply_mod.dart';
import 'package:miel_work_web/services/apply.dart';
import 'package:miel_work_web/widgets/apply_list.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:page_transition/page_transition.dart';

class ApplyScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  ApplyService applyService = ApplyService();
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
          '各種申請',
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
                Row(
                  children: [
                    CustomIconTextButton(
                      label: '承認済一覧',
                      labelColor: kWhiteColor,
                      backgroundColor: kGreyColor,
                      leftIcon: FontAwesomeIcons.list,
                      onPressed: () => showBottomUpScreen(
                        context,
                        ApplyHistoryScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: '新規申請',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      leftIcon: FontAwesomeIcons.plus,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ApplyAddScreen(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchApproval: [0],
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                ),
                builder: (context, snapshot) {
                  List<ApplyModel> applies = [];
                  if (snapshot.hasData) {
                    applies = applyService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (applies.isEmpty) {
                    return const Center(
                        child: Text(
                      '承認待ちの申請はありません',
                      style: TextStyle(fontSize: 24),
                    ));
                  }
                  return ListView.builder(
                    itemCount: applies.length,
                    itemBuilder: (context, index) {
                      ApplyModel apply = applies[index];
                      return ApplyList(
                        apply: apply,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ApplyModScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                apply: apply,
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
