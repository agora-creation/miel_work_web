import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_overtime.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestOvertimeHistoryDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const RequestOvertimeHistoryDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<RequestOvertimeHistoryDetailScreen> createState() =>
      _RequestOvertimeHistoryDetailScreenState();
}

class _RequestOvertimeHistoryDetailScreenState
    extends State<RequestOvertimeHistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    List<ApprovalUserModel> approvalUsers = widget.overtime.approvalUsers;
    List<ApprovalUserModel> reApprovalUsers = approvalUsers.reversed.toList();
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: kBlackColor,
            size: 16,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '申請情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '削除する',
            labelColor: kWhiteColor,
            backgroundColor: kRedColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelRequestOvertimeDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                overtime: widget.overtime,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.overtime.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.overtime.approvedAt)}',
                    style: const TextStyle(color: kRedColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FormLabel(
                '承認者一覧',
                child: Container(
                  color: kRedColor.withOpacity(0.3),
                  width: double.infinity,
                  child: Column(
                    children: reApprovalUsers.map((approvalUser) {
                      return ApprovalUserList(approvalUser: approvalUser);
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '申請者情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗名',
                child: FormValue(widget.overtime.companyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者名',
                child: FormValue(widget.overtime.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者メールアドレス',
                child: FormValue(widget.overtime.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.overtime.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者電話番号',
                child: FormValue(widget.overtime.companyUserTel),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '作業情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '作業予定日時',
                child: FormValue(
                  widget.overtime.useAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', widget.overtime.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.overtime.useEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '作業内容',
                child: FormValue(widget.overtime.useContent),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class DelRequestOvertimeDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const DelRequestOvertimeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<DelRequestOvertimeDialog> createState() =>
      _DelRequestOvertimeDialogState();
}

class _DelRequestOvertimeDialogState extends State<DelRequestOvertimeDialog> {
  @override
  Widget build(BuildContext context) {
    final overtimeProvider = Provider.of<RequestOvertimeProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
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
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await overtimeProvider.delete(
              overtime: widget.overtime,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請情報が削除されました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
