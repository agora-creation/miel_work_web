import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fluent_ui/fluent_ui.dart';
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
    if (organization == null) return '申請に失敗しました';
    if (title == '') return '件名を入力してください';
    if (content == '') return '内容を入力してください';
    if (loginUser == null) return '申請に失敗しました';
    try {
      String id = _applyService.id();
      String file = '';
      String fileExt = '';
      if (pickedFile != null) {
        String ext = p.extension(pickedFile.path ?? '');
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
        String ext = p.extension(pickedFile2.path ?? '');
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
        String ext = p.extension(pickedFile3.path ?? '');
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
        String ext = p.extension(pickedFile4.path ?? '');
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
        String ext = p.extension(pickedFile5.path ?? '');
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
          _fmService.send(
            token: user.token,
            title: title,
            body: '申請が提出されました。',
          );
        }
      }
    } catch (e) {
      error = '申請に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required ApplyModel apply,
    required UserModel? loginUser,
    required String approvalNumber,
  }) async {
    String? error;
    if (loginUser == null) return '承認に失敗しました';
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
        });
        //通知
        List<UserModel> sendUsers = [];
        sendUsers = await _userService.selectList(
          userIds: [apply.createdUserId],
        );
        if (sendUsers.isNotEmpty) {
          for (UserModel user in sendUsers) {
            if (user.id == loginUser.id) continue;
            _fmService.send(
              token: user.token,
              title: apply.title,
              body: '申請が承認されました。',
            );
          }
        }
      } else {
        _applyService.update({
          'id': apply.id,
          'approvalUsers': approvalUsers,
          'approvalNumber': approvalNumber,
        });
      }
    } catch (e) {
      error = '承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required ApplyModel apply,
    required String reason,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '否決に失敗しました';
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
          _fmService.send(
            token: user.token,
            title: apply.title,
            body: '申請が否決されました。',
          );
        }
      }
    } catch (e) {
      error = '否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ApplyModel apply,
  }) async {
    String? error;
    try {
      _applyService.delete({
        'id': apply.id,
      });
      if (apply.file != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${apply.id}${apply.fileExt}')
            .delete();
      }
      if (apply.file2 != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${apply.id}_2${apply.file2Ext}')
            .delete();
      }
      if (apply.file3 != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${apply.id}_3${apply.file3Ext}')
            .delete();
      }
      if (apply.file4 != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${apply.id}_4${apply.file4Ext}')
            .delete();
      }
      if (apply.file5 != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('apply')
            .child('/${apply.id}_5${apply.file5Ext}')
            .delete();
      }
    } catch (e) {
      error = '申請の削除に失敗しました';
    }
    return error;
  }
}
