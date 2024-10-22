import 'package:flutter/material.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/plan_center.dart';
import 'package:miel_work_web/services/plan_center.dart';

class PlanCenterProvider with ChangeNotifier {
  final PlanCenterService _centerService = PlanCenterService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String content,
    required DateTime eventAt,
  }) async {
    String? error;
    if (organization == null) return '食器センター予定の追加に失敗しました';
    if (content == '') return '内容は必須入力です';
    try {
      String id = _centerService.id();
      _centerService.create({
        'id': id,
        'organizationId': organization.id,
        'content': content,
        'eventAt': eventAt,
        'createdAt': DateTime.now(),
        'expirationAt': eventAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '食器センター予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanCenterModel center,
    required OrganizationModel? organization,
    required String content,
    required DateTime eventAt,
  }) async {
    String? error;
    if (organization == null) return '食器センター予定の編集に失敗しました';
    if (content == '') return '内容は必須入力です';
    try {
      _centerService.update({
        'id': center.id,
        'organizationId': organization.id,
        'content': content,
        'eventAt': eventAt,
        'expirationAt': eventAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '食器センター予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required PlanCenterModel center,
  }) async {
    String? error;
    try {
      _centerService.delete({
        'id': center.id,
      });
    } catch (e) {
      error = '食器センター予定の削除に失敗しました';
    }
    return error;
  }
}
