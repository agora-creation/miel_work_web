import 'package:flutter/material.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/plan_guardsman.dart';
import 'package:miel_work_web/services/plan_guardsman.dart';

class PlanGuardsmanProvider with ChangeNotifier {
  final PlanGuardsmanService _guardsmanService = PlanGuardsmanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の追加に失敗しました';
    try {
      String id = _guardsmanService.id();
      _guardsmanService.create({
        'id': id,
        'organizationId': organization.id,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'createdAt': DateTime.now(),
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '勤務予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required PlanGuardsmanModel guardsman,
    required OrganizationModel? organization,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の編集に失敗しました';
    try {
      _guardsmanService.update({
        'id': guardsman.id,
        'organizationId': organization.id,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '勤務予定の編集に失敗しました';
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
      error = '勤務予定の削除に失敗しました';
    }
    return error;
  }
}
