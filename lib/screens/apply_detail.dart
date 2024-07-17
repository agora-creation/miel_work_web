import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/providers/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_add.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class ApplyDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const ApplyDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<ApplyDetailScreen> createState() => _ApplyDetailScreenState();
}

class _ApplyDetailScreenState extends State<ApplyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    bool isApply = false;
    bool isDelete = true;
    if (widget.apply.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
      if (widget.apply.approval == 9) {
        isApply = true;
      }
    } else {
      isDelete = false;
    }
    if (widget.apply.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.apply.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.apply.approval == 1 || widget.apply.approval == 9) {
      isApproval = false;
      isReject = false;
      isDelete = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.apply.approvalUsers;
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
          '申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          isReject && widget.loginProvider.user?.president == true
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '否決する',
                  labelColor: kRedColor,
                  backgroundColor: kRed100Color,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => RejectApplyDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      apply: widget.apply,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(width: 4),
          isApproval
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '承認する',
                  labelColor: kWhiteColor,
                  backgroundColor: kRedColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ApprovalApplyDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      apply: widget.apply,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(width: 4),
          isApply
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '再申請する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ApplyAddScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          apply: widget.apply,
                        ),
                      ),
                    );
                  },
                )
              : Container(),
          const SizedBox(width: 8),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isDelete
                      ? LinkText(
                          label: 'この申請を削除する',
                          color: kRedColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => DelApplyDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              apply: widget.apply,
                            ),
                          ),
                        )
                      : Container(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '申請日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.createdAt)}',
                        style: const TextStyle(color: kGreyColor),
                      ),
                      Text(
                        '申請番号: ${widget.apply.number}',
                        style: const TextStyle(color: kGreyColor),
                      ),
                      widget.apply.approval == 1
                          ? Text(
                              '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.approvedAt)}',
                              style: const TextStyle(color: kGreyColor),
                            )
                          : Container(),
                      widget.apply.approval == 1
                          ? Text(
                              '承認番号: ${widget.apply.approvalNumber}',
                              style: const TextStyle(color: kGreyColor),
                            )
                          : Container(),
                      Text(
                        '申請者: ${widget.apply.createdUserName}',
                        style: const TextStyle(color: kGreyColor),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              reApprovalUsers.isNotEmpty
                  ? FormLabel(
                      '承認者一覧',
                      child: Container(
                        color: kRed100Color,
                        width: double.infinity,
                        child: Column(
                          children: reApprovalUsers.map((approvalUser) {
                            return CustomApprovalUserList(
                              approvalUser: approvalUser,
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '件名',
                child: FormValue(widget.apply.title),
              ),
              const SizedBox(height: 8),
              widget.apply.type == '稟議' || widget.apply.type == '支払伺い'
                  ? FormLabel(
                      '金額',
                      child: FormValue('¥ ${widget.apply.formatPrice()}'),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '内容',
                child: FormValue(widget.apply.content),
              ),
              const SizedBox(height: 8),
              widget.apply.approvalReason != ''
                  ? FormLabel(
                      '承認理由',
                      child: FormValue(widget.apply.approvalReason),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.reason != ''
                  ? FormLabel(
                      '否決理由',
                      child: FormValue(widget.apply.reason),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file != ''
                  ? LinkText(
                      label: '添付ファイル',
                      color: kBlueColor,
                      onTap: () {
                        File file = File(widget.apply.file);
                        downloadFile(
                          url: widget.apply.file,
                          name: p.basename(file.path),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file2 != ''
                  ? LinkText(
                      label: '添付ファイル2',
                      color: kBlueColor,
                      onTap: () {
                        File file = File(widget.apply.file2);
                        downloadFile(
                          url: widget.apply.file2,
                          name: p.basename(file.path),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file3 != ''
                  ? LinkText(
                      label: '添付ファイル3',
                      color: kBlueColor,
                      onTap: () {
                        File file = File(widget.apply.file3);
                        downloadFile(
                          url: widget.apply.file3,
                          name: p.basename(file.path),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file4 != ''
                  ? LinkText(
                      label: '添付ファイル4',
                      color: kBlueColor,
                      onTap: () {
                        File file = File(widget.apply.file4);
                        downloadFile(
                          url: widget.apply.file4,
                          name: p.basename(file.path),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file5 != ''
                  ? LinkText(
                      label: '添付ファイル5',
                      color: kBlueColor,
                      onTap: () {
                        File file = File(widget.apply.file5);
                        downloadFile(
                          url: widget.apply.file5,
                          name: p.basename(file.path),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 16),
              const Text(
                '※『承認』は、承認状況が「承認待ち」で、作成者・既承認者以外のスタッフが実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※『否決』は、承認状況が「承認待ち」で、管理者権限のスタッフのみ実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※『再申請』は、承認状況が「否決」で、作成者のスタッフのみ実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※『削除』は、承認状況が「承認待ち」で、作成者のスタッフのみ実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※管理者権限のスタッフが承認した場合のみ、承認状況が『承認済み』になります。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DelApplyDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const DelApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<DelApplyDialog> createState() => _DelApplyDialogState();
}

class _DelApplyDialogState extends State<DelApplyDialog> {
  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: const Column(
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
            String? error = await applyProvider.delete(
              apply: widget.apply,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請を削除しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ApprovalApplyDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const ApprovalApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<ApprovalApplyDialog> createState() => _ApprovalApplyDialogState();
}

class _ApprovalApplyDialogState extends State<ApprovalApplyDialog> {
  TextEditingController approvalNumberController = TextEditingController();
  TextEditingController approvalReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text('本当に承認しますか？'),
          const SizedBox(height: 8),
          FormLabel(
            '承認番号',
            child: CustomTextField(
              controller: approvalNumberController,
              textInputType: TextInputType.number,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '承認理由',
            child: CustomTextField(
              controller: approvalReasonController,
              textInputType: TextInputType.multiline,
              maxLines: 10,
            ),
          ),
        ],
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
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await applyProvider.approval(
              apply: widget.apply,
              loginUser: widget.loginProvider.user,
              approvalNumber: approvalNumberController.text,
              approvalReason: approvalReasonController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '承認しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class RejectApplyDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const RejectApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<RejectApplyDialog> createState() => _RejectApplyDialogState();
}

class _RejectApplyDialogState extends State<RejectApplyDialog> {
  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text('本当に否決しますか？'),
          const SizedBox(height: 8),
          FormLabel(
            '否決理由',
            child: CustomTextField(
              controller: reasonController,
              textInputType: TextInputType.multiline,
              maxLines: 10,
            ),
          ),
        ],
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
          labelColor: kRedColor,
          backgroundColor: kRed100Color,
          onPressed: () async {
            String? error = await applyProvider.reject(
              apply: widget.apply,
              reason: reasonController.text,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '否決しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
