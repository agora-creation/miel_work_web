import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigService {
  String collection = 'config';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> getShiftLoginData() async {
    List<String> ret = ['', ''];
    final doc = await firestore.collection(collection).doc('1').get();
    String loginId = doc.data()!['shift_loginId'] as String;
    String password = doc.data()!['shift_password'] as String;
    ret = [loginId, password];
    return ret;
  }

  void updateShiftLoginId(String loginId) {
    firestore.collection(collection).doc('1').update({
      'shift_loginId': loginId,
    });
  }

  void updateShiftPassword(String password) {
    firestore.collection(collection).doc('1').update({
      'shift_password': password,
    });
  }
}
