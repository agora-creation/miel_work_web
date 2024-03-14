import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/apply_proposal.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/apply_proposal.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/user.dart';

class ApplyProposalProvider with ChangeNotifier {
  final ApplyProposalService _proposalService = ApplyProposalService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String title,
    required String content,
    required int price,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '稟議申請に失敗しました';
    if (title == '') return '件名を入力してください';
    if (content == '') return '内容を入力してください';
    if (loginUser == null) return '稟議申請に失敗しました';
    try {
      String id = _proposalService.id();
      _proposalService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'price': price,
        'approval': false,
        'approvedAt': DateTime.now(),
        'approvalUsers': [],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: title,
            body: '稟議申請が提出されました。',
          );
        }
      }
    } catch (e) {
      error = '稟議申請に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ApplyProposalModel proposal,
    required bool approval,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (proposal.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in proposal.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'approvedAt': DateTime.now(),
      });
      if (approval) {
        _proposalService.update({
          'id': proposal.id,
          'approval': approval,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
      } else {
        _proposalService.update({
          'id': proposal.id,
          'approval': approval,
          'approvalUsers': approvalUsers,
        });
      }
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: [proposal.createdUserId],
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: proposal.title,
            body: '稟議申請が承認されました。',
          );
        }
      }
    } catch (e) {
      error = '承認に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ApplyProposalModel proposal,
  }) async {
    String? error;
    try {
      _proposalService.delete({
        'id': proposal.id,
      });
    } catch (e) {
      error = '稟議申請の削除に失敗しました';
    }
    return error;
  }
}
