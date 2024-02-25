import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/manual.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/services/manual.dart';

class ManualProvider with ChangeNotifier {
  final ManualService _manualService = ManualService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String title,
    required PlatformFile? pickedFile,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    if (organization == null) return '業務マニュアルの追加に失敗しました';
    if (title == '') return 'タイトルを入力してください';
    if (pickedFile == null) return 'PDFファイルを選択してください';
    try {
      String id = _manualService.id();
      String file = '';
      storage.UploadTask uploadTask;
      storage.Reference ref = storage.FirebaseStorage.instance
          .ref()
          .child('manual')
          .child('/$id.pdf');
      final metadata = storage.SettableMetadata(contentType: 'application/pdf');
      uploadTask = ref.putData(pickedFile.bytes!, metadata);
      await uploadTask.whenComplete(() => null);
      file = await ref.getDownloadURL();
      _manualService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'file': file,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '業務マニュアルの追加に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ManualModel manual,
  }) async {
    String? error;
    try {
      _manualService.delete({
        'id': manual.id,
      });
      await storage.FirebaseStorage.instance
          .ref()
          .child('manual')
          .child('/${manual.id}.pdf')
          .delete();
    } catch (e) {
      error = '業務マニュアルの削除に失敗しました';
    }
    return error;
  }
}
