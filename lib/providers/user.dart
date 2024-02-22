import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/organization.dart';
import 'package:miel_work_web/services/organization_group.dart';
import 'package:miel_work_web/services/user.dart';

class UserProvider with ChangeNotifier {
  final OrganizationService _organizationService = OrganizationService();
  final OrganizationGroupService _groupService = OrganizationGroupService();
  final UserService _userService = UserService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String name,
    required String email,
    required String password,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    if (organization == null) return 'スタッフの追加に失敗しました';
    if (name == '') return 'スタッフ名を入力してください';
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    if (await _userService.emailCheck(email: email)) {
      return '他のメールアドレスを入力してください';
    }
    try {
      String id = _userService.id();
      _userService.create({
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'uid': '',
        'token': '',
        'createdAt': DateTime.now(),
      });
      List<String> orgUserIds = organization.userIds;
      if (!orgUserIds.contains(id)) {
        orgUserIds.add(id);
      }
      _organizationService.update({
        'id': organization.id,
        'userIds': orgUserIds,
      });
      if (group != null) {
        List<String> groupUserIds = group.userIds;
        if (!groupUserIds.contains(id)) {
          groupUserIds.add(id);
        }
        _groupService.update({
          'id': group.id,
          'organizationId': group.organizationId,
          'userIds': groupUserIds,
        });
      }
    } catch (e) {
      error = 'スタッフの追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required UserModel user,
    required String name,
    required String email,
    required String password,
    required OrganizationGroupModel? befGroup,
    required OrganizationGroupModel? aftGroup,
  }) async {
    String? error;
    if (name == '') return 'スタッフ名を入力してください';
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    if (await _userService.emailCheck(email: email)) {
      return '他のメールアドレスを入力してください';
    }
    try {
      _userService.update({
        'id': user.id,
        'name': name,
        'email': email,
        'password': password,
      });
      if (befGroup != aftGroup) {
        if (befGroup != null) {
          List<String> befGroupUserIds = befGroup.userIds;
          if (befGroupUserIds.contains(user.id)) {
            befGroupUserIds.remove(user.id);
          }
          _groupService.update({
            'id': befGroup.id,
            'organizationId': befGroup.organizationId,
            'userIds': befGroupUserIds,
          });
        }
        if (aftGroup != null) {
          List<String> aftGroupUserIds = aftGroup.userIds;
          if (!aftGroupUserIds.contains(user.id)) {
            aftGroupUserIds.add(user.id);
          }
          _groupService.update({
            'id': aftGroup.id,
            'organizationId': aftGroup.organizationId,
            'userIds': aftGroupUserIds,
          });
        }
      }
    } catch (e) {
      error = 'スタッフ情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required UserModel user,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    try {
      _userService.delete({
        'id': user.id,
      });
      if (group != null) {
        List<String> groupUserIds = group.userIds;
        if (groupUserIds.contains(user.id)) {
          groupUserIds.remove(user.id);
        }
        _groupService.update({
          'id': group.id,
          'organizationId': group.organizationId,
          'userIds': groupUserIds,
        });
      }
    } catch (e) {
      error = 'スタッフの削除に失敗しました';
    }
    return error;
  }
}
