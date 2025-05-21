import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/apply.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/apply.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
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
  ApplyService applyService = ApplyService();
  ApplyModel? apply;
  List<CommentModel> comments = [];

  void _showTextField({
    required TextEditingController controller,
    TextInputType textInputType = TextInputType.text,
    required Function() onPressed,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomAlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: controller,
              textInputType: textInputType,
              maxLines: textInputType == TextInputType.text ? 1 : null,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  type: ButtonSizeType.sm,
                  label: 'キャンセル',
                  labelColor: kWhiteColor,
                  backgroundColor: kGreyColor,
                  onPressed: () => Navigator.pop(context),
                ),
                CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保存',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: onPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _reloadComments() async {
    ApplyModel? tmpApply = await applyService.selectData(
      id: widget.apply.id,
    );
    if (tmpApply == null) return;
    comments = tmpApply.comments;
    setState(() {});
  }

  void _reloadApply() async {
    ApplyModel? tmpApply = await applyService.selectData(
      id: widget.apply.id,
    );
    if (tmpApply == null) return;
    apply = tmpApply;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    if (widget.apply.comments.isNotEmpty) {
      List<Map> comments = [];
      for (final comment in widget.apply.comments) {
        List<String> commentReadUserIds = comment.readUserIds;
        if (!commentReadUserIds.contains(user?.id)) {
          commentReadUserIds.add(user?.id ?? '');
        }
        comment.readUserIds = commentReadUserIds;
        comments.add(comment.toMap());
      }
      applyService.update({
        'id': widget.apply.id,
        'comments': comments,
      });
    }
  }

  @override
  void initState() {
    _read();
    _reloadApply();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    bool isDelete = true;
    if (apply!.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
      if (widget.loginProvider.user?.president == true) {
        isApproval = true;
        isReject = true;
      }
    } else {
      isDelete = false;
    }
    if (apply!.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in apply!.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (apply!.approval == 1 || apply!.approval == 9) {
      isApproval = false;
      isReject = false;
      isDelete = false;
    }
    List<ApprovalUserModel> approvalUsers = apply!.approvalUsers;
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
          '申請情報',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: 'PDF出力',
            labelColor: kWhiteColor,
            backgroundColor: kPdfColor,
            onPressed: () async => await PdfService().applyDownload(
              widget.apply,
            ),
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '否決する',
            labelColor: kWhiteColor,
            backgroundColor: kRejectColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => RejectApplyDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                apply: apply!,
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
              builder: (context) => ApprovalApplyDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                apply: apply!,
              ),
            ),
            disabled: !isApproval,
          ),
          const SizedBox(width: 4),
          apply!.pending == true
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留を解除する',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingCancelApplyDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      apply: apply!,
                    ),
                  ),
                  disabled: apply!.approval != 0,
                )
              : CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留中にする',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingApplyDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      apply: apply!,
                    ),
                  ),
                  disabled: apply!.approval != 0,
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
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', apply!.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '申請番号: ${apply!.number}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '申請者: ${apply!.createdUserName}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  apply!.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', apply!.approvedAt)}',
                          style: const TextStyle(color: kRedColor),
                        )
                      : Container(),
                  apply!.approval == 1
                      ? Text(
                          '承認番号: ${apply!.approvalNumber}',
                          style: const TextStyle(color: kRedColor),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 8),
              reApprovalUsers.isNotEmpty
                  ? FormLabel(
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
                    )
                  : Container(),
              const SizedBox(height: 16),
              FormLabel(
                '申請種別',
                child: Chip(
                  label: Text('${apply!.type}申請'),
                  backgroundColor: apply!.typeColor(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '件名',
                child: FormValue(
                  apply!.title,
                  onTap: () {
                    final titleController = TextEditingController(
                      text: apply!.title,
                    );
                    _showTextField(
                      controller: titleController,
                      onPressed: () {
                        applyService.update({
                          'id': apply!.id,
                          'title': titleController.text,
                        });
                        _reloadApply();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              apply!.type == '稟議' || apply!.type == '支払伺い'
                  ? FormLabel(
                      '金額',
                      child: FormValue(
                        '¥ ${apply!.formatPrice()}',
                        onTap: () {
                          final priceController = TextEditingController(
                            text: apply!.price.toString(),
                          );
                          _showTextField(
                            controller: priceController,
                            onPressed: () {
                              applyService.update({
                                'id': apply!.id,
                                'price': int.parse(priceController.text),
                              });
                              _reloadApply();
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '内容',
                child: FormValue(
                  apply!.content,
                  onTap: () {
                    final contentController = TextEditingController(
                      text: apply!.content,
                    );
                    _showTextField(
                      controller: contentController,
                      textInputType: TextInputType.multiline,
                      onPressed: () {
                        applyService.update({
                          'id': apply!.id,
                          'content': contentController.text,
                        });
                        _reloadApply();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              apply!.approvalReason != ''
                  ? FormLabel(
                      '承認理由',
                      child: FormValue(apply!.approvalReason),
                    )
                  : Container(),
              const SizedBox(height: 8),
              apply!.reason != ''
                  ? FormLabel(
                      '否決理由',
                      child: FormValue(apply!.reason),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル',
                child: apply!.file != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(apply!.file);
                          downloadFile(
                            url: apply!.file,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル2',
                child: apply!.file2 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(apply!.file2);
                          downloadFile(
                            url: apply!.file2,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル3',
                child: apply!.file3 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(apply!.file3);
                          downloadFile(
                            url: apply!.file3,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル4',
                child: apply!.file4 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(apply!.file4);
                          downloadFile(
                            url: apply!.file4,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル5',
                child: apply!.file5 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(apply!.file5);
                          downloadFile(
                            url: apply!.file5,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
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
              const SizedBox(height: 8),
              Container(
                color: kGreyColor.withOpacity(0.2),
                padding: const EdgeInsets.all(16),
                child: FormLabel(
                  '社内コメント',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      comments.isNotEmpty
                          ? Column(
                              children: comments.map((comment) {
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
                        onPressed: () {
                          TextEditingController commentContentController =
                              TextEditingController();
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              content: SizedBox(
                                width: 600,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: commentContentController,
                                      textInputType: TextInputType.multiline,
                                      maxLines: null,
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
                                  label: '追記する',
                                  labelColor: kWhiteColor,
                                  backgroundColor: kBlueColor,
                                  onPressed: () async {
                                    String? error =
                                        await applyProvider.addComment(
                                      organization:
                                          widget.loginProvider.organization,
                                      apply: apply!,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
${widget.apply.type}申請の「${widget.apply.title}」に、社内コメントを追記しました。
コメント内容:
${commentContentController.text}
                                    ''';
                                    error = await messageProvider.sendComment(
                                      organization:
                                          widget.loginProvider.organization,
                                      content: content,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    if (error != null) {
                                      if (!mounted) return;
                                      showMessage(context, error, false);
                                      return;
                                    }
                                    _reloadComments();
                                    if (!mounted) return;
                                    showMessage(
                                        context, '社内コメントが追記されました', true);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
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

class PendingApplyDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const PendingApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に保留中にしますか？'),
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
          label: '保留中にする',
          labelColor: kBlackColor,
          backgroundColor: kYellowColor,
          onPressed: () async {
            String? error = await applyProvider.pending(
              apply: apply,
            );
            if (error != null) {
              showMessage(context, error, false);
              return;
            }
            showMessage(context, '申請を保留中にしました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PendingCancelApplyDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const PendingCancelApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に保留を解除しますか？'),
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
          label: '保留を解除する',
          labelColor: kBlackColor,
          backgroundColor: kYellowColor,
          onPressed: () async {
            String? error = await applyProvider.pendingCancel(
              apply: apply,
            );
            if (error != null) {
              showMessage(context, error, false);
              return;
            }
            showMessage(context, '保留を解除しました', true);
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
      content: SizedBox(
        width: 600,
        child: Column(
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
            showMessage(context, '申請が承認されました', true);
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
      content: SizedBox(
        width: 600,
        child: Column(
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
            showMessage(context, '申請が否決されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
