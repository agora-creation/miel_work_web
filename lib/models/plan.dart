import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';

class PlanModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  List<String> userIds = [];
  String _category = '';
  String _subject = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  bool _allDay = false;
  Color _color = kPlanColors.first;
  String _memo = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get category => _category;
  String get subject => _subject;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  bool get allDay => _allDay;
  Color get color => _color;
  String get memo => _memo;
  DateTime get createdAt => _createdAt;

  PlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    userIds = _convertUserIds(data['userIds']);
    _category = data['category'] ?? '';
    _subject = data['subject'] ?? '';
    _startedAt = data['startedAt'].toDate() ?? DateTime.now();
    _endedAt = data['endedAt'].toDate() ?? DateTime.now();
    _allDay = data['allDay'] ?? false;
    _color = Color(int.parse(data['color'], radix: 16));
    _memo = data['memo'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}
