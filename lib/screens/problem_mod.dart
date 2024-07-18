import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/problem.dart';
import 'package:miel_work_web/widgets/checkbox_list.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';

class ProblemModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ProblemModel problem;

  const ProblemModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.problem,
    super.key,
  });

  @override
  State<ProblemModScreen> createState() => _ProblemModScreenState();
}

class _ProblemModScreenState extends State<ProblemModScreen> {
  String type = kProblemTypes.first;
  DateTime createdAt = DateTime.now();
  TextEditingController picNameController = TextEditingController();
  TextEditingController targetNameController = TextEditingController();
  TextEditingController targetAgeController = TextEditingController();
  TextEditingController targetTelController = TextEditingController();
  TextEditingController targetAddressController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController countController = TextEditingController(text: '0');
  FilePickerResult? imageResult;
  List<String> states = [];

  @override
  void initState() {
    type = widget.problem.type;
    createdAt = widget.problem.createdAt;
    picNameController.text = widget.problem.picName;
    targetNameController.text = widget.problem.targetName;
    targetAgeController.text = widget.problem.targetAge;
    targetTelController.text = widget.problem.targetTel;
    targetAddressController.text = widget.problem.targetAddress;
    detailsController.text = widget.problem.details;
    states = widget.problem.states;
    countController.text = widget.problem.count.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final problemProvider = Provider.of<ProblemProvider>(context);
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
          'クレーム／要望を編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '入力内容を保存',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await problemProvider.update(
                organization: widget.loginProvider.organization,
                problem: widget.problem,
                type: type,
                createdAt: createdAt,
                picName: picNameController.text,
                targetName: targetNameController.text,
                targetAge: targetAgeController.text,
                targetTel: targetTelController.text,
                targetAddress: targetAddressController.text,
                details: detailsController.text,
                imageResult: imageResult,
                states: states,
                count: int.parse(countController.text),
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, 'クレーム／要望を編集しました', true);
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
                      '報告日時',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', createdAt),
                        onTap: () async => await CustomDateTimePicker().picker(
                          context: context,
                          init: createdAt,
                          title: '報告日時を選択',
                          onChanged: (value) {
                            setState(() {
                              createdAt = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      '対応項目',
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: type,
                        items: kProblemTypes.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            type = value;
                          });
                        },
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
                      '対応者',
                      child: CustomTextField(
                        controller: picNameController,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        FormLabel(
                          '相手の名前',
                          child: CustomTextField(
                            controller: targetNameController,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FormLabel(
                          '相手の年齢',
                          child: CustomTextField(
                            controller: targetAgeController,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FormLabel(
                          '相手の連絡先',
                          child: CustomTextField(
                            controller: targetTelController,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FormLabel(
                          '相手の住所',
                          child: CustomTextField(
                            controller: targetAddressController,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FormLabel(
                '詳細',
                child: CustomTextField(
                  controller: detailsController,
                  textInputType: TextInputType.multiline,
                  maxLines: 20,
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
                      imageResult = result;
                    });
                  },
                  child: imageResult != null
                      ? Image.memory(
                          imageResult!.files.first.bytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : widget.problem.image != ''
                          ? Image.network(
                              widget.problem.image,
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
              const SizedBox(height: 8),
              FormLabel(
                '対応状態',
                child: Column(
                  children: kProblemStates.map((e) {
                    return CheckboxList(
                      value: states.contains(e),
                      onChanged: (value) {
                        if (states.contains(e)) {
                          states.remove(e);
                        } else {
                          states.add(e);
                        }
                        setState(() {});
                      },
                      label: e,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '同じような注意(対応)をした回数',
                child: CustomTextField(
                  controller: countController,
                  textInputType: TextInputType.number,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
