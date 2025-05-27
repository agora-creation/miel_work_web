import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/request_square.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/log.dart';
import 'package:miel_work_web/services/mail.dart';
import 'package:miel_work_web/services/request_square.dart';

class RequestSquareProvider with ChangeNotifier {
  final RequestSquareService _squareService = RequestSquareService();
  final MailService _mailService = MailService();
  final LogService _logService = LogService();

  Future<String?> addComment({
    required OrganizationModel? organization,
    required RequestSquareModel square,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (square.comments.isNotEmpty) {
        for (final comment in square.comments) {
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
      _squareService.update({
        'id': square.id,
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
    required RequestSquareModel square,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請情報の更新に失敗しました';
    if (loginUser == null) return '申請情報の更新に失敗しました';
    try {
      _squareService.update({
        'id': square.id,
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
    required RequestSquareModel square,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請情報の更新に失敗しました';
    if (loginUser == null) return '申請情報の更新に失敗しました';
    try {
      _squareService.update({
        'id': square.id,
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
    required RequestSquareModel square,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請の承認に失敗しました';
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (square.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in square.approvalUsers) {
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
        _squareService.update({
          'id': square.id,
          'approval': 1,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
        String useAtText = '';
        if (square.useAtPending) {
          useAtText = '未定';
        } else {
          useAtText =
              '${dateText('yyyy/MM/dd HH:mm', square.useStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', square.useEndedAt)}';
        }
        String useClassText = '';
        if (square.useFull) {
          useClassText = '''
全面使用
        ''';
        }
        if (square.useChair) {
          useClassText = '''
折りたたみイス：${square.useChairNum}脚
        ''';
        }
        if (square.useDesk) {
          useClassText = '''
折りたたみ机：${square.useDeskNum}台
        ''';
        }
        String attachedFilesText = '';
        if (square.attachedFiles.isNotEmpty) {
          for (final file in square.attachedFiles) {
            attachedFilesText += '$file\n';
          }
        }
        String message = '''
よさこい広場使用申込が承認されました。
以下申込内容をご確認し、ご利用ください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【申込会社名(又は店名)】${square.companyName}
【申込担当者名】${square.companyUserName}
【申込担当者メールアドレス】${square.companyUserEmail}
【申込担当者電話番号】${square.companyUserTel}
【住所】${square.companyAddress}

■使用者情報 (申込者情報と異なる場合のみ)
【使用会社名(又は店名)】${square.useCompanyName}
【使用者名】${square.useCompanyUserName}

■使用情報
【使用予定日時】$useAtText
【使用区分】
$useClassText
【使用内容】
${square.useContent}
【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
        _mailService.create({
          'id': _mailService.id(),
          'to': square.companyUserEmail,
          'subject': 'よさこい広場使用申込承認のお知らせ',
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
      } else {
        _squareService.update({
          'id': square.id,
          'approvalUsers': approvalUsers,
        });
      }
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required OrganizationModel? organization,
    required RequestSquareModel square,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '申請の否決に失敗しました';
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _squareService.update({
        'id': square.id,
        'approval': 9,
      });
      String useAtText = '';
      if (square.useAtPending) {
        useAtText = '未定';
      } else {
        useAtText =
            '${dateText('yyyy/MM/dd HH:mm', square.useStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', square.useEndedAt)}';
      }
      String useClassText = '';
      if (square.useFull) {
        useClassText = '''
全面使用
        ''';
      }
      if (square.useChair) {
        useClassText = '''
折りたたみイス：${square.useChairNum}脚
        ''';
      }
      if (square.useDesk) {
        useClassText = '''
折りたたみ机：${square.useDeskNum}台
        ''';
      }
      String attachedFilesText = '';
      if (square.attachedFiles.isNotEmpty) {
        for (final file in square.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String message = '''
よさこい広場使用申込が否決されました。
以下申込内容をご確認し、再度申込を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【申込会社名(又は店名)】${square.companyName}
【申込担当者名】${square.companyUserName}
【申込担当者メールアドレス】${square.companyUserEmail}
【申込担当者電話番号】${square.companyUserTel}
【住所】${square.companyAddress}

■使用者情報 (申込者情報と異なる場合のみ)
【使用会社名(又は店名)】${square.useCompanyName}
【使用者名】${square.useCompanyUserName}

■使用情報
【使用予定日時】$useAtText
【使用区分】
$useClassText
【使用内容】
${square.useContent}
【添付ファイル】
$attachedFilesText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': square.companyUserEmail,
        'subject': 'よさこい広場使用申込否決のお知らせ',
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
