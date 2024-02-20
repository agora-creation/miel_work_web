import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_web/models/organization.dart';

class OrganizationService {
  String collection = 'organization';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<OrganizationModel?> selectData({
    required String loginId,
    required String password,
  }) async {
    OrganizationModel? ret;
    await firestore
        .collection(collection)
        .where('loginId', isEqualTo: loginId)
        .where('password', isEqualTo: password)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = OrganizationModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }
}
