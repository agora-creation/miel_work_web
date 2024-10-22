import 'package:flutter/material.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/plan_guardsman.dart';
import 'package:miel_work_web/services/plan_guardsman.dart';

class PlanGuardsmanProvider with ChangeNotifier {
  final PlanGuardsmanService _guardsmanService = PlanGuardsmanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String content,
    required DateTime eventAt,
  }) async {
    String? error;
    if (organization == null) return '警備員予定の追加に失敗しました';
    if (content == '') return '内容は必須入力です';
    try {
      String id = _guardsmanService.id();
      _guardsmanService.create({
        'id': id,
        'organizationId': organization.id,
        'content': content,
        'eventAt': eventAt,
        'createdAt': DateTime.now(),
        'expirationAt': eventAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '警備員予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanGuardsmanModel guardsman,
    required OrganizationModel? organization,
    required String content,
    required DateTime eventAt,
  }) async {
    String? error;
    if (organization == null) return '警備員予定の編集に失敗しました';
    if (content == '') return '内容は必須入力です';
    try {
      _guardsmanService.update({
        'id': guardsman.id,
        'organizationId': organization.id,
        'content': content,
        'eventAt': eventAt,
        'expirationAt': eventAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '警備員予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required PlanGuardsmanModel guardsman,
  }) async {
    String? error;
    try {
      _guardsmanService.delete({
        'id': guardsman.id,
      });
    } catch (e) {
      error = '警備員予定の削除に失敗しました';
    }
    return error;
  }
}
