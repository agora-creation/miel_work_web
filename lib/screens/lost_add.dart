import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/lost.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';

class LostAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LostAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LostAddScreen> createState() => _LostAddScreenState();
}

class _LostAddScreenState extends State<LostAddScreen> {
  DateTime discoveryAt = DateTime.now();
  TextEditingController discoveryPlaceController = TextEditingController();
  TextEditingController discoveryUserController = TextEditingController();
  TextEditingController itemNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  FilePickerResult? itemImageResult;
  TextEditingController remarksController = TextEditingController();

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
          '落とし物を追加',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '以下の内容で追加する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await lostProvider.create(
                organization: widget.loginProvider.organization,
                discoveryAt: discoveryAt,
                discoveryPlace: discoveryPlaceController.text,
                discoveryUser: discoveryUserController.text,
                itemNumber: itemNumberController.text,
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
              showMessage(context, '落とし物情報が追加されました', true);
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
                '落とし物No',
                child: CustomTextField(
                  controller: itemNumberController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
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
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
