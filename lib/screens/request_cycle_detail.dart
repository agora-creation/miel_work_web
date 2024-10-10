import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_cycle.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_cycle.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestCycleDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const RequestCycleDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

  @override
  State<RequestCycleDetailScreen> createState() =>
      _RequestCycleDetailScreenState();
}

class _RequestCycleDetailScreenState extends State<RequestCycleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    if (widget.cycle.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.cycle.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.cycle.approval == 1 || widget.cycle.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.cycle.approvalUsers;
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
              builder: (context) => RejectRequestCycleDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                cycle: widget.cycle,
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
              builder: (context) => ApprovalRequestCycleDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                cycle: widget.cycle,
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
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.cycle.createdAt)}',
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
                '店舗名',
                child: FormValue(widget.cycle.shopName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: FormValue(widget.cycle.shopUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者メールアドレス',
                child: FormValue(widget.cycle.shopUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.cycle.shopUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者電話番号',
                child: FormValue(widget.cycle.shopUserTel),
              ),
              const SizedBox(height: 24),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                'その他連絡事項',
                child: FormValue(widget.cycle.remarks),
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

class ApprovalRequestCycleDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const ApprovalRequestCycleDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

  @override
  State<ApprovalRequestCycleDialog> createState() =>
      _ApprovalRequestCycleDialogState();
}

class _ApprovalRequestCycleDialogState
    extends State<ApprovalRequestCycleDialog> {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
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
            String? error = await cycleProvider.approval(
              cycle: widget.cycle,
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

class RejectRequestCycleDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const RejectRequestCycleDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

  @override
  State<RejectRequestCycleDialog> createState() =>
      _RejectRequestCycleDialogState();
}

class _RejectRequestCycleDialogState extends State<RejectRequestCycleDialog> {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
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
            String? error = await cycleProvider.reject(
              cycle: widget.cycle,
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
