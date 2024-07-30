import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/providers/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/file_picker_button.dart';
import 'package:miel_work_web/widgets/form_label.dart';
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
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
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
          '新規申請',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '以下内容で申請する',
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
              showMessage(context, '新規申請が完了しました', true);
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
              FormLabel(
                '申請番号',
                child: CustomTextField(
                  controller: numberController,
                  textInputType: TextInputType.number,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申請種別',
                child: Column(
                  children: kApplyTypes.map((e) {
                    return RadioListTile(
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          label: Text(e),
                          backgroundColor: generateApplyColor(e),
                        ),
                      ),
                      value: e,
                      groupValue: type,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          type = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '件名',
                child: CustomTextField(
                  controller: titleController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              type == '稟議' || type == '支払伺い'
                  ? FormLabel(
                      '金額',
                      child: CustomTextField(
                        controller: priceController,
                        textInputType: TextInputType.number,
                        maxLines: 1,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '内容',
                child: CustomTextField(
                  controller: contentController,
                  textInputType: TextInputType.multiline,
                  maxLines: 30,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル',
                child: FilePickerButton(
                  value: pickedFile,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル2',
                child: FilePickerButton(
                  value: pickedFile2,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile2 = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル3',
                child: FilePickerButton(
                  value: pickedFile3,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile3 = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル4',
                child: FilePickerButton(
                  value: pickedFile4,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile4 = result.files.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル5',
                child: FilePickerButton(
                  value: pickedFile5,
                  defaultValue: '',
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile5 = result.files.first;
                    });
                  },
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
