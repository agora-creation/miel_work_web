import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/problem.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_file_field.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class ProblemAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ProblemAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ProblemAddScreen> createState() => _ProblemAddScreenState();
}

class _ProblemAddScreenState extends State<ProblemAddScreen> {
  String type = kProblemTypes.first;
  DateTime createdAt = DateTime.now();
  TextEditingController picNameController = TextEditingController();
  TextEditingController targetNameController = TextEditingController();
  TextEditingController targetAgeController = TextEditingController();
  TextEditingController targetTelController = TextEditingController();
  TextEditingController targetAddressController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  List<String> states = [];

  @override
  Widget build(BuildContext context) {
    final problemProvider = Provider.of<ProblemProvider>(context);
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
                'クレーム／要望を追加',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '追加する',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await problemProvider.create(
                    organization: widget.loginProvider.organization,
                    type: type,
                    createdAt: createdAt,
                    picName: picNameController.text,
                    targetName: targetNameController.text,
                    targetAge: targetAgeController.text,
                    targetTel: targetTelController.text,
                    targetAddress: targetAddressController.text,
                    details: detailsController.text,
                    states: states,
                    loginUser: widget.loginProvider.user,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, 'クレーム／要望を追加しました', true);
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
              Row(
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: '報告日時',
                      child: Button(
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dateText('yyyy/MM/dd HH:mm', createdAt)),
                              const Icon(FluentIcons.calendar),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          await CustomDateTimePicker().picker(
                            context: context,
                            init: createdAt,
                            title: '報告日時を選択',
                            onChanged: (value) {
                              setState(() {
                                createdAt = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoLabel(
                      label: '対応項目',
                      child: ComboBox<String>(
                        isExpanded: true,
                        value: type,
                        items: kProblemTypes.map((e) {
                          return ComboBoxItem(
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
                    child: InfoLabel(
                      label: '対応者',
                      child: CustomTextBox(
                        controller: picNameController,
                        placeholder: '',
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        InfoLabel(
                          label: '相手の名前',
                          child: CustomTextBox(
                            controller: targetNameController,
                            placeholder: '',
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        InfoLabel(
                          label: '相手の年齢',
                          child: CustomTextBox(
                            controller: targetAgeController,
                            placeholder: '',
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        InfoLabel(
                          label: '相手の連絡先',
                          child: CustomTextBox(
                            controller: targetTelController,
                            placeholder: '',
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        InfoLabel(
                          label: '相手の住所',
                          child: CustomTextBox(
                            controller: targetAddressController,
                            placeholder: '',
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '詳細',
                child: CustomTextBox(
                  controller: detailsController,
                  placeholder: '',
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '添付写真',
                child: CustomFileField(
                  value: null,
                  defaultValue: '',
                  onPressed: () async {},
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '対応状態',
                child: Row(
                  children: kProblemStates.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Checkbox(
                        checked: states.contains(e),
                        onChanged: (value) {
                          if (states.contains(e)) {
                            states.remove(e);
                          } else {
                            states.add(e);
                          }
                          setState(() {});
                        },
                        content: Text(e),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
