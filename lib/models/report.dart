import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/report_check.dart';
import 'package:miel_work_web/models/report_equipment.dart';
import 'package:miel_work_web/models/report_locker.dart';
import 'package:miel_work_web/models/report_pamphlet.dart';
import 'package:miel_work_web/models/report_plan.dart';
import 'package:miel_work_web/models/report_problem.dart';
import 'package:miel_work_web/models/report_repair.dart';
import 'package:miel_work_web/models/report_visitor.dart';
import 'package:miel_work_web/models/report_worker.dart';

class ReportModel {
  String _id = '';
  String _organizationId = '';
  List<ReportWorkerModel> reportWorkers = [];
  ReportVisitorModel reportVisitor = ReportVisitorModel.fromMap({});
  ReportLockerModel? reportLocker;
  List<ReportPlanModel> reportPlans = [];
  ReportCheckModel? reportCheck;
  int _advancePayment1 = 0;
  int _advancePayment2 = 0;
  List<ReportRepairModel> reportRepairs = [];
  List<ReportProblemModel> reportProblems = [];
  List<ReportPamphletModel> reportPamphlets = [];
  List<ReportEquipmentModel> reportEquipments = [];
  String _passport = '';
  int _passportCount = 0;
  String _remarks = '';
  String _agenda = '';
  bool _lastConfirmShop = false;
  DateTime _lastConfirmShopAt = DateTime.now();
  String _lastConfirmShopName = '';
  bool _lastConfirmCenter = false;
  DateTime _lastConfirmCenterAt = DateTime.now();
  bool _lastConfirmExhaust = false;
  DateTime _lastConfirmExhaustAt = DateTime.now();
  bool _lastConfirmRoof = false;
  DateTime _lastConfirmRoofAt = DateTime.now();
  bool _lastConfirmAirCon = false;
  DateTime _lastConfirmAirConAt = DateTime.now();
  bool _lastConfirmToilet = false;
  DateTime _lastConfirmToiletAt = DateTime.now();
  bool _lastConfirmBaby = false;
  DateTime _lastConfirmBabyAt = DateTime.now();
  bool _lastConfirmPC = false;
  DateTime _lastConfirmPCAt = DateTime.now();
  bool _lastConfirmTel = false;
  DateTime _lastConfirmTelAt = DateTime.now();
  bool _lastConfirmCoupon = false;
  DateTime _lastConfirmCouponAt = DateTime.now();
  bool _lastConfirmCalendar = false;
  DateTime _lastConfirmCalendarAt = DateTime.now();
  bool _lastConfirmMoney = false;
  DateTime _lastConfirmMoneyAt = DateTime.now();
  bool _lastConfirmUser = false;
  DateTime _lastConfirmUserAt = DateTime.now();
  String _lastConfirmUserName = '';
  int _approval = 0;
  String _createdUserId = '';
  String _createdUserName = '';
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  int get advancePayment1 => _advancePayment1;
  int get advancePayment2 => _advancePayment2;
  String get passport => _passport;
  int get passportCount => _passportCount;
  String get remarks => _remarks;
  String get agenda => _agenda;
  DateTime get lastConfirmShopAt => _lastConfirmShopAt;
  String get lastConfirmShopName => _lastConfirmShopName;
  DateTime get lastConfirmCenterAt => _lastConfirmCenterAt;
  DateTime get lastConfirmExhaustAt => _lastConfirmExhaustAt;
  DateTime get lastConfirmRoofAt => _lastConfirmRoofAt;
  DateTime get lastConfirmAirConAt => _lastConfirmAirConAt;
  DateTime get lastConfirmToiletAt => _lastConfirmToiletAt;
  DateTime get lastConfirmBabyAt => _lastConfirmBabyAt;
  DateTime get lastConfirmPCAt => _lastConfirmPCAt;
  DateTime get lastConfirmTelAt => _lastConfirmTelAt;
  DateTime get lastConfirmCouponAt => _lastConfirmCouponAt;
  DateTime get lastConfirmCalendarAt => _lastConfirmCalendarAt;
  DateTime get lastConfirmMoneyAt => _lastConfirmMoneyAt;
  int get approval => _approval;
  String get createdUserId => _createdUserId;
  String get createdUserName => _createdUserName;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  ReportModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    // reportWorkers = _convertReportWorkers(data['reportWorkers'] ?? ['']);
    // reportVisitor = ReportVisitorModel.fromMap(data['reportVisitor'] ?? ['']);
    // reportLocker = ReportLockerModel.fromMap(data['reportLocker'] ?? ['']);
    // reportPlans = _convertReportPlans(data['reportPlans'] ?? ['']);
    // reportCheck = ReportCheckModel.fromMap(data['reportCheck'] ?? ['']);
    // _advancePayment1 = data['advancePayment1'] ?? 0;
    // _advancePayment2 = data['advancePayment2'] ?? 0;
    // reportRepairs = _convertReportRepairs(data['reportRepairs'] ?? ['']);
    // reportProblems = _convertReportProblems(data['reportProblems'] ?? ['']);
    // reportPamphlets = _convertReportPamphlets(data['reportPamphlets'] ?? ['']);
    // reportEquipments =
    //     _convertReportEquipments(data['reportEquipments'] ?? ['']);
    // _passport = data['passport'] ?? '';
    // _passportCount = data['passportCount'] ?? 0;
    // _remarks = data['remarks'] ?? '';
    // _lastConfirmUser = data['lastConfirmUser'] ?? '';
    // _agenda = data['agenda'] ?? '';
    // _lastConfirmShopAt = data['lastConfirmShopAt'].toDate() ?? DateTime.now();
    // _lastConfirmShopName = data['lastConfirmShopName'] ?? '';
    // _lastConfirmCenterAt =
    //     data['lastConfirmCenterAt'].toDate() ?? DateTime.now();
    // _lastConfirmExhaustAt =
    //     data['lastConfirmExhaustAt'].toDate() ?? DateTime.now();
    // _lastConfirmRoofAt = data['lastConfirmRoofAt'].toDate() ?? DateTime.now();
    // _lastConfirmAirConAt =
    //     data['lastConfirmAirConAt'].toDate() ?? DateTime.now();
    // _lastConfirmToiletAt =
    //     data['lastConfirmToiletAt'].toDate() ?? DateTime.now();
    // _lastConfirmBabyAt = data['lastConfirmBabyAt'].toDate() ?? DateTime.now();
    // _lastConfirmPCAt = data['lastConfirmPCAt'].toDate() ?? DateTime.now();
    // _lastConfirmTelAt = data['lastConfirmTelAt'].toDate() ?? DateTime.now();
    // _lastConfirmCouponAt =
    //     data['lastConfirmCouponAt'].toDate() ?? DateTime.now();
    // _lastConfirmCalendarAt =
    //     data['lastConfirmCalendarAt'].toDate() ?? DateTime.now();
    // _lastConfirmMoneyAt = data['lastConfirmMoneyAt'].toDate() ?? DateTime.now();
    _approval = data['approval'] ?? 0;
    _createdUserId = data['createdUserId'] ?? '';
    _createdUserName = data['createdUserName'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<ReportWorkerModel> _convertReportWorkers(List list) {
    List<ReportWorkerModel> converted = [];
    for (Map data in list) {
      converted.add(ReportWorkerModel.fromMap(data));
    }
    return converted;
  }

  List<ReportPlanModel> _convertReportPlans(List list) {
    List<ReportPlanModel> converted = [];
    for (Map data in list) {
      converted.add(ReportPlanModel.fromMap(data));
    }
    return converted;
  }

  List<ReportRepairModel> _convertReportRepairs(List list) {
    List<ReportRepairModel> converted = [];
    for (Map data in list) {
      converted.add(ReportRepairModel.fromMap(data));
    }
    return converted;
  }

  List<ReportProblemModel> _convertReportProblems(List list) {
    List<ReportProblemModel> converted = [];
    for (Map data in list) {
      converted.add(ReportProblemModel.fromMap(data));
    }
    return converted;
  }

  List<ReportPamphletModel> _convertReportPamphlets(List list) {
    List<ReportPamphletModel> converted = [];
    for (Map data in list) {
      converted.add(ReportPamphletModel.fromMap(data));
    }
    return converted;
  }

  List<ReportEquipmentModel> _convertReportEquipments(List list) {
    List<ReportEquipmentModel> converted = [];
    for (Map data in list) {
      converted.add(ReportEquipmentModel.fromMap(data));
    }
    return converted;
  }

  String approvalText() {
    switch (_approval) {
      case 0:
        return '承認待ち';
      case 1:
        return '承認済み';
      default:
        return '承認待ち';
    }
  }
}
