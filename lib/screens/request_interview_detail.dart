import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/comment.dart';
import 'package:miel_work_web/models/request_interview.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/request_interview.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/services/request_interview.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/attached_file_list.dart';
import 'package:miel_work_web/widgets/comment_list.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/dotted_divider.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestInterviewDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const RequestInterviewDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<RequestInterviewDetailScreen> createState() =>
      _RequestInterviewDetailScreenState();
}

class _RequestInterviewDetailScreenState
    extends State<RequestInterviewDetailScreen> {
  RequestInterviewService interviewService = RequestInterviewService();
  RequestInterviewModel? interview;
  List<CommentModel> comments = [];

  void _showTextField({
    required TextEditingController controller,
    TextInputType textInputType = TextInputType.text,
    required Function() onPressed,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomAlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: controller,
              textInputType: textInputType,
              maxLines: textInputType == TextInputType.text ? 1 : null,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  type: ButtonSizeType.sm,
                  label: 'キャンセル',
                  labelColor: kWhiteColor,
                  backgroundColor: kGreyColor,
                  onPressed: () => Navigator.pop(context),
                ),
                CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保存',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: onPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _reloadComments() async {
    RequestInterviewModel? tmpInterview = await interviewService.selectData(
      id: widget.interview.id,
    );
    if (tmpInterview == null) return;
    comments = tmpInterview.comments;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    bool commentNotRead = true;
    List<Map> comments = [];
    if (widget.interview.comments.isNotEmpty) {
      for (final comment in widget.interview.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
        List<String> commentReadUserIds = comment.readUserIds;
        if (!commentReadUserIds.contains(user?.id)) {
          commentReadUserIds.add(user?.id ?? '');
        }
        comment.readUserIds = commentReadUserIds;
        comments.add(comment.toMap());
      }
    }
    if (commentNotRead) {
      interviewService.update({
        'id': widget.interview.id,
        'comments': comments,
      });
    }
  }

  void _reloadRequestInterview() async {
    RequestInterviewModel? tmpInterview = await interviewService.selectData(
      id: widget.interview.id,
    );
    if (tmpInterview == null) return;
    interview = tmpInterview;
    setState(() {});
  }

  @override
  void initState() {
    _read();
    _reloadRequestInterview();
    _reloadComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    if (interview!.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in interview!.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (interview!.approval == 1 || interview!.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = interview!.approvalUsers;
    List<ApprovalUserModel> reApprovalUsers = approvalUsers.reversed.toList();
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
          '取材申込：申請情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: 'PDF出力',
            labelColor: kWhiteColor,
            backgroundColor: kPdfColor,
            onPressed: () async => await PdfService().requestInterviewDownload(
              interview!,
            ),
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '否決する',
            labelColor: kWhiteColor,
            backgroundColor: kRejectColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => RejectRequestInterviewDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                interview: interview!,
              ),
            ),
            disabled: !isReject,
          ),
          const SizedBox(width: 4),
          CustomButton(
            type: ButtonSizeType.sm,
            label: '承認する',
            labelColor: kWhiteColor,
            backgroundColor: kApprovalColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ApprovalRequestInterviewDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                interview: interview!,
              ),
            ),
            disabled: !isApproval,
          ),
          const SizedBox(width: 4),
          interview!.pending == true
              ? CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留を解除する',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingCancelRequestInterviewDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      interview: interview!,
                    ),
                  ),
                  disabled: interview!.approval != 0,
                )
              : CustomButton(
                  type: ButtonSizeType.sm,
                  label: '保留中にする',
                  labelColor: kBlackColor,
                  backgroundColor: kYellowColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => PendingRequestInterviewDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      interview: interview!,
                    ),
                  ),
                  disabled: interview!.approval != 0,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '申込日時: ${dateText('yyyy/MM/dd HH:mm', interview!.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  interview!.approval == 1
                      ? Text(
                          '承認日時: ${dateText('yyyy/MM/dd HH:mm', interview!.approvedAt)}',
                          style: const TextStyle(color: kRedColor),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 8),
              reApprovalUsers.isNotEmpty
                  ? FormLabel(
                      '承認者一覧',
                      child: Container(
                        color: kRedColor.withOpacity(0.3),
                        width: double.infinity,
                        child: Column(
                          children: reApprovalUsers.map((approvalUser) {
                            return ApprovalUserList(approvalUser: approvalUser);
                          }).toList(),
                        ),
                      ),
                    )
                  : Container(),
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
                child: FormValue(
                  interview!.companyName,
                  onTap: () {
                    final companyNameController = TextEditingController(
                      text: interview!.companyName,
                    );
                    _showTextField(
                      controller: companyNameController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'companyName': companyNameController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: FormValue(
                  interview!.companyUserName,
                  onTap: () {
                    final companyUserNameController = TextEditingController(
                      text: interview!.companyUserName,
                    );
                    _showTextField(
                      controller: companyUserNameController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'companyUserName': companyUserNameController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: FormValue(
                  interview!.companyUserEmail,
                  onTap: () {
                    final companyUserEmailController = TextEditingController(
                      text: interview!.companyUserEmail,
                    );
                    _showTextField(
                      controller: companyUserEmailController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'companyUserEmail': companyUserEmailController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${interview!.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者電話番号',
                child: FormValue(
                  interview!.companyUserTel,
                  onTap: () {
                    final companyUserTelController = TextEditingController(
                      text: interview!.companyUserTel,
                    );
                    _showTextField(
                      controller: companyUserTelController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'companyUserTel': companyUserTelController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '媒体名',
                child: FormValue(
                  interview!.mediaName,
                  onTap: () {
                    final mediaNameController = TextEditingController(
                      text: interview!.mediaName,
                    );
                    _showTextField(
                      controller: mediaNameController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'mediaName': mediaNameController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '番組・雑誌名',
                child: FormValue(
                  interview!.programName,
                  onTap: () {
                    final programNameController = TextEditingController(
                      text: interview!.programName,
                    );
                    _showTextField(
                      controller: programNameController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'programName': programNameController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '出演者情報',
                child: FormValue(
                  interview!.castInfo,
                  onTap: () {
                    final castInfoController = TextEditingController(
                      text: interview!.castInfo,
                    );
                    _showTextField(
                      controller: castInfoController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'castInfo': castInfoController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '特集内容・備考',
                child: FormValue(
                  interview!.featureContent,
                  onTap: () {
                    final featureContentController = TextEditingController(
                      text: interview!.featureContent,
                    );
                    _showTextField(
                      controller: featureContentController,
                      textInputType: TextInputType.multiline,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'featureContent': featureContentController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'OA・掲載予定日',
                child: FormValue(interview!.publishedAt),
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
                child: FormValue(
                  interview!.interviewedAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', interview!.interviewedStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', interview!.interviewedEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材担当者名',
                child: FormValue(
                  interview!.interviewedUserName,
                  onTap: () {
                    final interviewedUserNameController = TextEditingController(
                      text: interview!.interviewedUserName,
                    );
                    _showTextField(
                      controller: interviewedUserNameController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'interviewedUserName':
                              interviewedUserNameController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材担当者電話番号',
                child: FormValue(
                  interview!.interviewedUserTel,
                  onTap: () {
                    final interviewedUserTelController = TextEditingController(
                      text: interview!.interviewedUserTel,
                    );
                    _showTextField(
                      controller: interviewedUserTelController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'interviewedUserTel':
                              interviewedUserTelController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '席の予約',
                child: FormValue(interview!.interviewedReserved ? '必要' : ''),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材店舗',
                child: FormValue(
                  interview!.interviewedShopName,
                  onTap: () {
                    final interviewedShopNameController = TextEditingController(
                      text: interview!.interviewedShopName,
                    );
                    _showTextField(
                      controller: interviewedShopNameController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'interviewedShopName':
                              interviewedShopNameController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'いらっしゃる人数',
                child: FormValue(
                  interview!.interviewedVisitors,
                  onTap: () {
                    final interviewedVisitorsController = TextEditingController(
                      text: interview!.interviewedVisitors,
                    );
                    _showTextField(
                      controller: interviewedVisitorsController,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'interviewedVisitors':
                              interviewedVisitorsController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材内容・備考',
                child: FormValue(
                  interview!.interviewedContent,
                  onTap: () {
                    final interviewedContentController = TextEditingController(
                      text: interview!.interviewedContent,
                    );
                    _showTextField(
                      controller: interviewedContentController,
                      textInputType: TextInputType.multiline,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'interviewedContent':
                              interviewedContentController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              interview!.location
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
                          child: FormValue(
                            interview!.locationAtPending
                                ? '未定'
                                : '${dateText('yyyy年MM月dd日 HH:mm', interview!.locationStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', interview!.locationEndedAt)}',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン担当者名',
                          child: FormValue(
                            interview!.locationUserName,
                            onTap: () {
                              final locationUserNameController =
                                  TextEditingController(
                                text: interview!.locationUserName,
                              );
                              _showTextField(
                                controller: locationUserNameController,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'locationUserName':
                                        locationUserNameController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン担当者電話番号',
                          child: FormValue(
                            interview!.locationUserTel,
                            onTap: () {
                              final locationUserTelController =
                                  TextEditingController(
                                text: interview!.locationUserTel,
                              );
                              _showTextField(
                                controller: locationUserTelController,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'locationUserTel':
                                        locationUserTelController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'いらっしゃる人数',
                          child: FormValue(
                            interview!.locationVisitors,
                            onTap: () {
                              final locationVisitorsController =
                                  TextEditingController(
                                text: interview!.locationVisitors,
                              );
                              _showTextField(
                                controller: locationVisitorsController,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'locationVisitors':
                                        locationVisitorsController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン内容・備考',
                          child: FormValue(
                            interview!.locationContent,
                            onTap: () {
                              final locationContentController =
                                  TextEditingController(
                                text: interview!.locationContent,
                              );
                              _showTextField(
                                controller: locationContentController,
                                textInputType: TextInputType.multiline,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'locationContent':
                                        locationContentController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Text('ロケハンなし'),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              interview!.insert
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
                          child: FormValue(
                            interview!.insertedAtPending
                                ? '未定'
                                : '${dateText('yyyy年MM月dd日 HH:mm', interview!.insertedStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', interview!.insertedEndedAt)}',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影担当者名',
                          child: FormValue(
                            interview!.insertedUserName,
                            onTap: () {
                              final insertedUserNameController =
                                  TextEditingController(
                                text: interview!.insertedUserName,
                              );
                              _showTextField(
                                controller: insertedUserNameController,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'insertedUserName':
                                        insertedUserNameController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影担当者電話番号',
                          child: FormValue(
                            interview!.insertedUserTel,
                            onTap: () {
                              final insertedUserTelController =
                                  TextEditingController(
                                text: interview!.insertedUserTel,
                              );
                              _showTextField(
                                controller: insertedUserTelController,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'insertedUserTel':
                                        insertedUserTelController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '席の予約',
                          child: FormValue(
                              interview!.insertedReserved ? '必要' : ''),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影店舗',
                          child: FormValue(
                            interview!.insertedShopName,
                            onTap: () {
                              final insertedShopNameController =
                                  TextEditingController(
                                text: interview!.insertedShopName,
                              );
                              _showTextField(
                                controller: insertedShopNameController,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'insertedShopName':
                                        insertedShopNameController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'いらっしゃる人数',
                          child: FormValue(
                            interview!.insertedVisitors,
                            onTap: () {
                              final insertedVisitorsController =
                                  TextEditingController(
                                text: interview!.insertedVisitors,
                              );
                              _showTextField(
                                controller: insertedVisitorsController,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'insertedVisitors':
                                        insertedVisitorsController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影内容・備考',
                          child: FormValue(
                            interview!.insertedContent,
                            onTap: () {
                              final insertedContentController =
                                  TextEditingController(
                                text: interview!.insertedContent,
                              );
                              _showTextField(
                                controller: insertedContentController,
                                textInputType: TextInputType.multiline,
                                onPressed: () {
                                  interviewService.update({
                                    'id': interview!.id,
                                    'insertedContent':
                                        insertedContentController.text,
                                  });
                                  _reloadRequestInterview();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Text('インサート撮影なし'),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: interview!.attachedFiles.map((file) {
                        return AttachedFileList(
                          fileName: getFileNameFromUrl(file),
                          onTap: () {
                            downloadFile(
                              url: file,
                              name: getFileNameFromUrl(file),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'その他連絡事項',
                child: FormValue(
                  interview!.remarks,
                  onTap: () {
                    final remarksController = TextEditingController(
                      text: interview!.remarks,
                    );
                    _showTextField(
                      controller: remarksController,
                      textInputType: TextInputType.multiline,
                      onPressed: () {
                        interviewService.update({
                          'id': interview!.id,
                          'remarks': remarksController.text,
                        });
                        _reloadRequestInterview();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 8),
              Container(
                color: kGreyColor.withOpacity(0.2),
                padding: const EdgeInsets.all(16),
                child: FormLabel(
                  '社内コメント',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      comments.isNotEmpty
                          ? Column(
                              children: comments.map((comment) {
                                return CommentList(comment: comment);
                              }).toList(),
                            )
                          : const ListTile(title: Text('コメントがありません')),
                      const SizedBox(height: 8),
                      CustomButton(
                        type: ButtonSizeType.sm,
                        label: 'コメント追加',
                        labelColor: kWhiteColor,
                        backgroundColor: kBlueColor,
                        onPressed: () {
                          TextEditingController commentContentController =
                              TextEditingController();
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              content: SizedBox(
                                width: 600,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: commentContentController,
                                      textInputType: TextInputType.multiline,
                                      maxLines: null,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                CustomButton(
                                  type: ButtonSizeType.sm,
                                  label: 'キャンセル',
                                  labelColor: kWhiteColor,
                                  backgroundColor: kGreyColor,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CustomButton(
                                  type: ButtonSizeType.sm,
                                  label: '追記する',
                                  labelColor: kWhiteColor,
                                  backgroundColor: kBlueColor,
                                  onPressed: () async {
                                    String? error =
                                        await interviewProvider.addComment(
                                      organization:
                                          widget.loginProvider.organization,
                                      interview: interview!,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
取材申込「${interview!.companyName}」に、社内コメントを追記しました。
コメント内容:
${commentContentController.text}
                                    ''';
                                    error = await messageProvider.sendComment(
                                      organization:
                                          widget.loginProvider.organization,
                                      content: content,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    if (error != null) {
                                      if (!mounted) return;
                                      showMessage(context, error, false);
                                      return;
                                    }
                                    _reloadComments();
                                    if (!mounted) return;
                                    showMessage(
                                        context, '社内コメントが追記されました', true);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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

class PendingRequestInterviewDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const PendingRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に保留中にしますか？'),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保留中にする',
          labelColor: kBlackColor,
          backgroundColor: kYellowColor,
          onPressed: () async {
            String? error = await interviewProvider.pending(
              organization: loginProvider.organization,
              interview: interview,
              loginUser: loginProvider.user,
            );
            if (error != null) {
              showMessage(context, error, false);
              return;
            }
            showMessage(context, '申請を保留中にしました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PendingCancelRequestInterviewDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const PendingCancelRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に保留を解除しますか？'),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保留を解除する',
          labelColor: kBlackColor,
          backgroundColor: kYellowColor,
          onPressed: () async {
            String? error = await interviewProvider.pendingCancel(
              organization: loginProvider.organization,
              interview: interview,
              loginUser: loginProvider.user,
            );
            if (error != null) {
              showMessage(context, error, false);
              return;
            }
            showMessage(context, '保留を解除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ApprovalRequestInterviewDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const ApprovalRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<ApprovalRequestInterviewDialog> createState() =>
      _ApprovalRequestInterviewDialogState();
}

class _ApprovalRequestInterviewDialogState
    extends State<ApprovalRequestInterviewDialog> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に承認しますか？'),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kApprovalColor,
          onPressed: () async {
            String? error = await interviewProvider.approval(
              organization: widget.loginProvider.organization,
              interview: widget.interview,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請が承認されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class RejectRequestInterviewDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const RejectRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<RejectRequestInterviewDialog> createState() =>
      _RejectRequestInterviewDialogState();
}

class _RejectRequestInterviewDialogState
    extends State<RejectRequestInterviewDialog> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
    return CustomAlertDialog(
      content: const SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('本当に否決しますか？'),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '否決する',
          labelColor: kWhiteColor,
          backgroundColor: kRejectColor,
          onPressed: () async {
            String? error = await interviewProvider.reject(
              organization: widget.loginProvider.organization,
              interview: widget.interview,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請が否決されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
