import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/request_const.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_const.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/services/request_const.dart';
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

class RequestConstDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const RequestConstDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<RequestConstDetailScreen> createState() =>
      _RequestConstDetailScreenState();
}

class _RequestConstDetailScreenState extends State<RequestConstDetailScreen> {
  RequestConstService constService = RequestConstService();
  List<CommentModel> comments = [];

  void _reloadComments() async {
    RequestConstModel? tmpRequestConst = await constService.selectData(
      id: widget.requestConst.id,
    );
    if (tmpRequestConst == null) return;
    comments = tmpRequestConst.comments;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    if (widget.requestConst.comments.isNotEmpty) {
      List<Map> comments = [];
      for (final comment in widget.requestConst.comments) {
        List<String> commentReadUserIds = comment.readUserIds;
        if (!commentReadUserIds.contains(user?.id)) {
          commentReadUserIds.add(user?.id ?? '');
        }
        comment.readUserIds = commentReadUserIds;
        comments.add(comment.toMap());
      }
      constService.update({
        'id': widget.requestConst.id,
        'comments': comments,
      });
    }
  }

  void _init() async {
    _read();
    comments = widget.requestConst.comments;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    if (widget.requestConst.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.requestConst.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.requestConst.approval == 1 ||
        widget.requestConst.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.requestConst.approvalUsers;
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
          '店舗工事作業申請：申請情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: 'PDF出力',
            labelColor: kWhiteColor,
            backgroundColor: kPdfColor,
            onPressed: () async => await PdfService().requestConstDownload(
              widget.requestConst,
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
              builder: (context) => RejectRequestConstDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                requestConst: widget.requestConst,
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
              builder: (context) => ApprovalRequestConstDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                requestConst: widget.requestConst,
              ),
            ),
            disabled: !isApproval,
          ),
          const SizedBox(width: 4),
          widget.requestConst.pending == true
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留を解除する',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingCancelRequestConstDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      requestConst: widget.requestConst,
                    ),
                  ),
                  disabled: widget.requestConst.approval != 0,
                )
              : CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留中にする',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingRequestConstDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      requestConst: widget.requestConst,
                    ),
                  ),
                  disabled: widget.requestConst.approval != 0,
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
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', widget.requestConst.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  widget.requestConst.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.requestConst.approvedAt)}',
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
                  widget.requestConst.companyName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者名',
                child: FormValue(
                  widget.requestConst.companyUserName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者メールアドレス',
                child: FormValue(
                  widget.requestConst.companyUserEmail,
                  onTap: () {},
                ),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.requestConst.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者電話番号',
                child: FormValue(
                  widget.requestConst.companyUserTel,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '工事施工情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工会社名',
                child: FormValue(
                  widget.requestConst.constName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工代表者名',
                child: FormValue(
                  widget.requestConst.constUserName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工代表者電話番号',
                child: FormValue(
                  widget.requestConst.constUserTel,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '当日担当者名',
                child: FormValue(
                  widget.requestConst.chargeUserName,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '当日担当者電話番号',
                child: FormValue(
                  widget.requestConst.chargeUserTel,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '施工予定日時',
                child: FormValue(
                  widget.requestConst.constAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', widget.requestConst.constStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.requestConst.constEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '施工内容',
                child: FormValue(
                  widget.requestConst.constContent,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '騒音',
                child: FormValue(widget.requestConst.noise ? '有' : '無'),
              ),
              widget.requestConst.noise
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '騒音対策',
                        child: FormValue(widget.requestConst.noiseMeasures),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '粉塵',
                child: FormValue(widget.requestConst.dust ? '有' : '無'),
              ),
              widget.requestConst.dust
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '粉塵対策',
                        child: FormValue(widget.requestConst.dustMeasures),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '火気の使用',
                child: FormValue(widget.requestConst.fire ? '有' : '無'),
              ),
              widget.requestConst.fire
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '火気対策',
                        child: FormValue(widget.requestConst.fireMeasures),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.requestConst.attachedFiles.map((file) {
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
                                        await constProvider.addComment(
                                      requestConst: widget.requestConst,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
店舗工事作業申請「${widget.requestConst.companyName}」に、社内コメントを追記しました。
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

class ModConstAtDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const ModConstAtDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<ModConstAtDialog> createState() => _ModConstAtDialogState();
}

class _ModConstAtDialogState extends State<ModConstAtDialog> {
  RequestConstService constService = RequestConstService();
  DateTime constStartedAt = DateTime.now();
  DateTime constEndedAt = DateTime.now();

  @override
  void initState() {
    constStartedAt = widget.requestConst.constStartedAt;
    constEndedAt = widget.requestConst.constEndedAt;
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
              '施工予定日時',
              child: DatetimeRangeForm(
                startedAt: constStartedAt,
                startedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.datetime,
                  init: constStartedAt,
                  title: '施工予定開始日時を選択',
                  onChanged: (value) {
                    setState(() {
                      constStartedAt = value;
                    });
                  },
                ),
                endedAt: constEndedAt,
                endedOnTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  pickerType: DateTimePickerType.datetime,
                  init: constEndedAt,
                  title: '施工予定終了日時を選択',
                  onChanged: (value) {
                    setState(() {
                      constEndedAt = value;
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
            constService.update({
              'id': widget.requestConst.id,
              'constStartedAt': constStartedAt,
              'constEndedAt': constEndedAt,
              'constAtPending': false,
            });
            if (!mounted) return;
            showMessage(context, '施工予定日時が変更されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PendingRequestConstDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const PendingRequestConstDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
            String? error = await constProvider.pending(
              requestConst: requestConst,
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

class PendingCancelRequestConstDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const PendingCancelRequestConstDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
            String? error = await constProvider.pendingCancel(
              requestConst: requestConst,
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

class ApprovalRequestConstDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const ApprovalRequestConstDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<ApprovalRequestConstDialog> createState() =>
      _ApprovalRequestConstDialogState();
}

class _ApprovalRequestConstDialogState
    extends State<ApprovalRequestConstDialog> {
  bool meeting = false;
  DateTime meetingAt = DateTime.now();
  TextEditingController cautionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
              '着工前の打ち合わせ',
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: kGreyColor),
                    bottom: BorderSide(color: kGreyColor),
                  ),
                ),
                child: CheckboxListTile(
                  value: meeting,
                  onChanged: (value) {
                    setState(() {
                      meeting = value ?? false;
                    });
                  },
                  title: const Text('必要'),
                ),
              ),
            ),
            meeting
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: FormLabel(
                      '打ち合わせ日時',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', meetingAt),
                        onTap: () async => await CustomDateTimePicker().picker(
                          context: context,
                          pickerType: DateTimePickerType.datetime,
                          init: meetingAt,
                          title: '打ち合わせ日時を選択',
                          onChanged: (value) {
                            setState(() {
                              meetingAt = value;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 8),
            FormLabel(
              '注意事項',
              child: CustomTextField(
                controller: cautionController,
                textInputType: TextInputType.multiline,
                maxLines: 3,
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
            String? error = await constProvider.approval(
              requestConst: widget.requestConst,
              meeting: meeting,
              meetingAt: meetingAt,
              caution: cautionController.text,
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

class RejectRequestConstDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const RejectRequestConstDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<RejectRequestConstDialog> createState() =>
      _RejectRequestConstDialogState();
}

class _RejectRequestConstDialogState extends State<RejectRequestConstDialog> {
  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
            String? error = await constProvider.reject(
              requestConst: widget.requestConst,
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
