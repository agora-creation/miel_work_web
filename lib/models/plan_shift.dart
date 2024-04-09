import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';

class PlanShiftModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  List<String> userIds = [];
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  bool _allDay = false;
  bool _repeat = false;
  String _repeatInterval = '';
  int _repeatEvery = 0;
  List<String> repeatWeeks = [];
  int _alertMinute = 0;
  DateTime _alertedAt = DateTime.now();
  DateTime _createdAt = DateTime.now();
  DateTime _expirationAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  bool get allDay => _allDay;
  bool get repeat => _repeat;
  String get repeatInterval => _repeatInterval;
  int get repeatEvery => _repeatEvery;
  int get alertMinute => _alertMinute;
  DateTime get alertedAt => _alertedAt;
  DateTime get createdAt => _createdAt;
  DateTime get expirationAt => _expirationAt;

  PlanShiftModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    userIds = _convertUserIds(data['userIds']);
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _allDay = data['allDay'] ?? false;
    _repeat = data['repeat'] ?? false;
    _repeatInterval = data['repeatInterval'] ?? '';
    _repeatEvery = data['repeatEvery'] ?? 0;
    repeatWeeks = _convertRepeatWeeks(data['repeatWeeks'] ?? []);
    _alertMinute = data['alertMinute'] ?? 0;
    _alertedAt = data['alertedAt'].toDate() ?? DateTime.now();
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
    _expirationAt = data['expirationAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  List<String> _convertRepeatWeeks(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  String? getRepeatRule() {
    String? ret;
    if (_repeat) {
      if (_repeatInterval == kRepeatIntervals[0]) {
        ret = 'FREQ=DAILY;';
        if (_repeatEvery > 0) {
          ret += 'INTERVAL=$_repeatEvery;';
        }
      } else if (_repeatInterval == kRepeatIntervals[1]) {
        ret = 'FREQ=WEEKLY;';
        if (_repeatEvery > 0) {
          ret += 'INTERVAL=$_repeatEvery;';
        }
        if (repeatWeeks.isNotEmpty) {
          String byday = '';
          for (String week in repeatWeeks) {
            if (byday != '') byday += ',';
            byday += ruleConvertWeek(week);
          }
          ret += 'BYDAY=$byday;';
        }
      } else if (_repeatInterval == kRepeatIntervals[2]) {
        ret = 'FREQ=MONTHLY;';
        if (_repeatEvery > 0) {
          ret += 'INTERVAL=$_repeatEvery;';
        }
      } else if (_repeatInterval == kRepeatIntervals[3]) {
        ret = 'FREQ=YEARLY;';
        if (_repeatEvery > 0) {
          ret += 'INTERVAL=$_repeatEvery;';
        }
      }
    }
    return ret;
  }
}
