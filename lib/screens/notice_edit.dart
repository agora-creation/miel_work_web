import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/services/notice.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/file_picker_button.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:provider/provider.dart';

class NoticeEditScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel? notice;
  final OrganizationGroupModel? noticeInGroup;

  const NoticeEditScreen({
    required this.loginProvider,
    required this.homeProvider,
    this.notice,
    this.noticeInGroup,
    super.key,
  });

  @override
  State<NoticeEditScreen> createState() => _NoticeEditScreenState();
}

class _NoticeEditScreenState extends State<NoticeEditScreen> {
  NoticeService noticeService = NoticeService();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  OrganizationGroupModel? selectedGroup;
  PlatformFile? pickedFile;
  List<CommentModel> comments = [];

  void _reloadComments() async {
    if (widget.notice != null) {
      NoticeModel? tmpNotice = await noticeService.selectData(
        id: widget.notice!.id,
      );
      if (tmpNotice == null) return;
      comments = tmpNotice.comments;
    }
    setState(() {});
  }

  void _init() async {
    if (widget.notice != null) {
      UserModel? user = widget.loginProvider.user;
      List<String> readUserIds = widget.notice!.readUserIds;
      if (!readUserIds.contains(user?.id)) {
        readUserIds.add(user?.id ?? '');
        noticeService.update({
          'id': widget.notice!.id,
          'readUserIds': readUserIds,
        });
      }
      titleController.text = widget.notice!.title;
      contentController.text = widget.notice!.content;
      selectedGroup = widget.noticeInGroup;
      comments = widget.notice!.comments;
    } else {
      selectedGroup = widget.homeProvider.currentGroup;
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const DropdownMenuItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(DropdownMenuItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
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
          'お知らせ情報を編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          widget.notice != null
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '削除する',
                  labelColor: kWhiteColor,
                  backgroundColor: kRedColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DelNoticeDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      notice: widget.notice!,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(width: 4),
          widget.notice != null
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保存する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () async {
                    String? error = await noticeProvider.update(
                      organization: widget.loginProvider.organization,
                      notice: widget.notice!,
                      title: titleController.text,
                      content: contentController.text,
                      group: selectedGroup,
                      pickedFile: pickedFile,
                      loginUser: widget.loginProvider.user,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, 'お知らせが編集されました', true);
                    Navigator.pop(context);
                  },
                )
              : Container(),
          const SizedBox(width: 4),
          widget.notice == null
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '以下の内容で追加する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () async {
                    String? error = await noticeProvider.create(
                      organization: widget.loginProvider.organization,
                      title: titleController.text,
                      content: contentController.text,
                      group: selectedGroup,
                      pickedFile: pickedFile,
                      loginUser: widget.loginProvider.user,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '新しいお知らせが追加されました', true);
                    Navigator.pop(context);
                  },
                )
              : Container(),
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
              FormLabel(
                'タイトル',
                child: CustomTextField(
                  controller: titleController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'お知らせ内容',
                child: CustomTextField(
                  controller: contentController,
                  textInputType: TextInputType.multiline,
                  maxLines: 20,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '送信先グループ',
                child: DropdownButton<OrganizationGroupModel>(
                  isExpanded: true,
                  value: selectedGroup,
                  items: groupItems,
                  onChanged: (value) {
                    setState(() {
                      selectedGroup = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル',
                child: FilePickerButton(
                  value: pickedFile,
                  defaultValue: widget.notice?.file ?? '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                      withData: true,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              widget.notice != null
                  ? Container(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            controller:
                                                commentContentController,
                                            textInputType:
                                                TextInputType.multiline,
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
                                              await noticeProvider.addComment(
                                            organization: widget
                                                .loginProvider.organization,
                                            notice: widget.notice!,
                                            content:
                                                commentContentController.text,
                                            loginUser:
                                                widget.loginProvider.user,
                                          );
                                          String content = '''
お知らせの「${widget.notice?.title}」に、社内コメントを追記しました。
コメント内容:
${commentContentController.text}
                                    ''';
                                          error =
                                              await messageProvider.sendComment(
                                            organization: widget
                                                .loginProvider.organization,
                                            content: content,
                                            loginUser:
                                                widget.loginProvider.user,
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
                    )
                  : Container(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class DelNoticeDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel notice;

  const DelNoticeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.notice,
    super.key,
  });

  @override
  State<DelNoticeDialog> createState() => _DelNoticeDialogState();
}

class _DelNoticeDialogState extends State<DelNoticeDialog> {
  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
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
            String? error = await noticeProvider.delete(
              notice: widget.notice,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'お知らせが削除されました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
