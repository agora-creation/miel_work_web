import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/request_const.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/log.dart';
import 'package:miel_work_web/services/mail.dart';
import 'package:miel_work_web/services/request_const.dart';

class RequestConstProvider with ChangeNotifier {
  final RequestConstService _constService = RequestConstService();
  final MailService _mailService = MailService();
  final LogService _logService = LogService();

  Future<String?> addComment({
    required OrganizationModel? organization,
    required RequestConstModel requestConst,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (requestConst.comments.isNotEmpty) {
        for (final comment in requestConst.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'readUserIds': [loginUser.id],
        'createdAt': DateTime.now(),
      });
      _constService.update({
        'id': requestConst.id,
        'comments': comments,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '社外申請:店舗工事作業申請に社内コメントを追記しました。',
        'device': 'PC(ブラウザ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> pending({
    required OrganizationModel? organization,
    required RequestConstModel requestConst,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請情報の更新に失敗しました';
    if (loginUser == null) return '申請情報の更新に失敗しました';
    try {
      _constService.update({
        'id': requestConst.id,
        'pending': true,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '社外申請:店舗工事作業申請を保留中にしました。',
        'device': 'PC(ブラウザ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '申請情報の更新に失敗しました';
    }
    return error;
  }

  Future<String?> pendingCancel({
    required OrganizationModel? organization,
    required RequestConstModel requestConst,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請情報の更新に失敗しました';
    if (loginUser == null) return '申請情報の更新に失敗しました';
    try {
      _constService.update({
        'id': requestConst.id,
        'pending': false,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '社外申請:店舗工事作業申請の保留中を解除しました。',
        'device': 'PC(ブラウザ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '申請情報の更新に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required OrganizationModel? organization,
    required RequestConstModel requestConst,
    required bool meeting,
    required DateTime meetingAt,
    required String caution,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請の承認に失敗しました';
    if (caution == '') return '注意事項を入力してください';
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (requestConst.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in requestConst.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      _constService.update({
        'id': requestConst.id,
        'meeting': meeting,
        'meetingAt': meetingAt,
        'caution': caution,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
      String constAtText = '';
      if (requestConst.constAtPending) {
        constAtText = '未定';
      } else {
        constAtText =
            '${dateText('yyyy/MM/dd HH:mm', requestConst.constStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', requestConst.constEndedAt)}';
      }
      String noiseText = '';
      if (requestConst.noise) {
        noiseText = '有(${requestConst.noiseMeasures})';
      }
      String dustText = '';
      if (requestConst.dust) {
        dustText = '有(${requestConst.dustMeasures})';
      }
      String fireText = '';
      if (requestConst.fire) {
        fireText = '有(${requestConst.fireMeasures})';
      }
      String attachedFilesText = '';
      if (requestConst.attachedFiles.isNotEmpty) {
        for (final file in requestConst.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String meetingText = '不要';
      if (meeting) {
        meetingText = '必要(${dateText('yyyy/MM/dd HH:mm', meetingAt)})';
      }
      String message = '''
店舗工事作業申請が承認されました。

[着工前の打ち合わせ] $meetingText
[注意事項]
$caution

以下申込内容をご確認し、作業を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申請者情報
【店舗名】${requestConst.companyName}
【店舗責任者名】${requestConst.companyUserName}
【店舗責任者メールアドレス】${requestConst.companyUserEmail}
【店舗責任者電話番号】${requestConst.companyUserTel}

■工事施工情報
【工事施工会社名】${requestConst.constName}
【工事施工代表者名】${requestConst.constUserName}
【工事施工代表者電話番号】${requestConst.constUserTel}
【当日担当者名】${requestConst.chargeUserName}
【当日担当者電話番号】${requestConst.chargeUserTel}
【施工予定日時】$constAtText
【施工内容】
${requestConst.constContent}
【騒音】$noiseText
【粉塵】$dustText
【火気の使用】$fireText

【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': requestConst.companyUserEmail,
        'subject': '店舗工事作業申請承認のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '社外申請:店舗工事作業申請を承認しました。',
        'device': 'PC(ブラウザ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required OrganizationModel? organization,
    required RequestConstModel requestConst,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請の否決に失敗しました';
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _constService.update({
        'id': requestConst.id,
        'approval': 9,
      });
      String constAtText = '';
      if (requestConst.constAtPending) {
        constAtText = '未定';
      } else {
        constAtText =
            '${dateText('yyyy/MM/dd HH:mm', requestConst.constStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', requestConst.constEndedAt)}';
      }
      String noiseText = '';
      if (requestConst.noise) {
        noiseText = '有(${requestConst.noiseMeasures})';
      }
      String dustText = '';
      if (requestConst.dust) {
        dustText = '有(${requestConst.dustMeasures})';
      }
      String fireText = '';
      if (requestConst.fire) {
        fireText = '有(${requestConst.fireMeasures})';
      }
      String attachedFilesText = '';
      if (requestConst.attachedFiles.isNotEmpty) {
        for (final file in requestConst.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String message = '''
店舗工事作業申請が否決されました。
以下申込内容をご確認し、再度申請を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申請者情報
【店舗名】${requestConst.companyName}
【店舗責任者名】${requestConst.companyUserName}
【店舗責任者メールアドレス】${requestConst.companyUserEmail}
【店舗責任者電話番号】${requestConst.companyUserTel}

■工事施工情報
【工事施工会社名】${requestConst.constName}
【工事施工代表者名】${requestConst.constUserName}
【工事施工代表者電話番号】${requestConst.constUserTel}
【当日担当者名】${requestConst.chargeUserName}
【当日担当者電話番号】${requestConst.chargeUserTel}
【施工予定日時】$constAtText
【施工内容】
${requestConst.constContent}
【騒音】$noiseText
【粉塵】$dustText
【火気の使用】$fireText

【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': requestConst.companyUserEmail,
        'subject': '店舗工事作業申請否決のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '社外申請:店舗工事作業申請を否決しました。',
        'device': 'PC(ブラウザ)',
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }
}
