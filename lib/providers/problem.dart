import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/problem.dart';
import 'package:miel_work_web/services/user.dart';

class ProblemProvider with ChangeNotifier {
  final ProblemService _problemService = ProblemService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String type,
    required DateTime createdAt,
    required String picName,
    required String targetName,
    required String targetAge,
    required String targetTel,
    required String targetAddress,
    required String details,
    required List<String> states,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'クレーム／要望の追加に失敗しました';
    if (type == '') return '対応項目を選択してください';
    if (picName == '') return '対応者を入力してください';
    if (loginUser == null) return 'クレーム／要望の追加に失敗しました';
    try {
      String id = _problemService.id();
      _problemService.create({
        'id': id,
        'organizationId': organization.id,
        'type': type,
        'picName': picName,
        'targetName': targetName,
        'targetAge': targetAge,
        'targetTel': targetTel,
        'targetAddress': targetAddress,
        'details': details,
        'image': '',
        'states': states,
        'readUserIds': [loginUser.id],
        'createdAt': createdAt,
        'expirationAt': createdAt.add(const Duration(days: 365)),
      });
      //通知
      // List<UserModel> sendUsers = await _userService.selectList(
      //   userIds: organization.userIds,
      // );
      // if (sendUsers.isNotEmpty) {
      //   for (UserModel user in sendUsers) {
      //     if (user.id == loginUser.id) continue;
      //     _fmService.send(
      //       token: user.token,
      //       title: 'クレーム／要望が報告されました',
      //       body: details,
      //     );
      //   }
      // }
    } catch (e) {
      error = 'クレーム／要望の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required ProblemModel problem,
    required String type,
    required DateTime createdAt,
    required String picName,
    required String targetName,
    required String targetAge,
    required String targetTel,
    required String targetAddress,
    required String details,
    required List<String> states,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return 'クレーム／要望の編集に失敗しました';
    if (type == '') return '対応項目を選択してください';
    if (picName == '') return '対応者を入力してください';
    if (loginUser == null) return 'クレーム／要望の編集に失敗しました';
    try {
      _problemService.update({
        'id': problem.id,
        'type': type,
        'picName': picName,
        'targetName': targetName,
        'targetAge': targetAge,
        'targetTel': targetTel,
        'targetAddress': targetAddress,
        'details': details,
        'image': '',
        'states': states,
        'createdAt': createdAt,
        'expirationAt': createdAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = 'クレーム／要望の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ProblemModel problem,
  }) async {
    String? error;
    try {
      _problemService.delete({
        'id': problem.id,
      });
    } catch (e) {
      error = 'クレーム／要望の削除に失敗しました';
    }
    return error;
  }
}
