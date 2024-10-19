import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_interview.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_interview.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/datetime_range_form.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:provider/provider.dart';

class RequestInterviewModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const RequestInterviewModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<RequestInterviewModScreen> createState() =>
      _RequestInterviewDetailScreenState();
}

class _RequestInterviewDetailScreenState
    extends State<RequestInterviewModScreen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  TextEditingController mediaName = TextEditingController();
  TextEditingController programName = TextEditingController();
  TextEditingController castInfo = TextEditingController();
  TextEditingController featureContent = TextEditingController();
  TextEditingController publishedAt = TextEditingController();
  DateTime interviewedStartedAt = DateTime.now();
  DateTime interviewedEndedAt = DateTime.now();
  bool interviewedAtPending = false;
  TextEditingController interviewedUserName = TextEditingController();
  TextEditingController interviewedUserTel = TextEditingController();
  bool interviewedReserved = false;
  TextEditingController interviewedShopName = TextEditingController();
  TextEditingController interviewedVisitors = TextEditingController();
  TextEditingController interviewedContent = TextEditingController();
  bool location = false;
  DateTime locationStartedAt = DateTime.now();
  DateTime locationEndedAt = DateTime.now();
  bool locationAtPending = false;
  TextEditingController locationUserName = TextEditingController();
  TextEditingController locationUserTel = TextEditingController();
  TextEditingController locationVisitors = TextEditingController();
  TextEditingController locationContent = TextEditingController();
  bool insert = false;
  DateTime insertedStartedAt = DateTime.now();
  DateTime insertedEndedAt = DateTime.now();
  bool insertedAtPending = false;
  TextEditingController insertedUserName = TextEditingController();
  TextEditingController insertedUserTel = TextEditingController();
  bool insertedReserved = false;
  TextEditingController insertedShopName = TextEditingController();
  TextEditingController insertedVisitors = TextEditingController();
  TextEditingController insertedContent = TextEditingController();
  TextEditingController remarks = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.interview.companyName;
    companyUserName.text = widget.interview.companyUserName;
    companyUserEmail.text = widget.interview.companyUserEmail;
    companyUserTel.text = widget.interview.companyUserTel;
    mediaName.text = widget.interview.mediaName;
    programName.text = widget.interview.programName;
    castInfo.text = widget.interview.castInfo;
    featureContent.text = widget.interview.featureContent;
    publishedAt.text = widget.interview.publishedAt;
    interviewedStartedAt = widget.interview.interviewedStartedAt;
    interviewedEndedAt = widget.interview.interviewedEndedAt;
    insertedAtPending = false;
    interviewedUserName.text = widget.interview.interviewedUserName;
    interviewedUserTel.text = widget.interview.interviewedUserTel;
    interviewedReserved = widget.interview.interviewedReserved;
    interviewedShopName.text = widget.interview.interviewedShopName;
    interviewedVisitors.text = widget.interview.interviewedVisitors;
    interviewedContent.text = widget.interview.interviewedContent;
    location = widget.interview.location;
    locationStartedAt = widget.interview.locationStartedAt;
    locationEndedAt = widget.interview.locationEndedAt;
    locationAtPending = false;
    locationUserName.text = widget.interview.locationUserName;
    locationUserTel.text = widget.interview.locationUserTel;
    locationVisitors.text = widget.interview.locationVisitors;
    locationContent.text = widget.interview.locationContent;
    insert = widget.interview.insert;
    insertedStartedAt = widget.interview.insertedStartedAt;
    insertedEndedAt = widget.interview.insertedEndedAt;
    insertedAtPending = false;
    insertedUserName.text = widget.interview.insertedUserName;
    insertedUserTel.text = widget.interview.insertedUserTel;
    insertedReserved = widget.interview.insertedReserved;
    insertedShopName.text = widget.interview.insertedShopName;
    insertedVisitors.text = widget.interview.insertedVisitors;
    insertedContent.text = widget.interview.insertedContent;
    remarks.text = widget.interview.remarks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
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
          '取材申込：申請情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await interviewProvider.update(
                interview: widget.interview,
                companyName: companyName.text,
                companyUserName: companyUserName.text,
                companyUserEmail: companyUserEmail.text,
                companyUserTel: companyUserTel.text,
                mediaName: mediaName.text,
                programName: programName.text,
                castInfo: castInfo.text,
                featureContent: featureContent.text,
                publishedAt: publishedAt.text,
                interviewedStartedAt: interviewedStartedAt,
                interviewedEndedAt: interviewedEndedAt,
                interviewedAtPending: interviewedAtPending,
                interviewedUserName: interviewedUserName.text,
                interviewedUserTel: interviewedUserTel.text,
                interviewedReserved: interviewedReserved,
                interviewedShopName: interviewedShopName.text,
                interviewedVisitors: interviewedVisitors.text,
                interviewedContent: interviewedContent.text,
                location: location,
                locationStartedAt: locationStartedAt,
                locationEndedAt: locationEndedAt,
                locationAtPending: locationAtPending,
                locationUserName: locationUserName.text,
                locationUserTel: locationUserTel.text,
                locationVisitors: locationVisitors.text,
                locationContent: locationContent.text,
                insert: insert,
                insertedStartedAt: insertedStartedAt,
                insertedEndedAt: insertedEndedAt,
                insertedAtPending: insertedAtPending,
                insertedUserName: insertedUserName.text,
                insertedUserTel: insertedUserTel.text,
                insertedReserved: insertedReserved,
                insertedShopName: insertedShopName.text,
                insertedVisitors: insertedVisitors.text,
                insertedContent: insertedContent.text,
                remarks: remarks.text,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '取材申込情報が変更されました', true);
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
                '申込会社名',
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
                '媒体名',
                child: CustomTextField(
                  controller: mediaName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）TV放送・WEB配信',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '番組・雑誌名',
                child: CustomTextField(
                  controller: programName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）ABC放送『ひろめ市場へ行こう！』',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '出演者情報',
                child: CustomTextField(
                  controller: castInfo,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）ひろめ太郎、ひろめ花子',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '特集内容・備考',
                child: CustomTextField(
                  controller: featureContent,
                  textInputType: TextInputType.multiline,
                  maxLines: 3,
                  hintText: '例）賑わうひろめ市場の様子と高知の名物料理特集',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'OA・掲載予定日',
                child: CustomTextField(
                  controller: publishedAt,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）令和元年11月1日10時から放送予定',
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '取材当日情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材予定日時',
                child: DatetimeRangeForm(
                  startedAt: interviewedStartedAt,
                  startedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    init: interviewedStartedAt,
                    title: '取材予定開始日時を選択',
                    onChanged: (value) {
                      setState(() {
                        interviewedStartedAt = value;
                      });
                    },
                  ),
                  endedAt: interviewedEndedAt,
                  endedOnTap: () async => await CustomDateTimePicker().picker(
                    context: context,
                    init: interviewedEndedAt,
                    title: '取材予定終了日時を選択',
                    onChanged: (value) {
                      setState(() {
                        interviewedEndedAt = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材担当者名',
                child: CustomTextField(
                  controller: interviewedUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）山田二郎',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材担当者電話番号',
                child: CustomTextField(
                  controller: interviewedUserTel,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）090-0000-0000',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '席の予約',
                child: CustomCheckbox(
                  label: '必要な場合はチェックを入れてください',
                  value: interviewedReserved,
                  onChanged: (value) {
                    setState(() {
                      interviewedReserved = value ?? false;
                    });
                  },
                  child: Container(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材店舗',
                child: CustomTextField(
                  controller: interviewedShopName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）明神丸、黒潮物産',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'いらっしゃる人数',
                child: CustomTextField(
                  controller: interviewedVisitors,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText:
                      '例）タレント2名(ひろめ太郎・ひろめくん)、スタッフ4名、カメラマン1名、ディレクター1名、AD2名',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材内容・備考',
                child: CustomTextField(
                  controller: interviewedContent,
                  textInputType: TextInputType.multiline,
                  maxLines: 3,
                  hintText: '例）ひろめ太郎とゲストのひろめくんが館内を散策する様子とカツオのたたきや芋けんぴを食べる様子',
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              CustomCheckbox(
                label: 'ロケハンをする場合はチェックを入れてください',
                value: location,
                onChanged: (value) {
                  setState(() {
                    location = value ?? false;
                  });
                },
                child: Container(),
              ),
              location
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'ロケハン情報',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン予定日時',
                          child: DatetimeRangeForm(
                            startedAt: locationStartedAt,
                            startedOnTap: () async =>
                                await CustomDateTimePicker().picker(
                              context: context,
                              init: locationStartedAt,
                              title: 'ロケハン予定開始日時を選択',
                              onChanged: (value) {
                                setState(() {
                                  locationStartedAt = value;
                                });
                              },
                            ),
                            endedAt: locationEndedAt,
                            endedOnTap: () async =>
                                await CustomDateTimePicker().picker(
                              context: context,
                              init: locationEndedAt,
                              title: 'ロケハン予定終了日時を選択',
                              onChanged: (value) {
                                setState(() {
                                  locationEndedAt = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン担当者名',
                          child: CustomTextField(
                            controller: locationUserName,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            hintText: '例）田中太郎',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン担当者電話番号',
                          child: CustomTextField(
                            controller: locationUserTel,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            hintText: '例）090-0000-0000',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'いらっしゃる人数',
                          child: CustomTextField(
                            controller: locationVisitors,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            hintText: '例）2名',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン内容・備考',
                          child: CustomTextField(
                            controller: locationContent,
                            textInputType: TextInputType.multiline,
                            maxLines: 3,
                            hintText: '例）9/17(火)〜9/20(金)のいずれかの日程で14:00〜15:00',
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              CustomCheckbox(
                label: 'インサート撮影をする場合はチェックを入れてください',
                value: insert,
                onChanged: (value) {
                  setState(() {
                    insert = value ?? false;
                  });
                },
                child: Container(),
              ),
              insert
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'インサート撮影情報',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影予定日時',
                          child: DatetimeRangeForm(
                            startedAt: insertedStartedAt,
                            startedOnTap: () async =>
                                await CustomDateTimePicker().picker(
                              context: context,
                              init: insertedStartedAt,
                              title: '撮影予定開始日時を選択',
                              onChanged: (value) {
                                setState(() {
                                  insertedStartedAt = value;
                                });
                              },
                            ),
                            endedAt: insertedEndedAt,
                            endedOnTap: () async =>
                                await CustomDateTimePicker().picker(
                              context: context,
                              init: insertedEndedAt,
                              title: '撮影予定終了日時を選択',
                              onChanged: (value) {
                                setState(() {
                                  insertedEndedAt = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影担当者名',
                          child: CustomTextField(
                            controller: insertedUserName,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            hintText: '例）山田太郎',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影担当者電話番号',
                          child: CustomTextField(
                            controller: insertedUserTel,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            hintText: '例）090-0000-0000',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '席の予約',
                          child: CustomCheckbox(
                            label: '必要な場合はチェックを入れてください',
                            value: insertedReserved,
                            onChanged: (value) {
                              setState(() {
                                insertedReserved = value ?? false;
                              });
                            },
                            child: Container(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影店舗',
                          child: CustomTextField(
                            controller: insertedShopName,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            hintText: '例）明神丸、黒潮物産',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'いらっしゃる人数',
                          child: CustomTextField(
                            controller: insertedVisitors,
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            hintText: '例）3名',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影内容・備考',
                          child: CustomTextField(
                            controller: insertedContent,
                            textInputType: TextInputType.multiline,
                            maxLines: 3,
                            hintText: '例）ひろめ市場の内観・外観、カツオのたたきを焼いている映像',
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                'その他連絡事項',
                child: CustomTextField(
                  controller: remarks,
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
