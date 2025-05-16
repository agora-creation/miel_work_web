import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/request_square.dart';
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
  List<CommentModel> comments = [];

  void _reloadComments() async {
    RequestSquareModel? tmpSquare = await squareService.selectData(
      id: widget.square.id,
    );
    if (tmpSquare == null) return;
    comments = tmpSquare.comments;
    setState(() {});
  }

  void _init() async {
    comments = widget.square.comments;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
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
            label: 'PDF出力',
            labelColor: kWhiteColor,
            backgroundColor: kPdfColor,
            onPressed: () async => await PdfService().requestSquareDownload(
              widget.square,
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
                square: widget.square,
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
                  widget.square.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.square.approvedAt)}',
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
                  widget.square.companyName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: FormValue(
                  widget.square.companyUserName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: FormValue(
                  widget.square.companyUserEmail,
                  onTap: () {},
                ),
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
                child: FormValue(
                  widget.square.companyUserTel,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '住所',
                child: FormValue(
                  widget.square.companyAddress,
                  onTap: () {},
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
                  widget.square.useCompanyName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: FormValue(
                  widget.square.useCompanyUserName,
                  onTap: () {},
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
                child: widget.square.useLocationFile != ''
                    ? AttachedFileList(
                        fileName: p.basename(widget.square.useLocationFile),
                        onTap: () {
                          downloadFile(
                            url: widget.square.useLocationFile,
                            name: p.basename(widget.square.useLocationFile),
                          );
                        },
                      )
                    : const FormValue('ファイルなし'),
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
                        ? ListTile(
                            title:
                                Text('折りたたみイス：${widget.square.useChairNum}脚'),
                            subtitle: const Text('150円(税抜)／1脚・1日'),
                          )
                        : Container(),
                    widget.square.useDesk
                        ? ListTile(
                            title: Text('折りたたみ机：${widget.square.useDeskNum}台'),
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
                  widget.square.useContent,
                  onTap: () {},
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
                      children: widget.square.attachedFiles.map((file) {
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
                                      square: widget.square,
                                      content: commentContentController.text,
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
