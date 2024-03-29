import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_project.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/providers/apply_project.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_project_add.dart';
import 'package:miel_work_web/widgets/custom_approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class ApplyProjectDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProjectModel project;

  const ApplyProjectDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.project,
    super.key,
  });

  @override
  State<ApplyProjectDetailScreen> createState() =>
      _ApplyProjectDetailScreenState();
}

class _ApplyProjectDetailScreenState extends State<ApplyProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    bool isApply = false;
    bool isDelete = true;
    if (widget.project.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
      if (widget.project.approval == 9) {
        isApply = true;
      }
    } else {
      isDelete = false;
    }
    if (widget.project.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.project.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.project.approval == 1 || widget.project.approval == 9) {
      isApproval = false;
      isReject = false;
      isDelete = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.project.approvalUsers;
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
                  const Text(
                    '企画申請詳細',
                    style: TextStyle(fontSize: 16),
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
                            builder: (context) => RejectApplyProjectDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              project: widget.project,
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
                            builder: (context) => ApprovalApplyProjectDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              project: widget.project,
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
                              builder: (context) => ApplyProjectAddScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                project: widget.project,
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
                          label: 'この企画申請を削除する',
                          color: kRedColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => DelApplyProjectDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              project: widget.project,
                            ),
                          ),
                        )
                      : Container(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '提出日時: ${dateText('yyyy/MM/dd HH:mm', widget.project.createdAt)}',
                        style: const TextStyle(color: kGreyColor),
                      ),
                      widget.project.approval == 1
                          ? Text(
                              '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.project.approvedAt)}',
                              style: const TextStyle(color: kGreyColor),
                            )
                          : Container(),
                      Text(
                        '作成者: ${widget.project.createdUserName}',
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
                  child: Text(widget.project.title),
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '内容',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.project.content),
                ),
              ),
              const SizedBox(height: 8),
              widget.project.reason != ''
                  ? InfoLabel(
                      label: '否決理由',
                      child: Container(
                        color: kGrey200Color,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text(widget.project.reason),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.project.file != ''
                  ? LinkText(
                      label: '添付ファイル',
                      color: kBlueColor,
                      onTap: () {
                        File file = File(widget.project.file);
                        downloadFile(
                          url: widget.project.file,
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

class DelApplyProjectDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProjectModel project;

  const DelApplyProjectDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.project,
    super.key,
  });

  @override
  State<DelApplyProjectDialog> createState() => _DelApplyProjectDialogState();
}

class _DelApplyProjectDialogState extends State<DelApplyProjectDialog> {
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ApplyProjectProvider>(context);
    return ContentDialog(
      title: const Text(
        'この企画申請を削除する',
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
            String? error = await projectProvider.delete(
              project: widget.project,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '企画申請を削除しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ApprovalApplyProjectDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProjectModel project;

  const ApprovalApplyProjectDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.project,
    super.key,
  });

  @override
  State<ApprovalApplyProjectDialog> createState() =>
      _ApprovalApplyProjectDialogState();
}

class _ApprovalApplyProjectDialogState
    extends State<ApprovalApplyProjectDialog> {
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ApplyProjectProvider>(context);
    return ContentDialog(
      title: const Text(
        'この企画申請を承認する',
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
            String? error = await projectProvider.approval(
              project: widget.project,
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

class RejectApplyProjectDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProjectModel project;

  const RejectApplyProjectDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.project,
    super.key,
  });

  @override
  State<RejectApplyProjectDialog> createState() =>
      _RejectApplyProjectDialogState();
}

class _RejectApplyProjectDialogState extends State<RejectApplyProjectDialog> {
  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ApplyProjectProvider>(context);
    return ContentDialog(
      title: const Text(
        'この企画申請を否決する',
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
            String? error = await projectProvider.reject(
              project: widget.project,
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
