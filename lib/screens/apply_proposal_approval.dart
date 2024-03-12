import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_proposal.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/providers/apply_proposal.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_approval_user_list.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:provider/provider.dart';

class ApplyProposalApprovalScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProposalModel proposal;

  const ApplyProposalApprovalScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.proposal,
    super.key,
  });

  @override
  State<ApplyProposalApprovalScreen> createState() =>
      _ApplyProposalApprovalScreenState();
}

class _ApplyProposalApprovalScreenState
    extends State<ApplyProposalApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    final proposalProvider = Provider.of<ApplyProposalProvider>(context);
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
                '稟議申請を承認',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '承認する',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () async {
                  String? error = await proposalProvider.update(
                    proposal: widget.proposal,
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
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        padding: const EdgeInsets.all(16),
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
                      '提出日: ${dateText('yyyy/MM/dd HH:mm', widget.proposal.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    Text(
                      '作成者: ${widget.proposal.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              InfoLabel(
                label: '承認者一覧',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  height: 150,
                  child: widget.proposal.approvalUsers.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.proposal.approvalUsers.length,
                          itemBuilder: (context, index) {
                            ApprovalUserModel approvalUser =
                                widget.proposal.approvalUsers[index];
                            return CustomApprovalUserList(
                                approvalUser: approvalUser);
                          },
                        )
                      : const Center(child: Text('承認者はいません')),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
