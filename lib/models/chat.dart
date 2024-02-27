import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String _id = '';
  String _organizationId = '';
  List<String> userIds = [];
  String _name = '';
  bool _personal = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get name => _name;
  bool get personal => _personal;
  DateTime get createdAt => _createdAt;

  ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    userIds = _convertUserIds(data['userIds']);
    _name = data['name'] ?? '';
    _personal = data['personal'] ?? false;
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
