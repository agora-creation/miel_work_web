import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/apply_conference.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_file_field.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class ApplyConferenceAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyConferenceAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyConferenceAddScreen> createState() =>
      _ApplyConferenceAddScreenState();
}

class _ApplyConferenceAddScreenState extends State<ApplyConferenceAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  PlatformFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);
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
                '協議・報告申請を作成',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '提出する',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await conferenceProvider.create(
                    organization: widget.loginProvider.organization,
                    group: null,
                    title: titleController.text,
                    content: contentController.text,
                    pickedFile: pickedFile,
                    loginUser: widget.loginProvider.user,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '協議・報告申請を提出しました', true);
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
                label: '件名',
                child: CustomTextBox(
                  controller: titleController,
                  placeholder: '',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '内容',
                child: CustomTextBox(
                  controller: contentController,
                  placeholder: '',
                  keyboardType: TextInputType.multiline,
                  maxLines: 30,
                ),
              ),
              const SizedBox(height: 8),
              CustomFileField(
                value: pickedFile,
                defaultValue: '',
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
