import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/loan.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';

class LoanAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LoanAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LoanAddScreen> createState() => _LoanAddScreenState();
}

class _LoanAddScreenState extends State<LoanAddScreen> {
  DateTime loanAt = DateTime.now();
  TextEditingController loanUserController = TextEditingController();
  TextEditingController loanCompanyController = TextEditingController();
  TextEditingController loanStaffController = TextEditingController();
  DateTime returnPlanAt = DateTime.now();
  TextEditingController itemNameController = TextEditingController();
  FilePickerResult? itemImageResult;

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
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
          '貸出物の追加',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '追加する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await loanProvider.create(
                organization: widget.loginProvider.organization,
                loanAt: loanAt,
                loanUser: loanUserController.text,
                loanCompany: loanCompanyController.text,
                loanStaff: loanStaffController.text,
                returnPlanAt: returnPlanAt,
                itemName: itemNameController.text,
                itemImageResult: itemImageResult,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '貸出物を追加しました', true);
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
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
                      '貸出日',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', loanAt),
                        onTap: () async => await CustomDateTimePicker().picker(
                          context: context,
                          init: loanAt,
                          title: '貸出日を選択',
                          onChanged: (value) {
                            setState(() {
                              loanAt = value;
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
                      '貸出先',
                      child: CustomTextField(
                        controller: loanUserController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      '貸出先(会社)',
                      child: CustomTextField(
                        controller: loanCompanyController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormLabel(
                      '対応スタッフ',
                      child: CustomTextField(
                        controller: loanStaffController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      '返却予定日',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', returnPlanAt),
                        onTap: () async => await CustomDateTimePicker().picker(
                          context: context,
                          init: returnPlanAt,
                          title: '返却予定日を選択',
                          onChanged: (value) {
                            setState(() {
                              returnPlanAt = value;
                            });
                          },
                          datetime: false,
                        ),
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
                      : Container(
                          color: kGrey300Color,
                          width: double.infinity,
                          height: 150,
                          child: const Center(
                            child: Text('写真が選択されていません'),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
