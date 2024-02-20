import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id = '';
  String _organizationId = '';
  String _groupId = '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _uid = '';
  String _token = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get organizationId => _organizationId;
  String get groupId => _groupId;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get uid => _uid;
  String get token => _token;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _organizationId = data['organizationId'] ?? '';
    _groupId = data['groupId'] ?? '';
    _name = data['name'] ?? '';
    _email = data['email'] ?? '';
    _password = data['password'] ?? '';
    _uid = data['uid'] ?? '';
    _token = data['token'] ?? '';
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }
}
