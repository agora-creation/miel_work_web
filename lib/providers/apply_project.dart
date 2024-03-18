import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/apply_project.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/apply_project.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:path/path.dart' as p;

class ApplyProjectProvider with ChangeNotifier {
  final ApplyProjectService _projectService = ApplyProjectService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String title,
    required String content,
    required PlatformFile? pickedFile,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '企画申請に失敗しました';
    if (title == '') return '件名を入力してください';
    if (content == '') return '内容を入力してください';
    if (loginUser == null) return '企画申請に失敗しました';
    try {
      String id = _projectService.id();
      String file = '';
      String fileExt = '';
      if (pickedFile != null) {
        String ext = p.extension(pickedFile.path ?? '');
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('applyProject')
            .child('/$id$ext');
        uploadTask = ref.putData(pickedFile.bytes!);
        await uploadTask.whenComplete(() => null);
        file = await ref.getDownloadURL();
        fileExt = ext;
      }
      _projectService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'title': title,
        'content': content,
        'file': file,
        'fileExt': fileExt,
        'approval': 0,
        'approvedAt': DateTime.now(),
        'approvalUsers': [],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
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
            body: '企画申請が提出されました。',
          );
        }
      }
    } catch (e) {
      error = '企画申請に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ApplyProjectModel project,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (project.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in project.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userAdmin': true,
        'approvedAt': DateTime.now(),
      });
      _projectService.update({
        'id': project.id,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: [project.createdUserId],
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: project.title,
            body: '企画申請が承認されました。',
          );
        }
      }
    } catch (e) {
      error = '承認に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ApplyProjectModel project,
  }) async {
    String? error;
    try {
      _projectService.delete({
        'id': project.id,
      });
      if (project.file != '') {
        await storage.FirebaseStorage.instance
            .ref()
            .child('applyProject')
            .child('/${project.id}${project.fileExt}')
            .delete();
      }
    } catch (e) {
      error = '企画申請の削除に失敗しました';
    }
    return error;
  }
}
