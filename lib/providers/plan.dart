import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/category.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/services/plan.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService = PlanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required CategoryModel? category,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required String memo,
    required int alertMinute,
  }) async {
    String? error;
    if (organization == null) return '予定の追加に失敗しました';
    if (category == null) return 'カテゴリを選択してください';
    if (subject == '') return '件名を入力してください';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      List<String> userIds = [];
      if (group != null) {
        userIds = group.userIds;
      } else {
        userIds = organization.userIds;
      }
      String id = _planService.id();
      _planService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': userIds,
        'category': category.name,
        'categoryColor': category.color.value.toRadixString(16),
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'memo': memo,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required String planId,
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required CategoryModel? category,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required String memo,
    required int alertMinute,
  }) async {
    String? error;
    if (organization == null) return '予定の編集に失敗しました';
    if (category == null) return 'カテゴリを選択してください';
    if (subject == '') return '件名を入力してください';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      List<String> userIds = [];
      if (group != null) {
        userIds = group.userIds;
      } else {
        userIds = organization.userIds;
      }
      _planService.update({
        'id': planId,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': userIds,
        'category': category.name,
        'categoryColor': category.color.value.toRadixString(16),
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'memo': memo,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
      });
    } catch (e) {
      error = '予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required String planId,
  }) async {
    String? error;
    try {
      _planService.delete({
        'id': planId,
      });
    } catch (e) {
      error = '予定の削除に失敗しました';
    }
    return error;
  }
}
