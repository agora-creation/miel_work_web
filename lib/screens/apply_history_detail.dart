import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/approval_user_list.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:path/path.dart' as p;

class ApplyHistoryDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const ApplyHistoryDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<ApplyHistoryDetailScreen> createState() =>
      _ApplyHistoryDetailScreenState();
}

class _ApplyHistoryDetailScreenState extends State<ApplyHistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    List<ApprovalUserModel> approvalUsers = widget.apply.approvalUsers;
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
          '申請情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '申請日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.createdAt)}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '申請番号: ${widget.apply.number}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '申請者: ${widget.apply.createdUserName}',
                    style: const TextStyle(color: kGreyColor),
                  ),
                  Text(
                    '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.approvedAt)}',
                    style: const TextStyle(color: kRedColor),
                  ),
                  Text(
                    '承認番号: ${widget.apply.approvalNumber}',
                    style: const TextStyle(color: kRedColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FormLabel(
                '承認者一覧',
                child: Container(
                  color: kRed100Color,
                  width: double.infinity,
                  child: Column(
                    children: reApprovalUsers.map((approvalUser) {
                      return ApprovalUserList(approvalUser: approvalUser);
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FormLabel(
                '申請種別',
                child: Chip(
                  label: Text('${widget.apply.type}申請'),
                  backgroundColor: widget.apply.typeColor(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '件名',
                child: FormValue(widget.apply.title),
              ),
              const SizedBox(height: 8),
              widget.apply.type == '稟議' || widget.apply.type == '支払伺い'
                  ? FormLabel(
                      '金額',
                      child: FormValue('¥ ${widget.apply.formatPrice()}'),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '内容',
                child: FormValue(widget.apply.content),
              ),
              const SizedBox(height: 8),
              widget.apply.approvalReason != ''
                  ? FormLabel(
                      '承認理由',
                      child: FormValue(widget.apply.approvalReason),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.reason != ''
                  ? FormLabel(
                      '否決理由',
                      child: FormValue(widget.apply.reason),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル',
                child: widget.apply.file != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(widget.apply.file);
                          downloadFile(
                            url: widget.apply.file,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル2',
                child: widget.apply.file2 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(widget.apply.file2);
                          downloadFile(
                            url: widget.apply.file2,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル3',
                child: widget.apply.file3 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(widget.apply.file3);
                          downloadFile(
                            url: widget.apply.file3,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル4',
                child: widget.apply.file4 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(widget.apply.file4);
                          downloadFile(
                            url: widget.apply.file4,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル5',
                child: widget.apply.file5 != ''
                    ? LinkText(
                        label: '確認する',
                        color: kBlueColor,
                        onTap: () {
                          File file = File(widget.apply.file5);
                          downloadFile(
                            url: widget.apply.file5,
                            name: p.basename(file.path),
                          );
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
