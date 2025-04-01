import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/apply.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:path/path.dart' as p;

class ApplyProvider with ChangeNotifier {
  final ApplyService _applyService = ApplyService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String number,
    required String type,
    required String title,
    required String content,
    required int price,
    required PlatformFile? pickedFile,
    required PlatformFile? pickedFile2,
    required PlatformFile? pickedFile3,
    required PlatformFile? pickedFile4,
    required PlatformFile? pickedFile5,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '新規申請に失敗しました';
    if (title == '') return '件名は必須入力です';
    if (content == '') return '内容を必須入力です';
    if (loginUser == null) return '新規申請に失敗しました';
    try {
      String id = _applyService.id();
      String file = '';
      String fileExt = '';
      if (pickedFile != null) {
        String ext = p.extension(pickedFile.name);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/$id$ext');
        uploadTask = ref.putData(pickedFile.bytes!);
        await uploadTask.whenComplete(() => null);
        file = await ref.getDownloadURL();
        fileExt = ext;
      }
      String file2 = '';
      String file2Ext = '';
      if (pickedFile2 != null) {
        String ext = p.extension(pickedFile2.name);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${id}_2$ext');
        uploadTask = ref.putData(pickedFile2.bytes!);
        await uploadTask.whenComplete(() => null);
        file2 = await ref.getDownloadURL();
        file2Ext = ext;
      }
      String file3 = '';
      String file3Ext = '';
      if (pickedFile3 != null) {
        String ext = p.extension(pickedFile3.name);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${id}_3$ext');
        uploadTask = ref.putData(pickedFile3.bytes!);
        await uploadTask.whenComplete(() => null);
        file3 = await ref.getDownloadURL();
        file3Ext = ext;
      }
      String file4 = '';
      String file4Ext = '';
      if (pickedFile4 != null) {
        String ext = p.extension(pickedFile4.name);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${id}_4$ext');
        uploadTask = ref.putData(pickedFile4.bytes!);
        await uploadTask.whenComplete(() => null);
        file4 = await ref.getDownloadURL();
        file4Ext = ext;
      }
      String file5 = '';
      String file5Ext = '';
      if (pickedFile5 != null) {
        String ext = p.extension(pickedFile5.name);
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${id}_5$ext');
        uploadTask = ref.putData(pickedFile5.bytes!);
        await uploadTask.whenComplete(() => null);
        file5 = await ref.getDownloadURL();
        file5Ext = ext;
      }
      _applyService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'number': number,
        'type': type,
        'title': title,
        'content': content,
        'price': price,
        'file': file,
        'fileExt': fileExt,
        'file2': file2,
        'file2Ext': file2Ext,
        'file3': file3,
        'file3Ext': file3Ext,
        'file4': file4,
        'file4Ext': file4Ext,
        'file5': file5,
        'file5Ext': file5Ext,
        'reason': '',
        'approval': 0,
        'approvedAt': DateTime.now(),
        'approvalUsers': [],
        'approvalNumber': '',
        'approvalReason': '',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: title,
              body: '申請が提出されました',
            );
          }
        }
      }
    } catch (e) {
      error = '新規申請に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ApplyModel apply,
    required String number,
    required String type,
    required String title,
    required String content,
    required int price,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (title == '') return '件名は必須入力です';
    if (content == '') return '内容を必須入力です';
    if (loginUser == null) return '申請情報の編集に失敗しました';
    try {
      _applyService.update({
        'id': apply.id,
        'number': number,
        'type': type,
        'title': title,
        'content': content,
        'price': price,
      });
    } catch (e) {
      error = '申請情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required OrganizationModel? organization,
    required ApplyModel apply,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (apply.comments.isNotEmpty) {
        for (final comment in apply.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'createdAt': DateTime.now(),
      });
      _applyService.update({
        'id': apply.id,
        'comments': comments,
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: '『[${apply.type}申請]${apply.title}』に社内コメントが追記されました',
              body: content,
            );
          }
        }
      }
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required ApplyModel apply,
    required UserModel? loginUser,
    required String approvalNumber,
    required String approvalReason,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (apply.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in apply.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      if (loginUser.president) {
        _applyService.update({
          'id': apply.id,
          'approval': 1,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
          'approvalNumber': approvalNumber,
          'approvalReason': approvalReason,
        });
        //通知
        List<UserModel> sendUsers = [];
        sendUsers = await _userService.selectList(
          userIds: [apply.createdUserId],
        );
        if (sendUsers.isNotEmpty) {
          for (UserModel user in sendUsers) {
            if (user.id == loginUser.id) continue;
            for (final token in user.tokens) {
              _fmService.send(
                token: token,
                title: apply.title,
                body: '申請が承認されました',
              );
            }
          }
        }
      } else {
        _applyService.update({
          'id': apply.id,
          'approvalUsers': approvalUsers,
          'approvalNumber': approvalNumber,
          'approvalReason': approvalReason,
        });
      }
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required ApplyModel apply,
    required String reason,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _applyService.update({
        'id': apply.id,
        'reason': reason,
        'approval': 9,
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: [apply.createdUserId],
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: apply.title,
              body: '申請が否決されました。',
            );
          }
        }
      }
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }
}
