import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/lost.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/lost.dart';
import 'package:miel_work_web/services/lost.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class LostModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LostModel lost;

  const LostModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.lost,
    super.key,
  });

  @override
  State<LostModScreen> createState() => _LostModScreenState();
}

class _LostModScreenState extends State<LostModScreen> {
  LostService lostService = LostService();
  DateTime discoveryAt = DateTime.now();
  TextEditingController discoveryPlaceController = TextEditingController();
  TextEditingController discoveryUserController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  FilePickerResult? itemImageResult;
  TextEditingController remarksController = TextEditingController();
  DateTime returnAt = DateTime.now();
  TextEditingController returnUserController = TextEditingController();
  SignatureController signImageController = SignatureController(
    penStrokeWidth: 2,
    exportBackgroundColor: kWhiteColor,
  );
  List<CommentModel> comments = [];

  void _reloadComments() async {
    LostModel? tmpLost = await lostService.selectData(
      id: widget.lost.id,
    );
    if (tmpLost == null) return;
    comments = tmpLost.comments;
    setState(() {});
  }

  @override
  void initState() {
    discoveryAt = widget.lost.discoveryAt;
    discoveryPlaceController.text = widget.lost.discoveryPlace;
    discoveryUserController.text = widget.lost.discoveryUser;
    itemNameController.text = widget.lost.itemName;
    remarksController.text = widget.lost.remarks;
    comments = widget.lost.comments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lostProvider = Provider.of<LostProvider>(context);
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
          '落とし物情報を編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '破棄済する',
            labelColor: kWhiteColor,
            backgroundColor: kRejectColor,
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '削除する',
            labelColor: kWhiteColor,
            backgroundColor: kRedColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelLostDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                lost: widget.lost,
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
              String? error = await lostProvider.update(
                organization: widget.loginProvider.organization,
                lost: widget.lost,
                discoveryAt: discoveryAt,
                discoveryPlace: discoveryPlaceController.text,
                discoveryUser: discoveryUserController.text,
                itemName: itemNameController.text,
                itemImageResult: itemImageResult,
                remarks: remarksController.text,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '落とし物情報が変更されました', true);
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
                      '発見日',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', discoveryAt),
                        onTap: () async => await CustomDateTimePicker().picker(
                          context: context,
                          init: discoveryAt,
                          title: '発見日を選択',
                          onChanged: (value) {
                            setState(() {
                              discoveryAt = value;
                            });
                          },
                          datetime: false,
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
                      '発見場所',
                      child: CustomTextField(
                        controller: discoveryPlaceController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      '発見者',
                      child: CustomTextField(
                        controller: discoveryUserController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
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
                      : widget.lost.itemImage != ''
                          ? Image.network(
                              widget.lost.itemImage,
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
              const SizedBox(height: 8),
              FormLabel(
                '備考',
                child: CustomTextField(
                  controller: remarksController,
                  textInputType: TextInputType.multiline,
                  maxLines: 10,
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
                    init: returnAt,
                    title: '返却日を選択',
                    onChanged: (value) {
                      setState(() {
                        returnAt = value;
                      });
                    },
                    datetime: false,
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
                  String? error = await lostProvider.updateReturn(
                    organization: widget.loginProvider.organization,
                    lost: widget.lost,
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
                                        await lostProvider.addComment(
                                      lost: widget.lost,
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

class DelLostDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LostModel lost;

  const DelLostDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.lost,
    super.key,
  });

  @override
  State<DelLostDialog> createState() => _DelLostDialogState();
}

class _DelLostDialogState extends State<DelLostDialog> {
  @override
  Widget build(BuildContext context) {
    final lostProvider = Provider.of<LostProvider>(context);
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
            String? error = await lostProvider.delete(
              lost: widget.lost,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '落とし物情報が削除されました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
