import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_square.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_square.dart';
import 'package:miel_work_web/widgets/attached_file_list.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class RequestSquareModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const RequestSquareModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<RequestSquareModScreen> createState() => _RequestSquareModScreenState();
}

class _RequestSquareModScreenState extends State<RequestSquareModScreen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  TextEditingController companyAddress = TextEditingController();
  TextEditingController useCompanyName = TextEditingController();
  TextEditingController useCompanyUserName = TextEditingController();
  DateTime useStartedAt = DateTime.now();
  DateTime useEndedAt = DateTime.now();
  bool useAtPending = false;
  bool useFull = false;
  bool useChair = false;
  TextEditingController useChairNum = TextEditingController(text: '0');
  bool useDesk = false;
  TextEditingController useDeskNum = TextEditingController(text: '0');
  TextEditingController useContent = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.square.companyName;
    companyUserName.text = widget.square.companyUserName;
    companyUserEmail.text = widget.square.companyUserEmail;
    companyUserTel.text = widget.square.companyUserTel;
    companyAddress.text = widget.square.companyAddress;
    useCompanyName.text = widget.square.useCompanyName;
    useCompanyUserName.text = widget.square.useCompanyUserName;
    useStartedAt = widget.square.useStartedAt;
    useEndedAt = widget.square.useEndedAt;
    useAtPending = false;
    useFull = widget.square.useFull;
    useChair = widget.square.useChair;
    useChairNum.text = widget.square.useChairNum.toString();
    useDesk = widget.square.useDesk;
    useDeskNum.text = widget.square.useDeskNum.toString();
    useContent.text = widget.square.useContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
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
          'よさこい広場使用申込：申請情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await squareProvider.update(
                square: widget.square,
                companyName: companyName.text,
                companyUserName: companyUserName.text,
                companyUserEmail: companyUserEmail.text,
                companyUserTel: companyUserTel.text,
                companyAddress: companyAddress.text,
                useCompanyName: useCompanyName.text,
                useCompanyUserName: useCompanyUserName.text,
                useStartedAt: useStartedAt,
                useEndedAt: useEndedAt,
                useAtPending: useAtPending,
                useFull: useFull,
                useChair: useChair,
                useChairNum: int.parse(useChairNum.text),
                useDesk: useDesk,
                useDeskNum: int.parse(useDeskNum.text),
                useContent: useContent.text,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, 'よさこい広場使用申込情報が変更されました', true);
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
                '申込者情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込会社名(又は店名)',
                child: CustomTextField(
                  controller: companyName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）ひろめカンパニー',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: CustomTextField(
                  controller: companyUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）田中太郎',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: CustomTextField(
                  controller: companyUserEmail,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）tanaka@hirome.co.jp',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者電話番号',
                child: CustomTextField(
                  controller: companyUserTel,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）090-0000-0000',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '住所',
                child: CustomTextField(
                  controller: companyAddress,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '使用者情報 (申込者情報と異なる場合のみ)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用会社名(又は店名)',
                child: CustomTextField(
                  controller: useCompanyName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）明神水産',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: CustomTextField(
                  controller: useCompanyUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）田中二郎',
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '使用情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用場所を記したPDFファイル',
                child: widget.square.useLocationFile != ''
                    ? AttachedFileList(
                        fileName: p.basename(widget.square.useLocationFile),
                        onTap: () {
                          downloadFile(
                            url: widget.square.useLocationFile,
                            name: p.basename(widget.square.useLocationFile),
                          );
                        },
                      )
                    : const FormValue('ファイルなし'),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用予定日時',
                child: DatetimeRangeForm(
                  startedAt: useStartedAt,
                  startedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    pickerType: DateTimePickerType.datetime,
                    init: useStartedAt,
                    title: '使用予定開始日時を選択',
                    onChanged: (value) {
                      setState(() {
                        useStartedAt = value;
                      });
                    },
                  ),
                  endedAt: useEndedAt,
                  endedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    pickerType: DateTimePickerType.datetime,
                    init: useEndedAt,
                    title: '使用予定終了日時を選択',
                    onChanged: (value) {
                      setState(() {
                        useEndedAt = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用区分',
                child: Column(
                  children: [
                    CustomCheckbox(
                      label: '全面使用',
                      value: useFull,
                      onChanged: (value) {
                        setState(() {
                          useFull = value ?? false;
                        });
                      },
                      child: Container(),
                    ),
                    CustomCheckbox(
                      label: '折りたたみイス',
                      subLabel: '150円(税抜)／1脚・1日',
                      value: useChair,
                      onChanged: (value) {
                        setState(() {
                          useChair = value ?? false;
                        });
                      },
                      child: CustomTextField(
                        label: '脚数',
                        controller: useChairNum,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                        enabled: useChair,
                      ),
                    ),
                    CustomCheckbox(
                      label: '折りたたみ机',
                      subLabel: '300円(税抜)／1台・1日',
                      value: useDesk,
                      onChanged: (value) {
                        setState(() {
                          useDesk = value ?? false;
                        });
                      },
                      child: CustomTextField(
                        label: '台数',
                        controller: useDeskNum,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                        enabled: useDesk,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用内容',
                child: CustomTextField(
                  controller: useContent,
                  textInputType: TextInputType.multiline,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.square.attachedFiles.map((file) {
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
