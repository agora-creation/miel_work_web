import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/chat.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/chat.dart';
import 'package:miel_work_web/services/chat_message.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/user.dart';

class ChatMessageProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final ChatMessageService _messageService = ChatMessageService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();

  Future<String?> send({
    required ChatModel? chat,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    if (contentController.text == '') return 'メッセージを入力してください';
    try {
      String id = _messageService.id();
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': contentController.text,
        'image': '',
        'readUserIds': [loginUser.id],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _chatService.update({
        'id': chat.id,
        'lastMessage': contentController.text,
        'updatedAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = await _userService.selectList(
        userIds: chat.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}',
            body: contentController.text,
          );
        }
      }
      contentController.clear();
      contentFocusNode.unfocus();
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }

  Future<String?> sendImage({
    required ChatModel? chat,
    required UserModel? loginUser,
    required PlatformFile pickedFile,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    try {
      String id = _messageService.id();
      String content = '画像を送信しました';
      File imageFile = File(pickedFile.path ?? '');
      FirebaseStorage storage = FirebaseStorage.instance;
      String storagePath = 'chat/${chat.id}/$id';
      final task = await storage.ref(storagePath).putFile(imageFile);
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': content,
        'image': await task.ref.getDownloadURL(),
        'readUserIds': [loginUser.id],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _chatService.update({
        'id': chat.id,
        'lastMessage': content,
        'updatedAt': DateTime.now(),
      });
      //通知
      List<UserModel> sendUsers = await _userService.selectList(
        userIds: chat.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}',
            body: content,
          );
        }
      }
      contentController.clear();
      contentFocusNode.unfocus();
    } catch (e) {
      error = 'メッセージの送信に失敗しました$e';
    }
    return error;
  }
}
