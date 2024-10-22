import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/approval_user.dart';
import 'package:miel_work_web/models/request_const.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/mail.dart';
import 'package:miel_work_web/services/request_const.dart';

class RequestConstProvider with ChangeNotifier {
  final RequestConstService _constService = RequestConstService();
  final MailService _mailService = MailService();

  Future<String?> update({
    required RequestConstModel requestConst,
    required String companyName,
    required String companyUserName,
    required String companyUserEmail,
    required String companyUserTel,
    required String constName,
    required String constUserName,
    required String constUserTel,
    required DateTime constStartedAt,
    required DateTime constEndedAt,
    required bool constAtPending,
    required String constContent,
    required bool noise,
    required String noiseMeasures,
    required bool dust,
    required String dustMeasures,
    required bool fire,
    required String fireMeasures,
  }) async {
    String? error;
    try {
      _constService.update({
        'id': requestConst.id,
        'companyName': companyName,
        'companyUserName': companyUserName,
        'companyUserEmail': companyUserEmail,
        'companyUserTel': companyUserTel,
        'constName': constName,
        'constUserName': constUserName,
        'constUserTel': constUserTel,
        'constStartedAt': constStartedAt,
        'constEndedAt': constEndedAt,
        'constAtPending': constAtPending,
        'constContent': constContent,
        'noise': noise,
        'noiseMeasures': noiseMeasures,
        'dust': dust,
        'dustMeasures': dustMeasures,
        'fire': fire,
        'fireMeasures': fireMeasures,
      });
    } catch (e) {
      error = '店舗工事作業申請情報の編集に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required RequestConstModel requestConst,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
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
        'createdAt': DateTime.now(),
      });
      _constService.update({
        'id': requestConst.id,
        'comments': comments,
      });
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required RequestConstModel requestConst,
    required bool meeting,
    required DateTime meetingAt,
    required String caution,
    required UserModel? loginUser,
  }) async {
    String? error;
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
    } catch (e) {
      error = '申請の承認に失敗しました';
    }
    return error;
  }

  Future<String?> reject({
    required RequestConstModel requestConst,
    required UserModel? loginUser,
  }) async {
    String? error;
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
    } catch (e) {
      error = '申請の否決に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required RequestConstModel requestConst,
  }) async {
    String? error;
    try {
      _constService.delete({
        'id': requestConst.id,
      });
    } catch (e) {
      error = '申請情報の削除に失敗しました';
    }
    return error;
  }
}
