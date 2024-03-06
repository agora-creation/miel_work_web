import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanService {
  String collection = 'plan';
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

  Future<PlanModel?> selectData({
    required String id,
  }) async {
    PlanModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = PlanModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required String? groupId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('groupId', isEqualTo: groupId != '' ? groupId : null)
        .orderBy('startedAt', descending: true)
        .snapshots();
  }

  List<sfc.Appointment> generateListAppointment({
    required QuerySnapshot<Map<String, dynamic>>? data,
    bool shift = false,
  }) {
    List<sfc.Appointment> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      PlanModel plan = PlanModel.fromSnapshot(doc);
      ret.add(sfc.Appointment(
        id: plan.id,
        resourceIds: plan.userIds,
        subject: '[${plan.category}]${plan.subject}',
        startTime: plan.startedAt,
        endTime: plan.endedAt,
        isAllDay: plan.allDay,
        color: shift ? plan.color.withOpacity(0.3) : plan.color,
        notes: 'plan',
      ));
    }
    return ret;
  }
}
