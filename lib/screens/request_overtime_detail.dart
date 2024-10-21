import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_overtime.dart';
import 'package:miel_work_web/screens/request_overtime_mod.dart';
import 'package:miel_work_web/services/request_overtime.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/attached_file_list.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestOvertimeDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const RequestOvertimeDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<RequestOvertimeDetailScreen> createState() =>
      _RequestOvertimeDetailScreenState();
}

class _RequestOvertimeDetailScreenState
    extends State<RequestOvertimeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    if (widget.overtime.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.overtime.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.overtime.approval == 1 || widget.overtime.approval == 9) {
      isApproval = false;
      isReject = false;
    }
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
          '夜間居残り作業申請：申請情報の詳細',
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
          CustomButton(
            type: ButtonSizeType.sm,
            label: '編集する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: RequestOvertimeModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    overtime: widget.overtime,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '否決する',
            labelColor: kWhiteColor,
            backgroundColor: kRejectColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => RejectRequestOvertimeDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                overtime: widget.overtime,
              ),
            ),
            disabled: !isReject,
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '承認する',
            labelColor: kWhiteColor,
            backgroundColor: kApprovalColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ApprovalRequestOvertimeDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                overtime: widget.overtime,
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
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', widget.overtime.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  widget.overtime.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.overtime.approvedAt)}',
                          style: const TextStyle(color: kRedColor),
                        )
                      : Container(),
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
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.overtime.attachedFiles.map((file) {
                        return AttachedFileList(
                          fileName: p.basename(file),
                          onTap: () {
                            downloadFile(
                              url: file,
                              name: p.basename(file),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 8),
              Container(
                color: kGreyColor.withOpacity(0.2),
                padding: const EdgeInsets.all(16),
                child: FormLabel(
                  '社内コメント',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      widget.overtime.comments.isNotEmpty
                          ? Column(
                              children: widget.overtime.comments.map((comment) {
                                return CommentList(comment: comment);
                              }).toList(),
                            )
                          : const ListTile(title: Text('コメントがありません')),
                      const SizedBox(height: 8),
                      CustomButton(
                        type: ButtonSizeType.sm,
                        label: 'コメント追加',
                        labelColor: kWhiteColor,
                        backgroundColor: kBlueColor,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
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

class ModUseAtDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const ModUseAtDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<ModUseAtDialog> createState() => _ModUseAtDialogState();
}

class _ModUseAtDialogState extends State<ModUseAtDialog> {
  RequestOvertimeService overtimeService = RequestOvertimeService();
  DateTime useStartedAt = DateTime.now();
  DateTime useEndedAt = DateTime.now();

  @override
  void initState() {
    useStartedAt = widget.overtime.useStartedAt;
    useEndedAt = widget.overtime.useEndedAt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            FormLabel(
              '作業予定日時',
              child: DatetimeRangeForm(
                startedAt: useStartedAt,
                startedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  init: useStartedAt,
                  title: '作業予定開始日時を選択',
                  onChanged: (value) {
                    setState(() {
                      useStartedAt = value;
                    });
                  },
                ),
                endedAt: useEndedAt,
                endedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  init: useEndedAt,
                  title: '作業予定終了日時を選択',
                  onChanged: (value) {
                    setState(() {
                      useEndedAt = value;
                    });
                  },
                ),
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
          label: '変更する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            overtimeService.update({
              'id': widget.overtime.id,
              'useStartedAt': useStartedAt,
              'useEndedAt': useEndedAt,
              'useAtPending': false,
            });
            if (!mounted) return;
            showMessage(context, '作業予定日時が変更されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ApprovalRequestOvertimeDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const ApprovalRequestOvertimeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<ApprovalRequestOvertimeDialog> createState() =>
      _ApprovalRequestOvertimeDialogState();
}

class _ApprovalRequestOvertimeDialogState
    extends State<ApprovalRequestOvertimeDialog> {
  @override
  Widget build(BuildContext context) {
    final overtimeProvider = Provider.of<RequestOvertimeProvider>(context);
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
            String? error = await overtimeProvider.approval(
              overtime: widget.overtime,
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

class RejectRequestOvertimeDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const RejectRequestOvertimeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<RejectRequestOvertimeDialog> createState() =>
      _RejectRequestOvertimeDialogState();
}

class _RejectRequestOvertimeDialogState
    extends State<RejectRequestOvertimeDialog> {
  @override
  Widget build(BuildContext context) {
    final overtimeProvider = Provider.of<RequestOvertimeProvider>(context);
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
            String? error = await overtimeProvider.reject(
              overtime: widget.overtime,
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
