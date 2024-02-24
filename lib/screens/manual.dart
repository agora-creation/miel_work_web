import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/manual.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class ManualScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const ManualScreen({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  @override
  Widget build(BuildContext context) {
    String organizationName = widget.organization?.name ?? '';
    String groupName = widget.group?.name ?? '';
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
                  '『$organizationName $groupName』の業務マニュアルを表示しています。',
                  style: const TextStyle(fontSize: 14),
                ),
                CustomButtonSm(
                  labelText: '業務マニュアルを追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddManualDialog(
                      organization: widget.organization,
                      group: widget.group,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class AddManualDialog extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const AddManualDialog({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<AddManualDialog> createState() => _AddManualDialogState();
}

class _AddManualDialogState extends State<AddManualDialog> {
  TextEditingController titleController = TextEditingController();
  PlatformFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    final manualProvider = Provider.of<ManualProvider>(context);
    return ContentDialog(
      title: const Text(
        '業務マニュアルを追加する',
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
            CustomButtonSm(
              labelText: 'PDFファイル選択',
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
            pickedFile != null ? Text('${pickedFile?.name}') : Container()
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
              organization: widget.organization,
              group: widget.group,
              title: titleController.text,
              pickedFile: pickedFile,
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
