import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/lost.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
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
  TextEditingController itemNameController = TextEditingController();
  FilePickerResult? itemImageResult;
  TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lostProvider = Provider.of<LostProvider>(context);
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
                '落とし物を追加',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '追加する',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await lostProvider.create(
                    organization: widget.loginProvider.organization,
                    discoveryAt: discoveryAt,
                    discoveryPlace: discoveryPlaceController.text,
                    discoveryUser: discoveryUserController.text,
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
                  showMessage(context, '落とし物を追加しました', true);
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
                      label: '発見日',
                      child: Button(
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dateText('yyyy/MM/dd', discoveryAt)),
                              const Icon(FluentIcons.calendar),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          await CustomDateTimePicker().picker(
                            context: context,
                            init: discoveryAt,
                            title: '発見日を選択',
                            onChanged: (value) {
                              setState(() {
                                discoveryAt = value;
                              });
                            },
                            datetime: false,
                          );
                        },
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
                    child: InfoLabel(
                      label: '発見場所',
                      child: CustomTextBox(
                        controller: discoveryPlaceController,
                        placeholder: '',
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoLabel(
                      label: '発見者',
                      child: CustomTextBox(
                        controller: discoveryUserController,
                        placeholder: '',
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '品名',
                child: CustomTextBox(
                  controller: itemNameController,
                  placeholder: '',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '添付写真',
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
              const SizedBox(height: 8),
              InfoLabel(
                label: '備考',
                child: CustomTextBox(
                  controller: remarksController,
                  placeholder: '',
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
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
