import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/services/plan_shift.dart';

class PlanShiftProvider with ChangeNotifier {
  final PlanShiftService _planShiftService = PlanShiftService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required List<String> userIds,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required int alertMinute,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の追加に失敗しました';
    if (userIds.isEmpty) return '勤務予定の追加に失敗しました';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      String id = _planShiftService.id();
      _planShiftService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': userIds,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '勤務予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required String planShiftId,
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required List<String> userIds,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required int alertMinute,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の編集に失敗しました';
    if (userIds.isEmpty) return '勤務予定の編集に失敗しました';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      _planShiftService.update({
        'id': planShiftId,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': userIds,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
      });
    } catch (e) {
      error = '勤務予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required String planShiftId,
  }) async {
    String? error;
    try {
      _planShiftService.delete({
        'id': planShiftId,
      });
    } catch (e) {
      error = '勤務予定の削除に失敗しました';
    }
    return error;
  }
}
