import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_conference.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/providers/apply_conference.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:provider/provider.dart';

class ApplyConferenceDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyConferenceModel conference;

  const ApplyConferenceDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.conference,
    super.key,
  });

  @override
  State<ApplyConferenceDetailScreen> createState() =>
      _ApplyConferenceDetailScreenState();
}

class _ApplyConferenceDetailScreenState
    extends State<ApplyConferenceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);
    bool isApproval = true;
    bool isDelete = true;
    if (widget.conference.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
    } else {
      isDelete = false;
    }
    if (widget.conference.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.conference.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
        }
      }
    }
    if (widget.conference.approval) {
      isApproval = false;
      isDelete = false;
    }
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
                '協議申請詳細',
                style: TextStyle(fontSize: 16),
              ),
              isApproval
                  ? CustomButtonSm(
                      labelText: '承認する',
                      labelColor: kWhiteColor,
                      backgroundColor: kRedColor,
                      onPressed: () async {
                        String? error = await conferenceProvider.update(
                          conference: widget.conference,
                          approval: true,
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
                      '提出日時: ${dateText('yyyy/MM/dd HH:mm', widget.conference.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    widget.conference.approval
                        ? Text(
                            '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.conference.approvedAt)}',
                            style: const TextStyle(color: kGreyColor),
                          )
                        : Container(),
                    Text(
                      '作成者: ${widget.conference.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              widget.conference.approvalUsers.isNotEmpty
                  ? InfoLabel(
                      label: '承認者一覧',
                      child: Container(
                        color: kRed100Color,
                        width: double.infinity,
                        child: Column(
                          children: widget.conference.approvalUsers
                              .map((approvalUser) {
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
                  child: Text(widget.conference.title),
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '内容',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.conference.content),
                ),
              ),
              const SizedBox(height: 16),
              isDelete
                  ? LinkText(
                      label: 'この協議申請を削除する',
                      color: kRedColor,
                      onTap: () async {
                        String? error = await conferenceProvider.delete(
                          conference: widget.conference,
                        );
                        if (error != null) {
                          if (!mounted) return;
                          showMessage(context, error, false);
                          return;
                        }
                        if (!mounted) return;
                        showMessage(context, '協議申請を削除しました', true);
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
