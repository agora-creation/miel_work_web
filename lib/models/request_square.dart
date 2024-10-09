import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/approval_user.dart';

class RequestSquareModel {
  String _id = '';
  String _companyName = '';
  String _companyUserName = '';
  String _companyUserEmail = '';
  String _companyUserTel = '';
  String _companyAddress = '';
  String _useName = '';
  String _useUserName = '';
  String _useUserTel = '';
  String _usePeriod = '';
  String _useTimezone = '';
  bool _useFull = false;
  bool _useChair = false;
  bool _useDesk = false;
  String _useContent = '';
  String _remarks = '';
  int _approval = 0;
  DateTime _approvedAt = DateTime.now();
  List<ApprovalUserModel> approvalUsers = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get companyName => _companyName;
  String get companyUserName => _companyUserName;
  String get companyUserEmail => _companyUserEmail;
  String get companyUserTel => _companyUserTel;
  String get companyAddress => _companyAddress;
  String get useName => _useName;
  String get useUserName => _useUserName;
  String get useUserTel => _useUserTel;
  String get usePeriod => _usePeriod;
  String get useTimezone => _useTimezone;
  bool get useFull => _useFull;
  bool get useChair => _useChair;
  bool get useDesk => _useDesk;
  String get useContent => _useContent;
  String get remarks => _remarks;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestSquareModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyName = data['companyName'] ?? '';
    _companyUserName = data['companyUserName'] ?? '';
    _companyUserEmail = data['companyUserEmail'] ?? '';
    _companyUserTel = data['companyUserTel'] ?? '';
    _companyAddress = data['companyAddress'] ?? '';
    _useName = data['useName'] ?? '';
    _useUserName = data['useUserName'] ?? '';
    _useUserTel = data['useUserTel'] ?? '';
    _usePeriod = data['usePeriod'] ?? '';
    _useTimezone = data['useTimezone'] ?? '';
    _useFull = data['useFull'] ?? false;
    _useChair = data['useChair'] ?? false;
    _useDesk = data['useDesk'] ?? false;
    _useContent = data['useContent'] ?? '';
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
