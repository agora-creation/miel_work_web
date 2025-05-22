import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/request_square.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_square.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/services/request_square.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/attached_file_list.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:path/path.dart' as p;
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
  RequestSquareService squareService = RequestSquareService();
  RequestSquareModel? square;
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
    RequestSquareModel? tmpSquare = await squareService.selectData(
      id: widget.square.id,
    );
    if (tmpSquare == null) return;
    comments = tmpSquare.comments;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    bool commentNotRead = true;
    List<Map> comments = [];
    if (widget.square.comments.isNotEmpty) {
      for (final comment in widget.square.comments) {
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
      squareService.update({
        'id': widget.square.id,
        'comments': comments,
      });
    }
  }

  void _reloadRequestSquare() async {
    RequestSquareModel? tmpSquare = await squareService.selectData(
      id: widget.square.id,
    );
    if (tmpSquare == null) return;
    square = tmpSquare;
    setState(() {});
  }

  @override
  void initState() {
    _read();
    _reloadRequestSquare();
    _reloadComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    if (square!.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in square!.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (square!.approval == 1 || square!.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = square!.approvalUsers;
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
            label: 'PDF出力',
            labelColor: kWhiteColor,
            backgroundColor: kPdfColor,
            onPressed: () async => await PdfService().requestSquareDownload(
              square!,
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
              builder: (context) => RejectRequestSquareDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                square: square!,
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
              builder: (context) => ApprovalRequestSquareDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                square: square!,
              ),
            ),
            disabled: !isApproval,
          ),
          const SizedBox(width: 4),
          square!.pending == true
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留を解除する',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingCancelRequestSquareDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      square: square!,
                    ),
                  ),
                  disabled: square!.approval != 0,
                )
              : CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留中にする',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingRequestSquareDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      square: square!,
                    ),
                  ),
                  disabled: square!.approval != 0,
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
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', square!.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  square!.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', square!.approvedAt)}',
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
                '申込会社名(又は店名)',
                child: FormValue(
                  square!.companyName,
                  onTap: () {
                    final companyNameController = TextEditingController(
                      text: square!.companyName,
                    );
                    _showTextField(
                      controller: companyNameController,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'companyName': companyNameController.text,
                        });
                        _reloadRequestSquare();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: FormValue(
                  square!.companyUserName,
                  onTap: () {
                    final companyUserNameController = TextEditingController(
                      text: square!.companyUserName,
                    );
                    _showTextField(
                      controller: companyUserNameController,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'companyUserName': companyUserNameController.text,
                        });
                        _reloadRequestSquare();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: FormValue(
                  square!.companyUserEmail,
                  onTap: () {
                    final companyUserEmailController = TextEditingController(
                      text: square!.companyUserEmail,
                    );
                    _showTextField(
                      controller: companyUserEmailController,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'companyUserEmail': companyUserEmailController.text,
                        });
                        _reloadRequestSquare();
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
                    'mailto:${square!.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者電話番号',
                child: FormValue(
                  square!.companyUserTel,
                  onTap: () {
                    final companyUserTelController = TextEditingController(
                      text: square!.companyUserTel,
                    );
                    _showTextField(
                      controller: companyUserTelController,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'companyUserTel': companyUserTelController.text,
                        });
                        _reloadRequestSquare();
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
                  square!.companyAddress,
                  onTap: () {
                    final companyAddressController = TextEditingController(
                      text: square!.companyAddress,
                    );
                    _showTextField(
                      controller: companyAddressController,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'companyAddress': companyAddressController.text,
                        });
                        _reloadRequestSquare();
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
                child: FormValue(
                  square!.useCompanyName,
                  onTap: () {
                    final useCompanyNameController = TextEditingController(
                      text: square!.useCompanyName,
                    );
                    _showTextField(
                      controller: useCompanyNameController,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'useCompanyName': useCompanyNameController.text,
                        });
                        _reloadRequestSquare();
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
                  square!.useCompanyUserName,
                  onTap: () {
                    final useCompanyUserNameController = TextEditingController(
                      text: square!.useCompanyUserName,
                    );
                    _showTextField(
                      controller: useCompanyUserNameController,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'useCompanyUserName':
                              useCompanyUserNameController.text,
                        });
                        _reloadRequestSquare();
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
                '使用情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用場所を記したPDFファイル',
                child: square!.useLocationFile != ''
                    ? AttachedFileList(
                        fileName: p.basename(square!.useLocationFile),
                        onTap: () {
                          downloadFile(
                            url: square!.useLocationFile,
                            name: p.basename(square!.useLocationFile),
                          );
                        },
                      )
                    : const FormValue('ファイルなし'),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用予定日時',
                child: FormValue(
                  square!.useAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', square!.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', square!.useEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用区分',
                child: Column(
                  children: [
                    square!.useFull
                        ? const ListTile(
                            title: Text('全面使用'),
                          )
                        : Container(),
                    square!.useChair
                        ? ListTile(
                            title: Text('折りたたみイス：${square!.useChairNum}脚'),
                            subtitle: const Text('150円(税抜)／1脚・1日'),
                          )
                        : Container(),
                    square!.useDesk
                        ? ListTile(
                            title: Text('折りたたみ机：${square!.useDeskNum}台'),
                            subtitle: const Text('300円(税抜)／1台・1日'),
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用内容',
                child: FormValue(
                  square!.useContent,
                  onTap: () {
                    final useContentController = TextEditingController(
                      text: square!.useContent,
                    );
                    _showTextField(
                      controller: useContentController,
                      textInputType: TextInputType.multiline,
                      onPressed: () {
                        squareService.update({
                          'id': square!.id,
                          'useContent': useContentController.text,
                        });
                        _reloadRequestSquare();
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
                      children: square!.attachedFiles.map((file) {
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
                                        await squareProvider.addComment(
                                      square: square!,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
よさこい広場使用申込「${square!.companyName}」に、社内コメントを追記しました。
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

class PendingRequestSquareDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const PendingRequestSquareDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

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
            String? error = await squareProvider.pending(
              square: square,
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

class PendingCancelRequestSquareDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const PendingCancelRequestSquareDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

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
            String? error = await squareProvider.pendingCancel(
              square: square,
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
