import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/approval_user.dart';

class RequestInterviewModel {
  String _id = '';
  String _companyName = '';
  String _companyUserName = '';
  String _companyUserEmail = '';
  String _companyUserTel = '';
  String _mediaName = '';
  String _programName = '';
  String _castInfo = '';
  String _featureContent = '';
  String _publishedAt = '';
  String _interviewedAt = '';
  String _interviewedUserName = '';
  String _interviewedUserTel = '';
  String _interviewedTime = '';
  bool _interviewedReserved = false;
  String _interviewedShopName = '';
  String _interviewedVisitors = '';
  String _interviewedContent = '';
  String _locationAt = '';
  String _locationUserName = '';
  String _locationUserTel = '';
  String _locationVisitors = '';
  String _locationContent = '';
  String _insertedAt = '';
  String _insertedUserName = '';
  String _insertedUserTel = '';
  String _insertedTime = '';
  bool _insertedReserved = false;
  String _insertedShopName = '';
  String _insertedVisitors = '';
  String _insertedContent = '';
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
  String get mediaName => _mediaName;
  String get programName => _programName;
  String get castInfo => _castInfo;
  String get featureContent => _featureContent;
  String get publishedAt => _publishedAt;
  String get interviewedAt => _interviewedAt;
  String get interviewedUserName => _interviewedUserName;
  String get interviewedUserTel => _interviewedUserTel;
  String get interviewedTime => _interviewedTime;
  bool get interviewedReserved => _interviewedReserved;
  String get interviewedShopName => _interviewedShopName;
  String get interviewedVisitors => _interviewedVisitors;
  String get interviewedContent => _interviewedContent;
  String get locationAt => _locationAt;
  String get locationUserName => _locationUserName;
  String get locationUserTel => _locationUserTel;
  String get locationVisitors => _locationVisitors;
  String get locationContent => _locationContent;
  String get insertedAt => _insertedAt;
  String get insertedUserName => _insertedUserName;
  String get insertedUserTel => _insertedUserTel;
  String get insertedTime => _insertedTime;
  bool get insertedReserved => _insertedReserved;
  String get insertedShopName => _insertedShopName;
  String get insertedVisitors => _insertedVisitors;
  String get insertedContent => _insertedContent;
  String get remarks => _remarks;
  int get approval => _approval;
  DateTime get approvedAt => _approvedAt;
  DateTime get createdAt => _createdAt;

  RequestInterviewModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _companyName = data['companyName'] ?? '';
    _companyUserName = data['companyUserName'] ?? '';
    _companyUserEmail = data['companyUserEmail'] ?? '';
    _companyUserTel = data['companyUserTel'] ?? '';
    _mediaName = data['mediaName'] ?? '';
    _programName = data['programName'] ?? '';
    _castInfo = data['castInfo'] ?? '';
    _featureContent = data['featureContent'] ?? '';
    _publishedAt = data['publishedAt'] ?? '';
    _interviewedAt = data['interviewedAt'] ?? '';
    _interviewedUserName = data['interviewedUserName'] ?? '';
    _interviewedUserTel = data['interviewedUserTel'] ?? '';
    _interviewedTime = data['interviewedTime'] ?? '';
    _interviewedReserved = data['interviewedReserved'] ?? false;
    _interviewedShopName = data['interviewedShopName'] ?? '';
    _interviewedVisitors = data['interviewedVisitors'] ?? '';
    _interviewedContent = data['interviewedContent'] ?? '';
    _locationAt = data['locationAt'] ?? '';
    _locationUserName = data['locationUserName'] ?? '';
    _locationUserTel = data['locationUserTel'] ?? '';
    _locationVisitors = data['locationVisitors'] ?? '';
    _locationContent = data['locationContent'] ?? '';
    _insertedAt = data['insertedAt'] ?? '';
    _insertedUserName = data['insertedUserName'] ?? '';
    _insertedUserTel = data['insertedUserTel'] ?? '';
    _insertedTime = data['insertedTime'] ?? '';
    _insertedReserved = data['insertedReserved'] ?? false;
    _insertedShopName = data['insertedShopName'] ?? '';
    _insertedVisitors = data['insertedVisitors'] ?? '';
    _insertedContent = data['insertedContent'] ?? '';
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
