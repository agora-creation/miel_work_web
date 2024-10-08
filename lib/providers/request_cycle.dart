import 'package:flutter/material.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_cycle.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/request_cycle.dart';

class RequestCycleProvider with ChangeNotifier {
  final RequestCycleService _cycleService = RequestCycleService();

  Future<String?> approval({
    required RequestCycleModel cycle,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (cycle.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in cycle.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      if (loginUser.president) {
        _cycleService.update({
          'id': cycle.id,
          'approval': 1,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
      } else {
        _cycleService.update({
          'id': cycle.id,
          'approvalUsers': approvalUsers,
        });
      }
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestCycleModel cycle,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _cycleService.update({
        'id': cycle.id,
        'approval': 9,
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestCycleModel cycle,
  }) async {
    String? error;
    try {
      _cycleService.delete({
        'id': cycle.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
