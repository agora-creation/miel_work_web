import 'dart:io';

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
import 'package:path/path.dart' as p;

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
        String extension = pickedFile.extension ?? 'txt';
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/$id.$extension');
        uploadTask = ref.putData(pickedFile.bytes!);
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
        'readUserIds': [],
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

  Future<String?> update({
    required NoticeModel notice,
    required String title,
    required String content,
    required PlatformFile? pickedFile,
    required OrganizationGroupModel? group,
  }) async {
    String? error;
    if (title == '') return 'タイトルを入力してください';
    if (content == '') return 'お知らせ内容を入力してください';
    try {
      if (pickedFile != null) {
        String extension = pickedFile.extension ?? 'txt';
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/${notice.id}.$extension');
        uploadTask = ref.putData(pickedFile.bytes!);
        await uploadTask.whenComplete(() => null);
      }
      _noticeService.update({
        'id': notice.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
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
              body: 'お知らせを編集しました',
            );
          }
        }
      }
    } catch (e) {
      error = 'お知らせの編集に失敗しました';
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
        File file = File(notice.file);
        String extension = p.extension(file.path);
        await storage.FirebaseStorage.instance
            .ref()
            .child('notice')
            .child('/${notice.id}.$extension')
            .delete();
      }
    } catch (e) {
      error = 'お知らせの削除に失敗しました';
    }
    return error;
  }
}
