import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/loan.dart';

class LoanService {
  String collection = 'loan';
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
    required DateTime? searchStart,
    required DateTime? searchEnd,
    required int searchStatus,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('status', isEqualTo: searchStatus)
          .orderBy('createdAt', descending: true)
          .startAt([endAt]).endAt([startAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('status', isEqualTo: searchStatus)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  List<LoanModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<LoanModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(LoanModel.fromSnapshot(doc));
    }
    return ret;
  }
}
