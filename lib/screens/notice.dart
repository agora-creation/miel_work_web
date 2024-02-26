import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/screens/notice_source.dart';
import 'package:miel_work_web/services/notice.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NoticeScreen extends StatefulWidget {
  final HomeProvider homeProvider;
  final OrganizationModel? organization;

  const NoticeScreen({
    required this.homeProvider,
    required this.organization,
    super.key,
  });

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  NoticeService noticeService = NoticeService();

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '『$organizationName $groupName』のお知らせを表示しています。',
                  style: const TextStyle(fontSize: 14),
                ),
                CustomButtonSm(
                  labelText: 'お知らせを作成',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddNoticeDialog(
                      organization: widget.organization,
                      group: group,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: noticeService.streamList(
                  organizationId: widget.organization?.id,
                  groupId: group?.id,
                ),
                builder: (context, snapshot) {
                  List<NoticeModel> notices = [];
                  if (snapshot.hasData) {
                    for (DocumentSnapshot<Map<String, dynamic>> doc
                        in snapshot.data!.docs) {
                      notices.add(NoticeModel.fromSnapshot(doc));
                    }
                  }
                  return CustomDataGrid(
                    source: NoticeSource(
                      context: context,
                      notices: notices,
                      groups: widget.homeProvider.groups,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'title',
                        label: const CustomColumnLabel('タイトル'),
                      ),
                      GridColumn(
                        columnName: 'content',
                        label: const CustomColumnLabel('お知らせ内容'),
                      ),
                      GridColumn(
                        columnName: 'groupId',
                        label: const CustomColumnLabel('送信先グループ'),
                      ),
                      GridColumn(
                        columnName: 'edit',
                        label: const CustomColumnLabel('操作'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddNoticeDialog extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const AddNoticeDialog({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<AddNoticeDialog> createState() => _AddNoticeDialogState();
}

class _AddNoticeDialogState extends State<AddNoticeDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  PlatformFile? pickedFile;
  OrganizationGroupModel? selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.group;
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final noticeProvider = Provider.of<NoticeProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ContentDialog(
      title: const Text(
        'お知らせを作成する',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                maxLines: null,
              ),
            ),
            const SizedBox(height: 8),
            CustomButtonSm(
              labelText: 'ファイル選択',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                if (result == null) return;
                setState(() {
                  pickedFile = result.files.first;
                });
              },
            ),
            pickedFile != null ? Text('${pickedFile?.name}') : Container(),
            const SizedBox(height: 8),
            InfoLabel(
              label: '送信先グループ',
              child: ComboBox<OrganizationGroupModel>(
                isExpanded: true,
                value: selectedGroup,
                items: groupItems,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
                placeholder: const Text('グループ未選択'),
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
          labelText: '作成する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await noticeProvider.create(
              organization: widget.organization,
              title: titleController.text,
              content: contentController.text,
              pickedFile: pickedFile,
              group: selectedGroup,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'お知らせを作成しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
