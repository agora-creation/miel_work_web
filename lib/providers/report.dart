import 'package:flutter/material.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/report.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/report.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime createdAt,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '日報の保存に失敗しました';
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      String id = _reportService.id();
      _reportService.create({
        'id': id,
        'organizationId': organization.id,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': createdAt,
        'expirationAt': createdAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ReportModel report,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      _reportService.update({
        'id': report.id,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ReportModel report,
  }) async {
    String? error;
    try {
      _reportService.delete({
        'id': report.id,
      });
    } catch (e) {
      error = '日報の削除に失敗しました';
    }
    return error;
  }
}
