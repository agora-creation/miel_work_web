import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/plan.dart';

class PlanProvider with ChangeNotifier {
  final PlanService _planService = PlanService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String subject,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required String memo,
    required PlatformFile? pickedFile,
    required OrganizationGroupModel? group,
    required List<UserModel> users,
  }) async {
    String? error;
    if (organization == null) return '予定の追加に失敗しました';
    if (subject == '') return '件名を入力してください';
    try {
      String id = _planService.id();
      String file = '';
      if (pickedFile != null) {
        String extension = pickedFile.extension ?? '.txt';
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('plan')
            .child('/$id$extension');
        uploadTask = ref.putData(pickedFile.bytes!);
        await uploadTask.whenComplete(() => null);
        file = await ref.getDownloadURL();
      }
      _planService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': [],
        'subject': subject,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': false,
        'memo': memo,
        'file': file,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '予定の追加に失敗しました';
    }
    return error;
  }
}
