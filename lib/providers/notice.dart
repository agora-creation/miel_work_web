import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/notice.dart';
import 'package:miel_work_web/services/user.dart';

class NoticeProvider with ChangeNotifier {
  final NoticeService _noticeService = NoticeService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required String title,
    required String content,
    required PlatformFile? pickedFile,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    if (organization == null) return 'お知らせの作成に失敗しました';
    if (title == '') return 'タイトルを入力してください';
    if (content == '') return 'お知らせ内容を入力してください';
    try {
      String id = _noticeService.id();
      String file = '';
      if (pickedFile != null) {
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/$id.pdf');
        final metadata =
            storage.SettableMetadata(contentType: 'application/pdf');
        uploadTask = ref.putData(pickedFile.bytes!, metadata);
        await uploadTask.whenComplete(() => null);
        file = await ref.getDownloadURL();
      }
      _noticeService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'file': file,
        'createdAt': DateTime.now(),
      });
      if (group != null) {
        List<UserModel> sendUsers = await _userService.selectList(
          userIds: group.userIds,
        );
        if (sendUsers.isNotEmpty) {
          for (UserModel user in sendUsers) {
            _fmService.send(
              token: user.token,
              title: title,
              body: content,
            );
          }
        }
      }
    } catch (e) {
      error = 'お知らせの作成に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required NoticeModel notice,
  }) async {
    String? error;
    try {
      _noticeService.delete({
        'id': notice.id,
      });
      if (notice.file != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/${notice.id}.pdf')
            .delete();
      }
    } catch (e) {
      error = 'お知らせの削除に失敗しました';
    }
    return error;
  }
}
