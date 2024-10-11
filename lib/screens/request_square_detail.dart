import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_square.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_square.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestSquareDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const RequestSquareDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<RequestSquareDetailScreen> createState() =>
      _RequestSquareDetailScreenState();
}

class _RequestSquareDetailScreenState extends State<RequestSquareDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    if (widget.square.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.square.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.square.approval == 1 || widget.square.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.square.approvalUsers;
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
          'よさこい広場使用申込：申請情報の詳細',
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
              builder: (context) => RejectRequestSquareDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                square: widget.square,
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
              builder: (context) => ApprovalRequestSquareDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                square: widget.square,
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
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.square.createdAt)}',
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
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '申込者情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込会社名(又は店名)',
                child: FormValue(widget.square.companyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: FormValue(widget.square.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: FormValue(widget.square.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.square.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者電話番号',
                child: FormValue(widget.square.companyUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '住所',
                child: FormValue(widget.square.companyAddress),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '使用者情報 (申込者情報と異なる場合のみ)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用会社名(又は店名)',
                child: FormValue(widget.square.useCompanyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: FormValue(widget.square.useCompanyUserName),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '使用情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用予定日時',
                child: FormValue(
                  widget.square.useAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', widget.square.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.square.useEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用区分',
                child: Column(
                  children: [
                    widget.square.useFull
                        ? const ListTile(
                            title: Text('全面使用'),
                          )
                        : Container(),
                    widget.square.useChair
                        ? const ListTile(
                            title: Text('折りたたみイス'),
                            subtitle: Text('150円(税抜)／1脚・1日'),
                          )
                        : Container(),
                    widget.square.useDesk
                        ? const ListTile(
                            title: Text('折りたたみ机'),
                            subtitle: Text('300円(税抜)／1脚・1日'),
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用内容',
                child: FormValue(widget.square.useContent),
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

class ApprovalRequestSquareDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const ApprovalRequestSquareDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<ApprovalRequestSquareDialog> createState() =>
      _ApprovalRequestSquareDialogState();
}

class _ApprovalRequestSquareDialogState
    extends State<ApprovalRequestSquareDialog> {
  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
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
            String? error = await squareProvider.approval(
              square: widget.square,
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

class RejectRequestSquareDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const RejectRequestSquareDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<RejectRequestSquareDialog> createState() =>
      _RejectRequestSquareDialogState();
}

class _RejectRequestSquareDialogState extends State<RejectRequestSquareDialog> {
  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
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
            String? error = await squareProvider.reject(
              square: widget.square,
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
