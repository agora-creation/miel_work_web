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
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class ApplyModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const ApplyModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<ApplyModScreen> createState() => _ApplyModScreenState();
}

class _ApplyModScreenState extends State<ApplyModScreen> {
  TextEditingController numberController = TextEditingController();
  String type = kApplyTypes.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController priceController = TextEditingController(text: '0');
  TextEditingController memoController = TextEditingController();

  void _init() async {
    numberController.text = widget.apply.number;
    type = widget.apply.type;
    titleController.text = widget.apply.title;
    contentController.text = widget.apply.content;
    priceController.text = widget.apply.price.toString();
    memoController.text = widget.apply.memo;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    bool isDelete = true;
    if (widget.apply.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
      if (widget.loginProvider.user?.president == true) {
        isApproval = true;
        isReject = true;
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
          '申請情報を編集',
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
              builder: (context) => RejectApplyDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                apply: widget.apply,
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
                apply: widget.apply,
              ),
            ),
            disabled: !isApproval,
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '削除する',
            labelColor: kWhiteColor,
            backgroundColor: kRedColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelApplyDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                apply: widget.apply,
              ),
            ),
            disabled: !isDelete,
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              int price = 0;
              if (type == '稟議' || type == '支払伺い') {
                price = int.parse(priceController.text);
              }
              String? error = await applyProvider.update(
                apply: widget.apply,
                number: numberController.text,
                type: type,
                title: titleController.text,
                content: contentController.text,
                price: price,
                memo: memoController.text,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '申請情報が変更されました', true);
              Navigator.pop(context);
            },
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
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '申請番号: ${widget.apply.number}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '申請者: ${widget.apply.createdUserName}',
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
                '申請番号',
                child: CustomTextField(
                  controller: numberController,
                  textInputType: TextInputType.number,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申請種別',
                child: Column(
                  children: kApplyTypes.map((e) {
                    return RadioListTile(
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          label: Text(e),
                          backgroundColor: generateApplyColor(e),
                        ),
                      ),
                      value: e,
                      groupValue: type,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          type = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '件名',
                child: CustomTextField(
                  controller: titleController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              type == '稟議' || type == '支払伺い'
                  ? FormLabel(
                      '金額',
                      child: CustomTextField(
                        controller: priceController,
                        textInputType: TextInputType.number,
                        maxLines: 1,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '内容',
                child: CustomTextField(
                  controller: contentController,
                  textInputType: TextInputType.multiline,
                  maxLines: 30,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル',
                child: widget.apply.file != ''
                    ? LinkText(
                        label: '確認する',
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
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル2',
                child: widget.apply.file2 != ''
                    ? LinkText(
                        label: '確認する',
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
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル3',
                child: widget.apply.file3 != ''
                    ? LinkText(
                        label: '確認する',
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
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル4',
                child: widget.apply.file4 != ''
                    ? LinkText(
                        label: '確認する',
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
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル5',
                child: widget.apply.file5 != ''
                    ? LinkText(
                        label: '確認する',
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
              ),
              const SizedBox(height: 8),
              FormLabel(
                'メモ',
                child: CustomTextField(
                  controller: memoController,
                  textInputType: TextInputType.multiline,
                  maxLines: 10,
                ),
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
              const SizedBox(height: 80),
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
            String? error = await applyProvider.delete(
              apply: widget.apply,
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
