import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/lost.dart';

class LostService {
  String collection = 'lost';
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

  Future<LostModel?> selectData({
    required String id,
  }) async {
    LostModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = LostModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Future<String> getLastItemNumber({
    required String? organizationId,
  }) async {
    String ret = '1';
    await firestore
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .orderBy('itemNumber', descending: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        LostModel lost = LostModel.fromSnapshot(value.docs.first);
        int newItemNumber = int.parse(lost.itemNumber) + 1;
        ret = newItemNumber.toString();
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required DateTime? searchStart,
    required DateTime? searchEnd,
    required List<int> searchStatus,
  }) {
    if (searchStart != null && searchEnd != null) {
      Timestamp startAt = convertTimestamp(searchStart, false);
      Timestamp endAt = convertTimestamp(searchEnd, true);
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('status', whereIn: searchStatus)
          .orderBy('createdAt', descending: true)
          .startAt([endAt]).endAt([startAt]).snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('organizationId', isEqualTo: organizationId ?? 'error')
          .where('status', whereIn: searchStatus)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  bool checkAlert({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    bool ret = false;
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      LostModel lost = LostModel.fromSnapshot(doc);
      if (lost.status == 0) {
        ret = true;
      }
    }
    return ret;
  }

  List<LostModel> generateList({
    required QuerySnapshot<Map<String, dynamic>>? data,
  }) {
    List<LostModel> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      ret.add(LostModel.fromSnapshot(doc));
    }
    return ret;
  }
}
