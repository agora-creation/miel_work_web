import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_interview.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/mail.dart';
import 'package:miel_work_web/services/request_interview.dart';

class RequestInterviewProvider with ChangeNotifier {
  final RequestInterviewService _interviewService = RequestInterviewService();
  final MailService _mailService = MailService();

  Future<String?> approval({
    required RequestInterviewModel interview,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の承認に失敗しました';
    try {
      List<Map> approvalUsers = [];
      if (interview.approvalUsers.isNotEmpty) {
        for (ApprovalUserModel approvalUser in interview.approvalUsers) {
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
        _interviewService.update({
          'id': interview.id,
          'approval': 1,
          'approvedAt': DateTime.now(),
          'approvalUsers': approvalUsers,
        });
        String interviewedAtText = '';
        if (interview.interviewedAtPending) {
          interviewedAtText = '未定';
        } else {
          interviewedAtText =
              '${dateText('yyyy/MM/dd HH:mm', interview.interviewedStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', interview.interviewedEndedAt)}';
        }
        String interviewedReservedText = '';
        if (interview.interviewedReserved) {
          interviewedReservedText = '必要';
        }
        String locationText = '';
        if (interview.location) {
          String locationAtText = '';
          if (interview.locationAtPending) {
            locationAtText = '未定';
          } else {
            locationAtText =
                '${dateText('yyyy/MM/dd HH:mm', interview.locationStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', interview.locationEndedAt)}';
          }
          locationText = '''
■ロケハン情報
【ロケハン予定日時】$locationAtText
【ロケハン担当者名】${interview.locationUserName}
【ロケハン担当者電話番号】${interview.locationUserTel}
【いらっしゃる人数】${interview.locationVisitors}
【ロケハン内容・備考】
${interview.locationContent}

        ''';
        }
        String insertText = '';
        if (interview.insert) {
          String insertedAt = '';
          if (interview.insertedAtPending) {
            insertedAt = '未定';
          } else {
            insertedAt =
                '${dateText('yyyy/MM/dd HH:mm', interview.insertedStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', interview.insertedEndedAt)}';
          }
          String insertedReservedText = '';
          if (interview.insertedReserved) {
            insertedReservedText = '必要';
          }
          insertText = '''
■インサート撮影情報
【撮影予定日時】$insertedAt
【撮影担当者名】${interview.insertedUserName}
【撮影担当者電話番号】${interview.insertedUserTel}
【席の予約】$insertedReservedText
【撮影店舗】${interview.insertedShopName}
【いらっしゃる人数】${interview.insertedVisitors}
【撮影内容・備考】
${interview.insertedContent}

        ''';
        }
        String attachedFilesText = '';
        if (interview.attachedFiles.isNotEmpty) {
          for (final file in interview.attachedFiles) {
            attachedFilesText += '$file\n';
          }
        }
        String message = '''
取材申込が承認されました。
以下申込内容をご確認し、お越しください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【申込会社名】${interview.companyName}
【申込担当者名】${interview.companyUserName}
【申込担当者メールアドレス】${interview.companyUserEmail}
【申込担当者電話番号】${interview.companyUserTel}
【媒体名】${interview.mediaName}
【番組・雑誌名】${interview.programName}
【出演者情報】${interview.castInfo}
【特集内容・備考】
${interview.featureContent}
【OA・掲載予定日】
${interview.publishedAt}

■取材当日情報
【取材予定日時】$interviewedAtText
【取材担当者名】${interview.interviewedUserName}
【取材担当者電話番号】${interview.interviewedUserTel}
【席の予約】$interviewedReservedText
【取材店舗】${interview.interviewedShopName}
【いらっしゃる人数】${interview.interviewedVisitors}
【取材内容・備考】
${interview.interviewedContent}

$locationText
$insertText
【添付ファイル】
$attachedFilesText
【その他連絡事項】
${interview.remarks}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
        _mailService.create({
          'id': _mailService.id(),
          'to': interview.companyUserEmail,
          'subject': '取材申込承認のお知らせ',
          'message': message,
          'createdAt': DateTime.now(),
          'expirationAt': DateTime.now().add(const Duration(hours: 1)),
        });
      } else {
        _interviewService.update({
          'id': interview.id,
          'approvalUsers': approvalUsers,
        });
      }
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestInterviewModel interview,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '申請の否決に失敗しました';
    try {
      _interviewService.update({
        'id': interview.id,
        'approval': 9,
      });
      String interviewedAtText = '';
      if (interview.interviewedAtPending) {
        interviewedAtText = '未定';
      } else {
        interviewedAtText =
            '${dateText('yyyy/MM/dd HH:mm', interview.interviewedStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', interview.interviewedEndedAt)}';
      }
      String interviewedReservedText = '';
      if (interview.interviewedReserved) {
        interviewedReservedText = '必要';
      }
      String locationText = '';
      if (interview.location) {
        String locationAtText = '';
        if (interview.locationAtPending) {
          locationAtText = '未定';
        } else {
          locationAtText =
              '${dateText('yyyy/MM/dd HH:mm', interview.locationStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', interview.locationEndedAt)}';
        }
        locationText = '''
■ロケハン情報
【ロケハン予定日時】$locationAtText
【ロケハン担当者名】${interview.locationUserName}
【ロケハン担当者電話番号】${interview.locationUserTel}
【いらっしゃる人数】${interview.locationVisitors}
【ロケハン内容・備考】
${interview.locationContent}

        ''';
      }
      String insertText = '';
      if (interview.insert) {
        String insertedAt = '';
        if (interview.insertedAtPending) {
          insertedAt = '未定';
        } else {
          insertedAt =
              '${dateText('yyyy/MM/dd HH:mm', interview.insertedStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', interview.insertedEndedAt)}';
        }
        String insertedReservedText = '';
        if (interview.insertedReserved) {
          insertedReservedText = '必要';
        }
        insertText = '''
■インサート撮影情報
【撮影予定日時】$insertedAt
【撮影担当者名】${interview.insertedUserName}
【撮影担当者電話番号】${interview.insertedUserTel}
【席の予約】$insertedReservedText
【撮影店舗】${interview.insertedShopName}
【いらっしゃる人数】${interview.insertedVisitors}
【撮影内容・備考】
${interview.insertedContent}

        ''';
      }
      String attachedFilesText = '';
      if (interview.attachedFiles.isNotEmpty) {
        for (final file in interview.attachedFiles) {
          attachedFilesText += '$file\n';
        }
      }
      String message = '''
取材申込が否決されました。
以下申込内容をご確認し、再度申込を行なってください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申込者情報
【申込会社名】${interview.companyName}
【申込担当者名】${interview.companyUserName}
【申込担当者メールアドレス】${interview.companyUserEmail}
【申込担当者電話番号】${interview.companyUserTel}
【媒体名】${interview.mediaName}
【番組・雑誌名】${interview.programName}
【出演者情報】${interview.castInfo}
【特集内容・備考】
${interview.featureContent}
【OA・掲載予定日】
${interview.publishedAt}

■取材当日情報
【取材予定日時】$interviewedAtText
【取材担当者名】${interview.interviewedUserName}
【取材担当者電話番号】${interview.interviewedUserTel}
【席の予約】$interviewedReservedText
【取材店舗】${interview.interviewedShopName}
【いらっしゃる人数】${interview.interviewedVisitors}
【取材内容・備考】
${interview.interviewedContent}

$locationText
$insertText
【添付ファイル】
$attachedFilesText
【その他連絡事項】
${interview.remarks}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': interview.companyUserEmail,
        'subject': '取材申込否決のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestInterviewModel interview,
  }) async {
    String? error;
    try {
      _interviewService.delete({
        'id': interview.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
