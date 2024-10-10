import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/approval_user.dart';

class RequestFacilityModel {
  String _id = '';
  String _shopName = '';
  String _shopUserName = '';
  String _shopUserEmail = '';
  String _shopUserTel = '';
  String _usePeriod = '';
  String _remarks = '';
  int _approval = 0;
  DateTime _approvedAt = DateTime.now();
  List<ApprovalUserModel> approvalUsers = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get shopName => _shopName;
  String get shopUserName => _shopUserName;
  String get shopUserEmail => _shopUserEmail;
  String get shopUserTel => _shopUserTel;
  String get usePeriod => _usePeriod;
  String get remarks => _remarks;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestFacilityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _shopName = data['shopName'] ?? '';
    _shopUserName = data['shopUserName'] ?? '';
    _shopUserEmail = data['shopUserEmail'] ?? '';
    _shopUserTel = data['shopUserTel'] ?? '';
    _usePeriod = data['usePeriod'] ?? '';
    _remarks = data['remarks'] ?? '';
    _approval = data['approval'] ?? 0;
    _approvedAt = data['approvedAt'].toDate() ?? DateTime.now();
    approvalUsers = _convertApprovalUsers(data['approvalUsers']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<ApprovalUserModel> _convertApprovalUsers(List list) {
    List<ApprovalUserModel> converted = [];
    for (Map data in list) {
      converted.add(ApprovalUserModel.fromMap(data));
    }
    return converted;
  }

  String approvalText() {
    switch (_approval) {
      case 0:
        return '承認待ち';
      case 1:
        return '承認済み';
      case 9:
        return '否決';
      default:
        return '承認待ち';
    }
  }
}
