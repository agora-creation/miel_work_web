import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/request_overtime_detail.dart';
import 'package:miel_work_web/screens/request_overtime_history.dart';
import 'package:miel_work_web/services/request_overtime.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/request_overtime_list.dart';
import 'package:page_transition/page_transition.dart';

class RequestOvertimeScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const RequestOvertimeScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<RequestOvertimeScreen> createState() => _RequestOvertimeScreenState();
}

class _RequestOvertimeScreenState extends State<RequestOvertimeScreen> {
  RequestOvertimeService overtimeService = RequestOvertimeService();
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
          '社外申請：夜間居残り作業申請',
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
                      label: 'フォーム内記載の連絡先編集',
                      labelColor: kWhiteColor,
                      backgroundColor: kCyanColor,
                      leftIcon: FontAwesomeIcons.pen,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ModContactDialog(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: '承認済一覧',
                      labelColor: kWhiteColor,
                      backgroundColor: kGreyColor,
                      leftIcon: FontAwesomeIcons.list,
                      onPressed: () => showBottomUpScreen(
                        context,
                        RequestOvertimeHistoryScreen(
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
                stream: overtimeService.streamList(
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  approval: [0],
                ),
                builder: (context, snapshot) {
                  List<RequestOvertimeModel> overtimes = [];
                  if (snapshot.hasData) {
                    overtimes = overtimeService.generateList(snapshot.data);
                  }
                  if (overtimes.isEmpty) {
                    return const Center(
                        child: Text(
                      '承認待ちの申請はありません',
                      style: TextStyle(fontSize: 24),
                    ));
                  }
                  return ListView.builder(
                    itemCount: overtimes.length,
                    itemBuilder: (context, index) {
                      RequestOvertimeModel overtime = overtimes[index];
                      return RequestOvertimeList(
                        overtime: overtime,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: RequestOvertimeDetailScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                overtime: overtime,
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

class ModContactDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ModContactDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ModContactDialog> createState() => _ModContactDialogState();
}

class _ModContactDialogState extends State<ModContactDialog> {
  TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    contactController.text = widget.loginProvider.organization?.contact ?? '';
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
            FormLabel(
              'フォーム内記載の連絡先',
              child: CustomTextField(
                controller: contactController,
                textInputType: TextInputType.multiline,
                maxLines: 3,
              ),
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
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error =
                await widget.loginProvider.organizationContactUpdate(
              organization: widget.loginProvider.organization,
              contact: contactController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await widget.loginProvider.reload();
            widget.homeProvider.setGroups(
              organizationId: widget.loginProvider.organization?.id ?? 'error',
            );
            if (!mounted) return;
            showMessage(context, '連絡先を保存されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
