import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_cycle.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/request_cycle_detail.dart';
import 'package:miel_work_web/screens/request_cycle_history.dart';
import 'package:miel_work_web/services/request_cycle.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/request_cycle_list.dart';
import 'package:page_transition/page_transition.dart';

class RequestCycleScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const RequestCycleScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<RequestCycleScreen> createState() => _RequestCycleScreenState();
}

class _RequestCycleScreenState extends State<RequestCycleScreen> {
  RequestCycleService cycleService = RequestCycleService();
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
          '社外申請：自転車置き場使用申込',
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
                      label: '件名検索: ',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () {},
                    ),
                  ],
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
                        RequestCycleHistoryScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: cycleService.streamList(
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  approval: [0],
                ),
                builder: (context, snapshot) {
                  List<RequestCycleModel> cycles = [];
                  if (snapshot.hasData) {
                    cycles = cycleService.generateList(snapshot.data);
                  }
                  if (cycles.isEmpty) {
                    return const Center(
                        child: Text(
                      '承認待ちの申請はありません',
                      style: TextStyle(fontSize: 24),
                    ));
                  }
                  return ListView.builder(
                    itemCount: cycles.length,
                    itemBuilder: (context, index) {
                      RequestCycleModel cycle = cycles[index];
                      return RequestCycleList(
                        cycle: cycle,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: RequestCycleDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                cycle: cycle,
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
