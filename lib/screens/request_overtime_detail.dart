import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_overtime.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/services/request_overtime.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/attached_file_list.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
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
  RequestOvertimeService overtimeService = RequestOvertimeService();
  RequestOvertimeModel? overtime;
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
    RequestOvertimeModel? tmpOvertime = await overtimeService.selectData(
      id: widget.overtime.id,
    );
    if (tmpOvertime == null) return;
    comments = tmpOvertime.comments;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    bool commentNotRead = true;
    List<Map> comments = [];
    if (widget.overtime.comments.isNotEmpty) {
      for (final comment in widget.overtime.comments) {
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
      overtimeService.update({
        'id': widget.overtime.id,
        'comments': comments,
      });
    }
  }

  void _reloadRequestOvertime() async {
    RequestOvertimeModel? tmpOvertime = await overtimeService.selectData(
      id: widget.overtime.id,
    );
    if (tmpOvertime == null) return;
    overtime = tmpOvertime;
    setState(() {});
  }

  @override
  void initState() {
    _read();
    _reloadRequestOvertime();
    _reloadComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final overtimeProvider = Provider.of<RequestOvertimeProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    if (overtime!.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in overtime!.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (overtime!.approval == 1 || overtime!.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = overtime!.approvalUsers;
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
            label: 'PDF出力',
            labelColor: kWhiteColor,
            backgroundColor: kPdfColor,
            onPressed: () async => await PdfService().requestOvertimeDownload(
              overtime!,
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
              builder: (context) => RejectRequestOvertimeDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                overtime: overtime!,
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
                overtime: overtime!,
              ),
            ),
            disabled: !isApproval,
          ),
          const SizedBox(width: 4),
          overtime!.pending == true
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留を解除する',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingCancelRequestOvertimeDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      overtime: overtime!,
                    ),
                  ),
                  disabled: overtime!.approval != 0,
                )
              : CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留中にする',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingRequestOvertimeDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      overtime: overtime!,
                    ),
                  ),
                  disabled: overtime!.approval != 0,
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
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', overtime!.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  overtime!.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', overtime!.approvedAt)}',
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
                child: FormValue(
                  overtime!.companyName,
                  onTap: () {
                    final companyNameController = TextEditingController(
                      text: overtime!.companyName,
                    );
                    _showTextField(
                      controller: companyNameController,
                      onPressed: () {
                        overtimeService.update({
                          'id': overtime!.id,
                          'companyName': companyNameController.text,
                        });
                        _reloadRequestOvertime();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者名',
                child: FormValue(
                  overtime!.companyUserName,
                  onTap: () {
                    final companyUserNameController = TextEditingController(
                      text: overtime!.companyUserName,
                    );
                    _showTextField(
                      controller: companyUserNameController,
                      onPressed: () {
                        overtimeService.update({
                          'id': overtime!.id,
                          'companyUserName': companyUserNameController.text,
                        });
                        _reloadRequestOvertime();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者メールアドレス',
                child: FormValue(
                  overtime!.companyUserEmail,
                  onTap: () {
                    final companyUserEmailController = TextEditingController(
                      text: overtime!.companyUserEmail,
                    );
                    _showTextField(
                      controller: companyUserEmailController,
                      onPressed: () {
                        overtimeService.update({
                          'id': overtime!.id,
                          'companyUserEmail': companyUserEmailController.text,
                        });
                        _reloadRequestOvertime();
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
                    'mailto:${overtime!.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者電話番号',
                child: FormValue(
                  overtime!.companyUserTel,
                  onTap: () {
                    final companyUserTelController = TextEditingController(
                      text: overtime!.companyUserTel,
                    );
                    _showTextField(
                      controller: companyUserTelController,
                      onPressed: () {
                        overtimeService.update({
                          'id': overtime!.id,
                          'companyUserTel': companyUserTelController.text,
                        });
                        _reloadRequestOvertime();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
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
                  overtime!.useAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', overtime!.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', overtime!.useEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '作業内容',
                child: FormValue(
                  overtime!.useContent,
                  onTap: () {
                    final useContentController = TextEditingController(
                      text: overtime!.useContent,
                    );
                    _showTextField(
                      controller: useContentController,
                      onPressed: () {
                        overtimeService.update({
                          'id': overtime!.id,
                          'useContent': useContentController.text,
                        });
                        _reloadRequestOvertime();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
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
                      children: overtime!.attachedFiles.map((file) {
                        return AttachedFileList(
                          fileName: getFileNameFromUrl(file),
                          onTap: () {
                            downloadFile(
                              url: file,
                              name: getFileNameFromUrl(file),
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
                                        await overtimeProvider.addComment(
                                      overtime: overtime!,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
夜間居残り作業申請「${overtime!.companyName}」に、社内コメントを追記しました。
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
                  pickerType: DateTimePickerType.datetime,
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
                  pickerType: DateTimePickerType.datetime,
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

class PendingRequestOvertimeDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const PendingRequestOvertimeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

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
            String? error = await overtimeProvider.pending(
              overtime: overtime,
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

class PendingCancelRequestOvertimeDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const PendingCancelRequestOvertimeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

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
            String? error = await overtimeProvider.pendingCancel(
              overtime: overtime,
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
