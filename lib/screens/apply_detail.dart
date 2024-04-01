import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/providers/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_add.dart';
import 'package:miel_work_web/widgets/custom_approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
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
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FluentIcons.chevron_left),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.apply.type}申請詳細',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  isReject && widget.loginProvider.user?.admin == true
                      ? CustomButtonSm(
                          icon: FluentIcons.status_error_full,
                          labelText: '否決する',
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
                      ? CustomButtonSm(
                          icon: FluentIcons.completed_solid,
                          labelText: '承認する',
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
                      ? CustomButtonSm(
                          icon: FluentIcons.add,
                          labelText: '再申請する',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () => Navigator.push(
                            context,
                            FluentPageRoute(
                              builder: (context) => ApplyAddScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                apply: widget.apply,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
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
                      widget.apply.approval == 1
                          ? Text(
                              '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.approvedAt)}',
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
                  ? InfoLabel(
                      label: '承認者一覧',
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
              InfoLabel(
                label: '件名',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.apply.title),
                ),
              ),
              const SizedBox(height: 8),
              widget.apply.type == '稟議'
                  ? InfoLabel(
                      label: '金額',
                      child: Container(
                        color: kGrey200Color,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text('¥ ${widget.apply.formatPrice()}'),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              InfoLabel(
                label: '内容',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.apply.content),
                ),
              ),
              const SizedBox(height: 8),
              widget.apply.reason != ''
                  ? InfoLabel(
                      label: '否決理由',
                      child: Container(
                        color: kGrey200Color,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text(widget.apply.reason),
                      ),
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
    return ContentDialog(
      title: const Text(
        'この申請を削除する',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('本当に削除しますか？'),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '削除する',
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
  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return ContentDialog(
      title: const Text(
        'この申請を承認する',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('本当に承認しますか？'),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await applyProvider.approval(
              apply: widget.apply,
              loginUser: widget.loginProvider.user,
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
    return ContentDialog(
      title: const Text(
        'この申請を否決する',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('本当に否決しますか？'),
            const SizedBox(height: 8),
            InfoLabel(
              label: '否決理由',
              child: CustomTextBox(
                controller: reasonController,
                placeholder: '',
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '否決する',
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
