import 'package:flutter/material.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/request_overtime.dart';

class RequestOvertimeProvider with ChangeNotifier {
  final RequestOvertimeService _overtimeService = RequestOvertimeService();

  Future<String?> approval({
    required RequestOvertimeModel overtime,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (overtime.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in overtime.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      _overtimeService.update({
        'id': overtime.id,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestOvertimeModel overtime,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _overtimeService.update({
        'id': overtime.id,
        'approval': 9,
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestOvertimeModel overtime,
  }) async {
    String? error;
    try {
      _overtimeService.delete({
        'id': overtime.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
