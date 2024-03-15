import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/manual.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/manual.dart';
import 'package:miel_work_web/screens/manual_source.dart';
import 'package:miel_work_web/services/manual.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_pdf_field.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManualScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ManualScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  ManualService manualService = ManualService();

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
    return Stack(
      children: [
        const AnimationBackground(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '『$organizationName $groupName』の業務マニュアルを表示しています。',
                      style: const TextStyle(fontSize: 14),
                    ),
                    CustomButtonSm(
                      icon: FluentIcons.add,
                      labelText: '新規追加',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddManualDialog(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: manualService.streamList(
                      organizationId: widget.loginProvider.organization?.id,
                      groupId: group?.id,
                    ),
                    builder: (context, snapshot) {
                      List<ManualModel> manuals = [];
                      if (snapshot.hasData) {
                        manuals =
                            manualService.generateList(data: snapshot.data);
                      }
                      return CustomDataGrid(
                        source: ManualSource(
                          context: context,
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          manuals: manuals,
                        ),
                        columns: [
                          GridColumn(
                            columnName: 'title',
                            label: const CustomColumnLabel('タイトル'),
                          ),
                          GridColumn(
                            columnName: 'file',
                            label: const CustomColumnLabel('PDFファイル'),
                          ),
                          GridColumn(
                            columnName: 'groupId',
                            label: const CustomColumnLabel('公開グループ'),
                          ),
                          GridColumn(
                            columnName: 'edit',
                            label: const CustomColumnLabel('操作'),
                            width: 200,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AddManualDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const AddManualDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<AddManualDialog> createState() => _AddManualDialogState();
}

class _AddManualDialogState extends State<AddManualDialog> {
  TextEditingController titleController = TextEditingController();
  PlatformFile? pickedFile;
  OrganizationGroupModel? selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.homeProvider.currentGroup;
  }

  @override
  Widget build(BuildContext context) {
    final manualProvider = Provider.of<ManualProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ContentDialog(
      title: const Text(
        '業務マニュアルを追加',
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
                placeholder: '例) 掃除について',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            CustomPdfField(
              value: pickedFile,
              defaultValue: '',
              onTap: () async {
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
            const SizedBox(height: 8),
            InfoLabel(
              label: '公開グループ',
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
          labelText: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await manualProvider.create(
              organization: widget.loginProvider.organization,
              title: titleController.text,
              pickedFile: pickedFile,
              group: selectedGroup,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '業務マニュアルを追加しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
