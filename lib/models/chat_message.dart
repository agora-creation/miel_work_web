import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String _id = '';
  String _chatId = '';
  String _userId = '';
  String _content = '';
  String _image = '';
  List<String> readUserIds = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get chatId => _chatId;
  String get userId => _userId;
  String get content => _content;
  String get image => _image;
  DateTime get createdAt => _createdAt;

  ChatMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data == null) return;
    _id = data['id'] ?? '';
    _chatId = data['chatId'] ?? '';
    _userId = data['userId'] ?? '';
    _content = data['content'] ?? '';
    _image = data['image'] ?? '';
    readUserIds = _convertReadUserIds(data['readUserIds']);
    _createdAt = data['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertReadUserIds(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }
}