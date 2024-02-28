import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/organization.dart';

class OrganizationService {
  String collection = 'organization';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  Future<OrganizationModel?> selectData({
    required String adminUserId,
  }) async {
    OrganizationModel? ret;
    await firestore
        .collection(collection)
        .where('adminUserIds', arrayContains: adminUserId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = OrganizationModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }
}
