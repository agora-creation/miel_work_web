import 'package:flutter/material.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_facility.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/request_facility.dart';

class RequestFacilityProvider with ChangeNotifier {
  final RequestFacilityService _facilityService = RequestFacilityService();

  Future<String?> approval({
    required RequestFacilityModel facility,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (facility.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in facility.approvalUsers) {
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
        _facilityService.update({
          'id': facility.id,
          'approval': 1,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
      } else {
        _facilityService.update({
          'id': facility.id,
          'approvalUsers': approvalUsers,
        });
      }
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestFacilityModel facility,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _facilityService.update({
        'id': facility.id,
        'approval': 9,
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestFacilityModel facility,
  }) async {
    String? error;
    try {
      _facilityService.delete({
        'id': facility.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
