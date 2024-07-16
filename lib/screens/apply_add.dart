import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/providers/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_file_field.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class ApplyAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel? apply;

  const ApplyAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    this.apply,
    super.key,
  });

  @override
  State<ApplyAddScreen> createState() => _ApplyAddScreenState();
}

class _ApplyAddScreenState extends State<ApplyAddScreen> {
  TextEditingController numberController = TextEditingController();
  String type = kApplyTypes.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController priceController = TextEditingController(text: '0');
  PlatformFile? pickedFile;
  PlatformFile? pickedFile2;
  PlatformFile? pickedFile3;
  PlatformFile? pickedFile4;
  PlatformFile? pickedFile5;

  void _init() async {
    if (widget.apply == null) return;
    numberController.text = widget.apply?.number ?? '';
    type = widget.apply?.type ?? kApplyTypes.first;
    titleController.text = widget.apply?.title ?? '';
    contentController.text = widget.apply?.content ?? '';
    priceController.text = widget.apply?.price.toString() ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
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
                '新規申請',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '送信する',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  int price = 0;
                  if (type == '稟議' || type == '支払伺い') {
                    price = int.parse(priceController.text);
                  }
                  String? error = await applyProvider.create(
                    organization: widget.loginProvider.organization,
                    group: null,
                    number: numberController.text,
                    type: type,
                    title: titleController.text,
                    content: contentController.text,
                    price: price,
                    pickedFile: pickedFile,
                    pickedFile2: pickedFile2,
                    pickedFile3: pickedFile3,
                    pickedFile4: pickedFile4,
                    pickedFile5: pickedFile5,
                    loginUser: widget.loginProvider.user,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '新規申請を送信しました', true);
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
                label: '申請番号',
                child: CustomTextBox(
                  controller: numberController,
                  placeholder: '',
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '申請種別',
                child: ComboBox<String>(
                  value: type,
                  items: kApplyTypes.map((e) {
                    return ComboBoxItem(
                      value: e,
                      child: Text('$e申請'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      type = value ?? kApplyTypes.first;
                    });
                  },
                  isExpanded: true,
                ),
              ),
              const SizedBox(height: 8),
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
              type == '稟議' || type == '支払伺い'
                  ? InfoLabel(
                      label: '金額',
                      child: CustomTextBox(
                        controller: priceController,
                        placeholder: '',
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                      ),
                    )
                  : Container(),
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
              InfoLabel(
                label: '添付ファイル',
                child: CustomFileField(
                  value: pickedFile,
                  defaultValue: '',
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
              InfoLabel(
                label: '添付ファイル2',
                child: CustomFileField(
                  value: pickedFile2,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                      withData: true,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile2 = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '添付ファイル3',
                child: CustomFileField(
                  value: pickedFile3,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                      withData: true,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile3 = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '添付ファイル4',
                child: CustomFileField(
                  value: pickedFile4,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                      withData: true,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile4 = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '添付ファイル5',
                child: CustomFileField(
                  value: pickedFile5,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                      withData: true,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile5 = result.files.first;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
