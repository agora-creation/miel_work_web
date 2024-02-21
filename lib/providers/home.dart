import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/services/organization_group.dart';

class HomeProvider with ChangeNotifier {
  int currentIndex = 0;
  final OrganizationGroupService _groupService = OrganizationGroupService();
  List<OrganizationGroupModel> groups = [];
  OrganizationGroupModel? currentGroup;

  void currentIndexChange(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void setGroups({
    required OrganizationModel? organization,
  }) async {
    if (organization != null) {
      groups = await _groupService.selectList(organizationId: organization.id);
      if (groups.isNotEmpty) {
        currentGroup = groups.first;
      } else {
        currentGroup = null;
      }
    } else {
      groups = [];
      currentGroup = null;
    }
    notifyListeners();
  }

  void currentGroupChange(OrganizationGroupModel group) {
    currentGroup = group;
    notifyListeners();
  }

  void currentGroupClear() {
    currentGroup = null;
    notifyListeners();
  }

  Future<String?> groupCreate({
    required OrganizationModel? organization,
    required String name,
  }) async {
    String? error;
    if (name == '') return 'グループ名は必須です';
    try {
      String id = _groupService.id(organizationId: organization?.id ?? '');
      _groupService.create({
        'id': id,
        'organizationId': organization?.id,
        'name': name,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'グループの追加に失敗しました';
    }
    return error;
  }
}
