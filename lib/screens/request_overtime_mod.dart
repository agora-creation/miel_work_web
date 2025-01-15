import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_overtime.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:provider/provider.dart';

class RequestOvertimeModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const RequestOvertimeModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<RequestOvertimeModScreen> createState() =>
      _RequestOvertimeModScreenState();
}

class _RequestOvertimeModScreenState extends State<RequestOvertimeModScreen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  DateTime useStartedAt = DateTime.now();
  DateTime useEndedAt = DateTime.now();
  bool useAtPending = false;
  TextEditingController useContent = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.overtime.companyName;
    companyUserName.text = widget.overtime.companyUserName;
    companyUserEmail.text = widget.overtime.companyUserEmail;
    companyUserTel.text = widget.overtime.companyUserTel;
    useStartedAt = widget.overtime.useStartedAt;
    useEndedAt = widget.overtime.useEndedAt;
    useAtPending = false;
    useContent.text = widget.overtime.useContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final overtimeProvider = Provider.of<RequestOvertimeProvider>(context);
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
          '夜間居残り作業申請：申請情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await overtimeProvider.update(
                overtime: widget.overtime,
                companyName: companyName.text,
                companyUserName: companyUserName.text,
                companyUserEmail: companyUserEmail.text,
                companyUserTel: companyUserTel.text,
                useStartedAt: useStartedAt,
                useEndedAt: useEndedAt,
                useAtPending: useAtPending,
                useContent: useContent.text,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '夜間居残り作業申請情報が変更されました', true);
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
                '作業情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '作業予定日時',
                child: DatetimeRangeForm(
                  startedAt: useStartedAt,
                  startedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    pickerType: DateTimePickerType.datetime,
                    init: useStartedAt,
                    title: '作業予定開始日時を選択',
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
                    title: '作業予定終了日時を選択',
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
                '作業内容',
                child: CustomTextField(
                  controller: useContent,
                  textInputType: TextInputType.multiline,
                  maxLines: 5,
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
