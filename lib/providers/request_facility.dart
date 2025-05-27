import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/request_facility.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/log.dart';
import 'package:miel_work_web/services/mail.dart';
import 'package:miel_work_web/services/request_facility.dart';

class RequestFacilityProvider with ChangeNotifier {
  final RequestFacilityService _facilityService = RequestFacilityService();
  final MailService _mailService = MailService();
  final LogService _logService = LogService();

  Future<String?> addComment({
    required OrganizationModel? organization,
    required RequestFacilityModel facility,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (facility.comments.isNotEmpty) {
        for (final comment in facility.comments) {
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
      _facilityService.update({
        'id': facility.id,
        'comments': comments,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '申請に社内コメントを追記しました。',
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
    required RequestFacilityModel facility,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請情報の更新に失敗しました';
    if (loginUser == null) return '申請情報の更新に失敗しました';
    try {
      _facilityService.update({
        'id': facility.id,
        'pending': true,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '申請を保留中にしました。',
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
    required RequestFacilityModel facility,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請情報の更新に失敗しました';
    if (loginUser == null) return '申請情報の更新に失敗しました';
    try {
      _facilityService.update({
        'id': facility.id,
        'pending': false,
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '申請の保留中を解除しました。',
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
    required RequestFacilityModel facility,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請の承認に失敗しました';
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (facility.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in facility.approvalUsers) {
          approvalUsers.add(approvalUser.toMap());
        }
      }
      approvalUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'userPresident': loginUser.president,
        'approvedAt': DateTime.now(),
      });
      _facilityService.update({
        'id': facility.id,
        'approval': 1,
        'approvedAt': DateTime.now(),
        'approvalUsers': approvalUsers,
      });
      String useAtText = '';
      if (facility.useAtPending) {
        useAtText = '未定';
      } else {
        useAtText =
            '${dateText('yyyy/MM/dd HH:mm', facility.useStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', facility.useEndedAt)}';
      }
      int useAtDaysPrice = 0;
      if (!facility.useAtPending) {
        int useAtDays =
            facility.useEndedAt.difference(facility.useStartedAt).inDays;
        int price = 1200;
        useAtDaysPrice = price * useAtDays;
      }
      String attachedFilesText = '';
      if (facility.attachedFiles.isNotEmpty) {
        for (final file in facility.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String message = '''
施設使用申込が承認されました。
以下申込内容をご確認し、ご利用ください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【店舗名】${facility.companyName}
【店舗責任者名】${facility.companyUserName}
【店舗責任者メールアドレス】${facility.companyUserEmail}
【店舗責任者電話番号】${facility.companyUserTel}

■旧梵屋跡の倉庫を使用します (貸出面積：約12㎡)
【使用予定日時】$useAtText
【使用料合計(税抜)】${NumberFormat("#,###").format(useAtDaysPrice)}円

【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': facility.companyUserEmail,
        'subject': '施設使用申込承認のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '申請を承認しました。',
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
    required RequestFacilityModel facility,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請の否決に失敗しました';
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _facilityService.update({
        'id': facility.id,
        'approval': 9,
      });
      String useAtText = '';
      if (facility.useAtPending) {
        useAtText = '未定';
      } else {
        useAtText =
            '${dateText('yyyy/MM/dd HH:mm', facility.useStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', facility.useEndedAt)}';
      }
      int useAtDaysPrice = 0;
      if (!facility.useAtPending) {
        int useAtDays =
            facility.useEndedAt.difference(facility.useStartedAt).inDays;
        int price = 1200;
        useAtDaysPrice = price * useAtDays;
      }
      String attachedFilesText = '';
      if (facility.attachedFiles.isNotEmpty) {
        for (final file in facility.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String message = '''
施設使用申込が否決されました。
以下申込内容をご確認し、再度申込を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【店舗名】${facility.companyName}
【店舗責任者名】${facility.companyUserName}
【店舗責任者メールアドレス】${facility.companyUserEmail}
【店舗責任者電話番号】${facility.companyUserTel}

■旧梵屋跡の倉庫を使用します (貸出面積：約12㎡)
【使用予定日時】$useAtText
【使用料合計(税抜)】${NumberFormat("#,###").format(useAtDaysPrice)}円

【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': facility.companyUserEmail,
        'subject': '施設使用申込否決のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
      //ログ保存
      String logId = _logService.id();
      _logService.create({
        'id': logId,
        'organizationId': organization.id,
        'content': '申請を否決しました。',
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
