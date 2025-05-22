import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/request_cycle.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_cycle.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/services/request_cycle.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
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
  RequestCycleService cycleService = RequestCycleService();
  RequestCycleModel? cycle;
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
    RequestCycleModel? tmpCycle = await cycleService.selectData(
      id: widget.cycle.id,
    );
    if (tmpCycle == null) return;
    comments = tmpCycle.comments;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    bool commentNotRead = true;
    List<Map> comments = [];
    if (widget.cycle.comments.isNotEmpty) {
      for (final comment in widget.cycle.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
        List<String> commentReadUserIds = comment.readUserIds;
        if (!commentReadUserIds.contains(user?.id)) {
          commentReadUserIds.add(user?.id ?? '');
        }
        comment.readUserIds = commentReadUserIds;
        comments.add(comment.toMap());
      }
    }
    if (commentNotRead) {
      cycleService.update({
        'id': widget.cycle.id,
        'comments': comments,
      });
    }
  }

  void _reloadRequestCycle() async {
    RequestCycleModel? tmpCycle = await cycleService.selectData(
      id: widget.cycle.id,
    );
    if (tmpCycle == null) return;
    cycle = tmpCycle;
    setState(() {});
  }

  @override
  void initState() {
    _read();
    _reloadRequestCycle();
    _reloadComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    if (cycle!.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in cycle!.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (cycle!.approval == 1 || cycle!.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = cycle!.approvalUsers;
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
          '自転車置き場使用申込：申請情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: 'PDF出力',
            labelColor: kWhiteColor,
            backgroundColor: kPdfColor,
            onPressed: () async => await PdfService().requestCycleDownload(
              cycle!,
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
              builder: (context) => RejectRequestCycleDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                cycle: cycle!,
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
              builder: (context) => ApprovalRequestCycleDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                cycle: cycle!,
              ),
            ),
            disabled: !isApproval,
          ),
          const SizedBox(width: 4),
          cycle!.pending == true
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留を解除する',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingCancelRequestCycleDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      cycle: cycle!,
                    ),
                  ),
                  disabled: cycle!.approval != 0,
                )
              : CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留中にする',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingRequestCycleDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      cycle: cycle!,
                    ),
                  ),
                  disabled: cycle!.approval != 0,
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
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', cycle!.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  cycle!.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', cycle!.approvedAt)}',
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
                '店舗名',
                child: FormValue(
                  cycle!.companyName,
                  onTap: () {
                    final companyNameController = TextEditingController(
                      text: cycle!.companyName,
                    );
                    _showTextField(
                      controller: companyNameController,
                      onPressed: () {
                        cycleService.update({
                          'id': cycle!.id,
                          'companyName': companyNameController.text,
                        });
                        _reloadRequestCycle();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: FormValue(
                  cycle!.companyUserName,
                  onTap: () {
                    final companyUserNameController = TextEditingController(
                      text: cycle!.companyUserName,
                    );
                    _showTextField(
                      controller: companyUserNameController,
                      onPressed: () {
                        cycleService.update({
                          'id': cycle!.id,
                          'companyUserName': companyUserNameController.text,
                        });
                        _reloadRequestCycle();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者メールアドレス',
                child: FormValue(
                  cycle!.companyUserEmail,
                  onTap: () {
                    final companyUserEmailController = TextEditingController(
                      text: cycle!.companyUserEmail,
                    );
                    _showTextField(
                      controller: companyUserEmailController,
                      onPressed: () {
                        cycleService.update({
                          'id': cycle!.id,
                          'companyUserEmail': companyUserEmailController.text,
                        });
                        _reloadRequestCycle();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${cycle!.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者電話番号',
                child: FormValue(
                  cycle!.companyUserTel,
                  onTap: () {
                    final companyUserTelController = TextEditingController(
                      text: cycle!.companyUserTel,
                    );
                    _showTextField(
                      controller: companyUserTelController,
                      onPressed: () {
                        cycleService.update({
                          'id': cycle!.id,
                          'companyUserTel': companyUserTelController.text,
                        });
                        _reloadRequestCycle();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '住所',
                child: FormValue(
                  cycle!.companyAddress,
                  onTap: () {
                    final companyAddressController = TextEditingController(
                      text: cycle!.companyAddress,
                    );
                    _showTextField(
                      controller: companyAddressController,
                      onPressed: () {
                        cycleService.update({
                          'id': cycle!.id,
                          'companyAddress': companyAddressController.text,
                        });
                        _reloadRequestCycle();
                        Navigator.pop(context);
                      },
                    );
                  },
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
                                        await cycleProvider.addComment(
                                      cycle: cycle!,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
自転車置き場使用申込「${cycle!.companyName}」に、社内コメントを追記しました。
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

class PendingRequestCycleDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const PendingRequestCycleDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

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
            String? error = await cycleProvider.pending(
              cycle: cycle,
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

class PendingCancelRequestCycleDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const PendingCancelRequestCycleDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

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
            String? error = await cycleProvider.pendingCancel(
              cycle: cycle,
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
  TextEditingController lockNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
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
              '施錠番号',
              child: CustomTextField(
                controller: lockNumberController,
                textInputType: TextInputType.number,
                maxLines: 1,
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
            String? error = await cycleProvider.approval(
              cycle: widget.cycle,
              lockNumber: lockNumberController.text,
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
