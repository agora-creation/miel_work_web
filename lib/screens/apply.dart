import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_add.dart';
import 'package:miel_work_web/screens/apply_detail.dart';
import 'package:miel_work_web/services/apply.dart';
import 'package:miel_work_web/widgets/apply_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
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
  int searchApproval = 0;

  void _getApproval() async {
    searchApproval = await getPrefsInt('approval') ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    _getApproval();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String searchText = '指定なし';
    if (searchStart != null && searchEnd != null) {
      searchText =
          '${dateText('yyyy/MM/dd', searchStart)}～${dateText('yyyy/MM/dd', searchEnd)}';
    }
    String searchApprovalText = '承認待ち';
    switch (searchApproval) {
      case 0:
        searchApprovalText = '承認待ち';
      case 1:
        searchApprovalText = '承認済み';
      case 9:
        searchApprovalText = '否決';
      default:
        searchApprovalText = '承認待ち';
    }
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '社内申請',
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
                      label: '承認状況検索: $searchApprovalText',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SearchApprovalDialog(
                          getApproval: _getApproval,
                        ),
                      ),
                    ),
                  ],
                ),
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
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: applyService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  approval: [searchApproval],
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
                        user: widget.loginProvider.user,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ApplyDetailScreen(
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

class SearchApprovalDialog extends StatefulWidget {
  final Function() getApproval;

  const SearchApprovalDialog({
    required this.getApproval,
    super.key,
  });

  @override
  State<SearchApprovalDialog> createState() => _SearchApprovalDialogState();
}

class _SearchApprovalDialogState extends State<SearchApprovalDialog> {
  int approval = 0;

  void _getApproval() async {
    approval = await getPrefsInt('approval') ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    _getApproval();
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
              title: const Text('承認待ち'),
              value: 0,
              groupValue: approval,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  approval = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('承認済み'),
              value: 1,
              groupValue: approval,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  approval = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('否決'),
              value: 9,
              groupValue: approval,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  approval = value;
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
            await setPrefsInt('approval', approval);
            widget.getApproval();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
