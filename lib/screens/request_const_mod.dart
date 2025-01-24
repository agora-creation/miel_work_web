import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_const.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_const.dart';
import 'package:miel_work_web/widgets/attached_file_list.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class RequestConstModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const RequestConstModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<RequestConstModScreen> createState() => _RequestConstModScreenState();
}

class _RequestConstModScreenState extends State<RequestConstModScreen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  TextEditingController constName = TextEditingController();
  TextEditingController constUserName = TextEditingController();
  TextEditingController constUserTel = TextEditingController();
  DateTime constStartedAt = DateTime.now();
  DateTime constEndedAt = DateTime.now();
  bool constAtPending = false;
  TextEditingController constContent = TextEditingController();
  bool noise = false;
  TextEditingController noiseMeasures = TextEditingController();
  bool dust = false;
  TextEditingController dustMeasures = TextEditingController();
  bool fire = false;
  TextEditingController fireMeasures = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.requestConst.companyName;
    companyUserName.text = widget.requestConst.companyUserName;
    companyUserEmail.text = widget.requestConst.companyUserEmail;
    companyUserTel.text = widget.requestConst.companyUserTel;
    constName.text = widget.requestConst.constName;
    constUserName.text = widget.requestConst.constUserName;
    constUserTel.text = widget.requestConst.constUserTel;
    constStartedAt = widget.requestConst.constStartedAt;
    constEndedAt = widget.requestConst.constEndedAt;
    constAtPending = false;
    constContent.text = widget.requestConst.constContent;
    noise = widget.requestConst.noise;
    noiseMeasures.text = widget.requestConst.noiseMeasures;
    dust = widget.requestConst.dust;
    dustMeasures.text = widget.requestConst.dustMeasures;
    fire = widget.requestConst.fire;
    fireMeasures.text = widget.requestConst.fireMeasures;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
          '店舗工事作業申請：申請情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await constProvider.update(
                requestConst: widget.requestConst,
                companyName: companyName.text,
                companyUserName: companyUserName.text,
                companyUserEmail: companyUserEmail.text,
                companyUserTel: companyUserTel.text,
                constName: constName.text,
                constUserName: constUserName.text,
                constUserTel: constUserTel.text,
                constStartedAt: constStartedAt,
                constEndedAt: constEndedAt,
                constAtPending: constAtPending,
                constContent: constContent.text,
                noise: noise,
                noiseMeasures: noiseMeasures.text,
                dust: dust,
                dustMeasures: dustMeasures.text,
                fire: fire,
                fireMeasures: fireMeasures.text,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '店舗工事作業申請情報が変更されました', true);
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
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '申請者情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗名',
                child: CustomTextField(
                  controller: companyName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）明神水産',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者名',
                child: CustomTextField(
                  controller: companyUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）田中太郎',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者メールアドレス',
                child: CustomTextField(
                  controller: companyUserEmail,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）tanaka@hirome.co.jp',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者電話番号',
                child: CustomTextField(
                  controller: companyUserTel,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）090-0000-0000',
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '工事施工情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工会社名',
                child: CustomTextField(
                  controller: constName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）株式会社ABC',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工代表者名',
                child: CustomTextField(
                  controller: constUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）山田二郎',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工代表者電話番号',
                child: CustomTextField(
                  controller: constUserTel,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）090-0000-0000',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '施工予定日時',
                child: DatetimeRangeForm(
                  startedAt: constStartedAt,
                  startedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    pickerType: DateTimePickerType.datetime,
                    init: constStartedAt,
                    title: '施工予定開始日時を選択',
                    onChanged: (value) {
                      setState(() {
                        constStartedAt = value;
                      });
                    },
                  ),
                  endedAt: constEndedAt,
                  endedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    pickerType: DateTimePickerType.datetime,
                    init: constEndedAt,
                    title: '施工予定終了日時を選択',
                    onChanged: (value) {
                      setState(() {
                        constEndedAt = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '施工内容',
                child: CustomTextField(
                  controller: constContent,
                  textInputType: TextInputType.multiline,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '騒音',
                child: CustomCheckbox(
                  label: '有る場合はチェックを入れてください',
                  value: noise,
                  onChanged: (value) {
                    setState(() {
                      noise = value ?? false;
                    });
                  },
                  child: Container(),
                ),
              ),
              noise
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '騒音対策',
                        child: CustomTextField(
                          controller: noiseMeasures,
                          textInputType: TextInputType.text,
                          maxLines: 1,
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '粉塵',
                child: CustomCheckbox(
                  label: '有る場合はチェックを入れてください',
                  value: dust,
                  onChanged: (value) {
                    setState(() {
                      dust = value ?? false;
                    });
                  },
                  child: Container(),
                ),
              ),
              dust
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '粉塵対策',
                        child: CustomTextField(
                          controller: dustMeasures,
                          textInputType: TextInputType.text,
                          maxLines: 1,
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '火気の使用',
                child: CustomCheckbox(
                  label: '有る場合はチェックを入れてください',
                  value: fire,
                  onChanged: (value) {
                    setState(() {
                      fire = value ?? false;
                    });
                  },
                  child: Container(),
                ),
              ),
              fire
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '火気対策',
                        child: CustomTextField(
                          controller: fireMeasures,
                          textInputType: TextInputType.text,
                          maxLines: 1,
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.requestConst.attachedFiles.map((file) {
                        return AttachedFileList(
                          fileName: p.basename(file),
                          onTap: () {
                            downloadFile(
                              url: file,
                              name: p.basename(file),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
