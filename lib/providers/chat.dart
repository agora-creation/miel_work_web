import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/services/chat.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required String name,
  }) async {
    String? error;
    if (organization == null) return 'チャットルームの作成に失敗しました';
    if (name == '') return 'ルーム名を入力してください';
    List<String> userIds = [];
    if (group != null) {
      userIds = group.userIds;
    } else {
      userIds = organization.userIds;
    }
    try {
      String id = _chatService.id();
      _chatService.create({
        'id': id,
        'organizationId': organization.id,
        'groupId': group?.id ?? '',
        'userIds': userIds,
        'name': name,
        'lastMessage': '',
        'personal': false,
        'priority': 1,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = 'チャットルームの作成に失敗しました';
    }
    return error;
  }
}
