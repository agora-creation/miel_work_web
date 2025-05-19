import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/loan.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/loan.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/loan.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class LoanModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LoanModel loan;

  const LoanModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.loan,
    super.key,
  });

  @override
  State<LoanModScreen> createState() => _LoanModScreenState();
}

class _LoanModScreenState extends State<LoanModScreen> {
  LoanService loanService = LoanService();
  DateTime loanAt = DateTime.now();
  TextEditingController loanUserController = TextEditingController();
  TextEditingController loanCompanyController = TextEditingController();
  TextEditingController loanStaffController = TextEditingController();
  DateTime returnPlanAt = DateTime.now();
  TextEditingController itemNameController = TextEditingController();
  FilePickerResult? itemImageResult;
  DateTime returnAt = DateTime.now();
  TextEditingController returnUserController = TextEditingController();
  SignatureController signImageController = SignatureController(
    penStrokeWidth: 2,
    exportBackgroundColor: kWhiteColor,
  );
  List<CommentModel> comments = [];

  void _reloadComments() async {
    LoanModel? tmpLoan = await loanService.selectData(
      id: widget.loan.id,
    );
    if (tmpLoan == null) return;
    comments = tmpLoan.comments;
    setState(() {});
  }

  @override
  void initState() {
    loanAt = widget.loan.loanAt;
    loanUserController.text = widget.loan.loanUser;
    loanCompanyController.text = widget.loan.loanCompany;
    loanStaffController.text = widget.loan.loanStaff;
    returnPlanAt = widget.loan.returnPlanAt;
    itemNameController.text = widget.loan.itemName;
    comments = widget.loan.comments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
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
          '貸出情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '削除する',
            labelColor: kWhiteColor,
            backgroundColor: kRedColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelLoanDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                loan: widget.loan,
              ),
            ),
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await loanProvider.update(
                organization: widget.loginProvider.organization,
                loan: widget.loan,
                loanAt: loanAt,
                loanUser: loanUserController.text,
                loanCompany: loanCompanyController.text,
                loanStaff: loanStaffController.text,
                returnPlanAt: returnPlanAt,
                itemName: itemNameController.text,
                itemImageResult: itemImageResult,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '貸出情報が変更されました', true);
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
              Row(
                children: [
                  Expanded(
                    child: FormLabel(
                      '貸出日',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', loanAt),
                        onTap: () async => await CustomDateTimePicker().picker(
                          context: context,
                          pickerType: DateTimePickerType.date,
                          init: loanAt,
                          title: '貸出日を選択',
                          onChanged: (value) {
                            setState(() {
                              loanAt = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Container()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormLabel(
                      '貸出先',
                      child: CustomTextField(
                        controller: loanUserController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      '貸出先(会社)',
                      child: CustomTextField(
                        controller: loanCompanyController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormLabel(
                      '対応スタッフ',
                      child: CustomTextField(
                        controller: loanStaffController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      '返却予定日',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', returnPlanAt),
                        onTap: () async => await CustomDateTimePicker().picker(
                          context: context,
                          pickerType: DateTimePickerType.date,
                          init: returnPlanAt,
                          title: '返却予定日を選択',
                          onChanged: (value) {
                            setState(() {
                              returnPlanAt = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FormLabel(
                '品名',
                child: CustomTextField(
                  controller: itemNameController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付写真',
                child: GestureDetector(
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );
                    setState(() {
                      itemImageResult = result;
                    });
                  },
                  child: itemImageResult != null
                      ? Image.memory(
                          itemImageResult!.files.first.bytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : widget.loan.itemImage != ''
                          ? Image.network(
                              widget.loan.itemImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Container(
                              color: kGreyColor.withOpacity(0.3),
                              width: double.infinity,
                              height: 150,
                              child: const Center(
                                child: Text('写真が選択されていません'),
                              ),
                            ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: kBorderColor),
              const SizedBox(height: 16),
              FormLabel(
                '返却日',
                child: FormValue(
                  dateText('yyyy/MM/dd HH:mm', returnAt),
                  onTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    pickerType: DateTimePickerType.date,
                    init: returnAt,
                    title: '返却日を選択',
                    onChanged: (value) {
                      setState(() {
                        returnAt = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '返却スタッフ',
                child: CustomTextField(
                  controller: returnUserController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '署名',
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kBorderColor),
                  ),
                  child: Signature(
                    controller: signImageController,
                    backgroundColor: kWhiteColor,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              CustomButton(
                type: ButtonSizeType.sm,
                label: '書き直す',
                labelColor: kBlackColor,
                backgroundColor: kGreyColor.withOpacity(0.3),
                onPressed: () => signImageController.clear(),
              ),
              const SizedBox(height: 8),
              CustomButton(
                type: ButtonSizeType.lg,
                label: '返却処理をする',
                labelColor: kWhiteColor,
                backgroundColor: kReturnColor,
                onPressed: () async {
                  String? error = await loanProvider.updateReturn(
                    organization: widget.loginProvider.organization,
                    loan: widget.loan,
                    returnAt: returnAt,
                    returnUser: returnUserController.text,
                    signImageController: signImageController,
                    loginUser: widget.loginProvider.user,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '返却されました', true);
                  Navigator.pop(context);
                },
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
                                        await loanProvider.addComment(
                                      organization:
                                          widget.loginProvider.organization,
                                      loan: widget.loan,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
貸出／返却の「${widget.loan.itemName}」に、社内コメントを追記しました。
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

class DelLoanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LoanModel loan;

  const DelLoanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.loan,
    super.key,
  });

  @override
  State<DelLoanDialog> createState() => _DelLoanDialogState();
}

class _DelLoanDialogState extends State<DelLoanDialog> {
  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
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
            String? error = await loanProvider.delete(
              loan: widget.loan,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '貸出情報が削除されました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
