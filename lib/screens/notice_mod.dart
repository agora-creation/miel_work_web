import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_file_field.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class NoticeModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel notice;
  final OrganizationGroupModel? noticeInGroup;

  const NoticeModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.notice,
    required this.noticeInGroup,
    super.key,
  });

  @override
  State<NoticeModScreen> createState() => _NoticeModScreenState();
}

class _NoticeModScreenState extends State<NoticeModScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  OrganizationGroupModel? selectedGroup;
  PlatformFile? pickedFile;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.notice.title;
    contentController.text = widget.notice.content;
    selectedGroup = widget.noticeInGroup;
  }

  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.chevron_left),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'お知らせを編集',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '入力内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await noticeProvider.update(
                    organization: widget.loginProvider.organization,
                    notice: widget.notice,
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
                  showMessage(context, 'お知らせを編集しました', true);
                  Navigator.pop(context);
                },
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
              InfoLabel(
                label: 'タイトル',
                child: CustomTextBox(
                  controller: titleController,
                  placeholder: '例) 休館日について',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: 'お知らせ内容',
                child: CustomTextBox(
                  controller: contentController,
                  placeholder: '',
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '送信先グループ',
                child: widget.loginProvider.isAllGroup()
                    ? ComboBox<OrganizationGroupModel>(
                        isExpanded: true,
                        value: selectedGroup,
                        items: groupItems,
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value;
                          });
                        },
                        placeholder: const Text(
                          'グループの指定なし',
                          style: TextStyle(color: kGreyColor),
                        ),
                      )
                    : Container(
                        color: kGrey200Color,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text('${selectedGroup?.name}'),
                      ),
              ),
              const SizedBox(height: 8),
              CustomFileField(
                value: pickedFile,
                defaultValue: widget.notice.file,
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );
                  if (result == null) return;
                  setState(() {
                    pickedFile = result.files.first;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
