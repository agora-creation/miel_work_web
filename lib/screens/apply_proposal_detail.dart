import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_proposal.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/providers/apply_proposal.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_proposal_add.dart';
import 'package:miel_work_web/widgets/custom_approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class ApplyProposalDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProposalModel proposal;

  const ApplyProposalDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.proposal,
    super.key,
  });

  @override
  State<ApplyProposalDetailScreen> createState() =>
      _ApplyProposalDetailScreenState();
}

class _ApplyProposalDetailScreenState extends State<ApplyProposalDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final proposalProvider = Provider.of<ApplyProposalProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    bool isApply = false;
    bool isDelete = true;
    if (widget.proposal.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
      if (widget.proposal.approval == 9) {
        isApply = true;
      }
    } else {
      isDelete = false;
    }
    if (widget.proposal.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.proposal.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.proposal.approval == 1 || widget.proposal.approval == 9) {
      isApproval = false;
      isReject = false;
      isDelete = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.proposal.approvalUsers;
    List<ApprovalUserModel> reApprovalUsers = approvalUsers.reversed.toList();
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
                '稟議申請詳細',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  isReject
                      ? CustomButtonSm(
                          icon: FluentIcons.clear,
                          labelText: '否決する',
                          labelColor: kRedColor,
                          backgroundColor: kRed100Color,
                          onPressed: () async {
                            String? error = await proposalProvider.reject(
                              proposal: widget.proposal,
                              loginUser: widget.loginProvider.user,
                            );
                            if (error != null) {
                              if (!mounted) return;
                              showMessage(context, error, false);
                              return;
                            }
                            if (!mounted) return;
                            showMessage(context, '否決しました', true);
                            Navigator.pop(context);
                          },
                        )
                      : Container(),
                  const SizedBox(width: 4),
                  isApproval
                      ? CustomButtonSm(
                          icon: FluentIcons.circle_ring,
                          labelText: '承認する',
                          labelColor: kWhiteColor,
                          backgroundColor: kRedColor,
                          onPressed: () async {
                            String? error = await proposalProvider.approval(
                              proposal: widget.proposal,
                              loginUser: widget.loginProvider.user,
                            );
                            if (error != null) {
                              if (!mounted) return;
                              showMessage(context, error, false);
                              return;
                            }
                            if (!mounted) return;
                            showMessage(context, '承認しました', true);
                            Navigator.pop(context);
                          },
                        )
                      : Container(),
                  const SizedBox(width: 4),
                  isApply
                      ? CustomButtonSm(
                          labelText: '再申請する',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () => Navigator.push(
                            context,
                            FluentPageRoute(
                              builder: (context) => ApplyProposalAddScreen(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                proposal: widget.proposal,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
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
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '提出日時: ${dateText('yyyy/MM/dd HH:mm', widget.proposal.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    widget.proposal.approval == 1
                        ? Text(
                            '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.proposal.approvedAt)}',
                            style: const TextStyle(color: kGreyColor),
                          )
                        : Container(),
                    Text(
                      '作成者: ${widget.proposal.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              widget.proposal.approvalUsers.isNotEmpty
                  ? InfoLabel(
                      label: '承認者一覧',
                      child: Container(
                        color: kRed100Color,
                        width: double.infinity,
                        child: Column(
                          children: reApprovalUsers.map((approvalUser) {
                            return CustomApprovalUserList(
                              approvalUser: approvalUser,
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              InfoLabel(
                label: '件名',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.proposal.title),
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '金額',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text('¥ ${widget.proposal.formatPrice()}'),
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '内容',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.proposal.content),
                ),
              ),
              const SizedBox(height: 8),
              widget.proposal.file != ''
                  ? LinkText(
                      label: '添付ファイル',
                      color: kBlueColor,
                      onTap: () {
                        File file = File(widget.proposal.file);
                        downloadFile(
                          url: widget.proposal.file,
                          name: p.basename(file.path),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 16),
              isDelete
                  ? LinkText(
                      label: 'この稟議申請を削除する',
                      color: kRedColor,
                      onTap: () async {
                        String? error = await proposalProvider.delete(
                          proposal: widget.proposal,
                        );
                        if (error != null) {
                          if (!mounted) return;
                          showMessage(context, error, false);
                          return;
                        }
                        if (!mounted) return;
                        showMessage(context, '稟議申請を削除しました', true);
                        Navigator.pop(context);
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
