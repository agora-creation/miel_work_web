import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_interview.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_interview.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestInterviewDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const RequestInterviewDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<RequestInterviewDetailScreen> createState() =>
      _RequestInterviewDetailScreenState();
}

class _RequestInterviewDetailScreenState
    extends State<RequestInterviewDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    if (widget.interview.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.interview.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.interview.approval == 1 || widget.interview.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.interview.approvalUsers;
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
            label: '否決する',
            labelColor: kWhiteColor,
            backgroundColor: kRejectColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => RejectRequestInterviewDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                interview: widget.interview,
              ),
            ),
            disabled: !isReject || widget.loginProvider.user?.president != true,
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '承認する',
            labelColor: kWhiteColor,
            backgroundColor: kApprovalColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ApprovalRequestInterviewDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                interview: widget.interview,
              ),
            ),
            disabled: !isApproval,
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
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.interview.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
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
              FormLabel(
                '会社名',
                child: FormValue(widget.interview.companyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者名',
                child: FormValue(widget.interview.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者メールアドレス',
                child: FormValue(widget.interview.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.interview.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者電話番号',
                child: FormValue(widget.interview.companyUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '媒体名',
                child: FormValue(widget.interview.mediaName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '番組・雑誌名',
                child: FormValue(widget.interview.programName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '出演者情報',
                child: FormValue(widget.interview.castInfo),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '特集内容・備考',
                child: FormValue(widget.interview.featureContent),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'OA・掲載予定日',
                child: FormValue(widget.interview.publishedAt),
              ),
              const SizedBox(height: 24),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '取材当日情報',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '予定日時',
                child: FormValue(widget.interview.interviewedAt),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者名',
                child: FormValue(widget.interview.interviewedUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者電話番号',
                child: FormValue(widget.interview.interviewedUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材時間',
                child: FormValue(widget.interview.interviewedTime),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '席の予約',
                child:
                    FormValue(widget.interview.interviewedReserved ? '必要' : ''),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材店舗',
                child: FormValue(widget.interview.interviewedShopName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '訪問人数',
                child: FormValue(widget.interview.interviewedVisitors),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材内容・備考',
                child: FormValue(widget.interview.interviewedContent),
              ),
              const SizedBox(height: 24),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                'ロケハン情報',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '予定日時',
                child: FormValue(widget.interview.locationAt),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者名',
                child: FormValue(widget.interview.locationUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者電話番号',
                child: FormValue(widget.interview.locationUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '訪問人数',
                child: FormValue(widget.interview.locationVisitors),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'ロケハン内容・備考',
                child: FormValue(widget.interview.locationContent),
              ),
              const SizedBox(height: 24),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                'インサート撮影情報',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '予定日時',
                child: FormValue(widget.interview.insertedAt),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者名',
                child: FormValue(widget.interview.insertedUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '担当者電話番号',
                child: FormValue(widget.interview.insertedUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '撮影時間',
                child: FormValue(widget.interview.insertedTime),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '席の予約',
                child: FormValue(widget.interview.insertedReserved ? '必要' : ''),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材店舗',
                child: FormValue(widget.interview.insertedShopName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '訪問人数',
                child: FormValue(widget.interview.insertedVisitors),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '撮影内容・備考',
                child: FormValue(widget.interview.insertedContent),
              ),
              const SizedBox(height: 24),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                'その他連絡事項',
                child: FormValue(widget.interview.remarks),
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

class ApprovalRequestInterviewDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const ApprovalRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<ApprovalRequestInterviewDialog> createState() =>
      _ApprovalRequestInterviewDialogState();
}

class _ApprovalRequestInterviewDialogState
    extends State<ApprovalRequestInterviewDialog> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に承認しますか？'),
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
          label: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kApprovalColor,
          onPressed: () async {
            String? error = await interviewProvider.approval(
              interview: widget.interview,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請が承認されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class RejectRequestInterviewDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const RejectRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<RejectRequestInterviewDialog> createState() =>
      _RejectRequestInterviewDialogState();
}

class _RejectRequestInterviewDialogState
    extends State<RejectRequestInterviewDialog> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に否決しますか？'),
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
          label: '否決する',
          labelColor: kWhiteColor,
          backgroundColor: kRejectColor,
          onPressed: () async {
            String? error = await interviewProvider.reject(
              interview: widget.interview,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請が否決されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}