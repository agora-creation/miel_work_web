import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/manual.dart';

class ManualService {
  String collection = 'manual';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required String? groupId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('groupId', isEqualTo: groupId != '' ? groupId : null)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  List<ManualModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<ManualModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(ManualModel.fromSnapshot(doc));
    }
    return ret;
  }
}
