import 'package:flutter/material.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/report.dart';
import 'package:miel_work_web/models/report_check.dart';
import 'package:miel_work_web/models/report_equipment.dart';
import 'package:miel_work_web/models/report_locker.dart';
import 'package:miel_work_web/models/report_pamphlet.dart';
import 'package:miel_work_web/models/report_plan.dart';
import 'package:miel_work_web/models/report_problem.dart';
import 'package:miel_work_web/models/report_repair.dart';
import 'package:miel_work_web/models/report_visitor.dart';
import 'package:miel_work_web/models/report_worker.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/report.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime createdAt,
    required List<ReportWorkerModel> reportWorkers,
    required ReportVisitorModel reportVisitor,
    required ReportLockerModel reportLocker,
    required List<ReportPlanModel> reportPlans,
    required ReportCheckModel reportCheck,
    required int advancePayment1,
    required int advancePayment2,
    required List<ReportRepairModel> reportRepairs,
    required List<ReportProblemModel> reportProblems,
    required List<ReportPamphletModel> reportPamphlets,
    required List<ReportEquipmentModel> reportEquipments,
    required String remarks,
    required String agenda,
    required bool lastConfirmShop,
    required DateTime lastConfirmShopAt,
    required String lastConfirmShopName,
    required bool lastConfirmCenter,
    required DateTime lastConfirmCenterAt,
    required bool lastConfirmExhaust,
    required DateTime lastConfirmExhaustAt,
    required bool lastConfirmRoof,
    required DateTime lastConfirmRoofAt,
    required bool lastConfirmAirCon,
    required DateTime lastConfirmAirConAt,
    required bool lastConfirmToilet,
    required DateTime lastConfirmToiletAt,
    required bool lastConfirmBaby,
    required DateTime lastConfirmBabyAt,
    required bool lastConfirmPC,
    required DateTime lastConfirmPCAt,
    required bool lastConfirmTel,
    required DateTime lastConfirmTelAt,
    required bool lastConfirmCoupon,
    required DateTime lastConfirmCouponAt,
    required bool lastConfirmCalendar,
    required DateTime lastConfirmCalendarAt,
    required bool lastConfirmMoney,
    required DateTime lastConfirmMoneyAt,
    required bool lastConfirmLock,
    required DateTime lastConfirmLockAt,
    required bool lastConfirmUser,
    required DateTime lastConfirmUserAt,
    required String lastConfirmUserName,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '日報の保存に失敗しました';
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      String id = _reportService.id();
      List<Map> reportWorkersMap = [];
      for (final data in reportWorkers) {
        reportWorkersMap.add(data.toMap());
      }
      List<Map> reportPlansMap = [];
      for (final data in reportPlans) {
        reportPlansMap.add(data.toMap());
      }
      List<Map> reportRepairsMap = [];
      for (final data in reportRepairs) {
        reportRepairsMap.add(data.toMap());
      }
      List<Map> reportProblemsMap = [];
      for (final data in reportProblems) {
        reportProblemsMap.add(data.toMap());
      }
      List<Map> reportPamphletsMap = [];
      for (final data in reportPamphlets) {
        reportPamphletsMap.add(data.toMap());
      }
      List<Map> reportEquipmentsMap = [];
      for (final data in reportEquipments) {
        reportEquipmentsMap.add(data.toMap());
      }
      _reportService.create({
        'id': id,
        'organizationId': organization.id,
        'reportWorkers': reportWorkersMap,
        'reportVisitor': reportVisitor.toMap(),
        'reportLocker': reportLocker.toMap(),
        'reportPlans': reportPlansMap,
        'reportCheck': reportCheck.toMap(),
        'advancePayment1': advancePayment1,
        'advancePayment2': advancePayment2,
        'reportRepairs': reportRepairsMap,
        'reportProblems': reportProblemsMap,
        'reportPamphlets': reportPamphletsMap,
        'reportEquipments': reportEquipmentsMap,
        'remarks': remarks,
        'agenda': agenda,
        'lastConfirmShop': lastConfirmShop,
        'lastConfirmShopAt': lastConfirmShopAt,
        'lastConfirmShopName': lastConfirmShopName,
        'lastConfirmCenter': lastConfirmCenter,
        'lastConfirmCenterAt': lastConfirmCenterAt,
        'lastConfirmExhaust': lastConfirmExhaust,
        'lastConfirmExhaustAt': lastConfirmExhaustAt,
        'lastConfirmRoof': lastConfirmRoof,
        'lastConfirmRoofAt': lastConfirmRoofAt,
        'lastConfirmAirCon': lastConfirmAirCon,
        'lastConfirmAirConAt': lastConfirmAirConAt,
        'lastConfirmToilet': lastConfirmToilet,
        'lastConfirmToiletAt': lastConfirmToiletAt,
        'lastConfirmBaby': lastConfirmBaby,
        'lastConfirmBabyAt': lastConfirmBabyAt,
        'lastConfirmPC': lastConfirmPC,
        'lastConfirmPCAt': lastConfirmPCAt,
        'lastConfirmTel': lastConfirmTel,
        'lastConfirmTelAt': lastConfirmTelAt,
        'lastConfirmCoupon': lastConfirmCoupon,
        'lastConfirmCouponAt': lastConfirmCouponAt,
        'lastConfirmCalendar': lastConfirmCalendar,
        'lastConfirmCalendarAt': lastConfirmCalendarAt,
        'lastConfirmMoney': lastConfirmMoney,
        'lastConfirmMoneyAt': lastConfirmMoneyAt,
        'lastConfirmLock': lastConfirmLock,
        'lastConfirmLockAt': lastConfirmLockAt,
        'lastConfirmUser': lastConfirmUser,
        'lastConfirmUserAt': lastConfirmUserAt,
        'lastConfirmUserName': lastConfirmUserName,
        'approval': 0,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': createdAt,
        'expirationAt': createdAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required ReportModel report,
    required List<ReportWorkerModel> reportWorkers,
    required ReportVisitorModel reportVisitor,
    required ReportLockerModel reportLocker,
    required List<ReportPlanModel> reportPlans,
    required ReportCheckModel reportCheck,
    required int advancePayment1,
    required int advancePayment2,
    required List<ReportRepairModel> reportRepairs,
    required List<ReportProblemModel> reportProblems,
    required List<ReportPamphletModel> reportPamphlets,
    required List<ReportEquipmentModel> reportEquipments,
    required String remarks,
    required String agenda,
    required bool lastConfirmShop,
    required DateTime lastConfirmShopAt,
    required String lastConfirmShopName,
    required bool lastConfirmCenter,
    required DateTime lastConfirmCenterAt,
    required bool lastConfirmExhaust,
    required DateTime lastConfirmExhaustAt,
    required bool lastConfirmRoof,
    required DateTime lastConfirmRoofAt,
    required bool lastConfirmAirCon,
    required DateTime lastConfirmAirConAt,
    required bool lastConfirmToilet,
    required DateTime lastConfirmToiletAt,
    required bool lastConfirmBaby,
    required DateTime lastConfirmBabyAt,
    required bool lastConfirmPC,
    required DateTime lastConfirmPCAt,
    required bool lastConfirmTel,
    required DateTime lastConfirmTelAt,
    required bool lastConfirmCoupon,
    required DateTime lastConfirmCouponAt,
    required bool lastConfirmCalendar,
    required DateTime lastConfirmCalendarAt,
    required bool lastConfirmMoney,
    required DateTime lastConfirmMoneyAt,
    required bool lastConfirmLock,
    required DateTime lastConfirmLockAt,
    required bool lastConfirmUser,
    required DateTime lastConfirmUserAt,
    required String lastConfirmUserName,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の保存に失敗しました';
    try {
      List<Map> reportWorkersMap = [];
      for (final data in reportWorkers) {
        reportWorkersMap.add(data.toMap());
      }
      List<Map> reportPlansMap = [];
      for (final data in reportPlans) {
        reportPlansMap.add(data.toMap());
      }
      List<Map> reportRepairsMap = [];
      for (final data in reportRepairs) {
        reportRepairsMap.add(data.toMap());
      }
      List<Map> reportProblemsMap = [];
      for (final data in reportProblems) {
        reportProblemsMap.add(data.toMap());
      }
      List<Map> reportPamphletsMap = [];
      for (final data in reportPamphlets) {
        reportPamphletsMap.add(data.toMap());
      }
      List<Map> reportEquipmentsMap = [];
      for (final data in reportEquipments) {
        reportEquipmentsMap.add(data.toMap());
      }
      _reportService.update({
        'id': report.id,
        'reportWorkers': reportWorkersMap,
        'reportVisitor': reportVisitor.toMap(),
        'reportLocker': reportLocker.toMap(),
        'reportPlans': reportPlansMap,
        'reportCheck': reportCheck.toMap(),
        'advancePayment1': advancePayment1,
        'advancePayment2': advancePayment2,
        'reportRepairs': reportRepairsMap,
        'reportProblems': reportProblemsMap,
        'reportPamphlets': reportPamphletsMap,
        'reportEquipments': reportEquipmentsMap,
        'remarks': remarks,
        'agenda': agenda,
        'lastConfirmShop': lastConfirmShop,
        'lastConfirmShopAt': lastConfirmShopAt,
        'lastConfirmShopName': lastConfirmShopName,
        'lastConfirmCenter': lastConfirmCenter,
        'lastConfirmCenterAt': lastConfirmCenterAt,
        'lastConfirmExhaust': lastConfirmExhaust,
        'lastConfirmExhaustAt': lastConfirmExhaustAt,
        'lastConfirmRoof': lastConfirmRoof,
        'lastConfirmRoofAt': lastConfirmRoofAt,
        'lastConfirmAirCon': lastConfirmAirCon,
        'lastConfirmAirConAt': lastConfirmAirConAt,
        'lastConfirmToilet': lastConfirmToilet,
        'lastConfirmToiletAt': lastConfirmToiletAt,
        'lastConfirmBaby': lastConfirmBaby,
        'lastConfirmBabyAt': lastConfirmBabyAt,
        'lastConfirmPC': lastConfirmPC,
        'lastConfirmPCAt': lastConfirmPCAt,
        'lastConfirmTel': lastConfirmTel,
        'lastConfirmTelAt': lastConfirmTelAt,
        'lastConfirmCoupon': lastConfirmCoupon,
        'lastConfirmCouponAt': lastConfirmCouponAt,
        'lastConfirmCalendar': lastConfirmCalendar,
        'lastConfirmCalendarAt': lastConfirmCalendarAt,
        'lastConfirmMoney': lastConfirmMoney,
        'lastConfirmMoneyAt': lastConfirmMoneyAt,
        'lastConfirmLock': lastConfirmLock,
        'lastConfirmLockAt': lastConfirmLockAt,
        'lastConfirmUser': lastConfirmUser,
        'lastConfirmUserAt': lastConfirmUserAt,
        'lastConfirmUserName': lastConfirmUserName,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
      });
    } catch (e) {
      error = '日報の保存に失敗しました';
    }
    return error;
  }

  Future<String?> approval({
    required ReportModel report,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (loginUser == null) return '日報の承認に失敗しました';
    try {
      _reportService.update({
        'id': report.id,
        'approval': 1,
      });
    } catch (e) {
      error = '日報の承認に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ReportModel report,
  }) async {
    String? error;
    try {
      _reportService.delete({
        'id': report.id,
      });
    } catch (e) {
      error = '日報の削除に失敗しました';
    }
    return error;
  }
}
