import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/services/plan.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService = PlanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String title,
    required String content,
    required PlatformFile? pickedFile,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    if (organization == null) return '予定の追加に失敗しました';
    try {} catch (e) {
      error = '予定の追加に失敗しました';
    }
    return error;
  }
}
