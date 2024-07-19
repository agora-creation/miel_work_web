import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_web/models/chat.dart';
import 'package:miel_work_web/models/chat_message.dart';
import 'package:miel_work_web/models/reply_source.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/chat.dart';
import 'package:miel_work_web/services/chat_message.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:path/path.dart' as p;

class ChatMessageProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final ChatMessageService _messageService = ChatMessageService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> send({
    required ChatModel? chat,
    required UserModel? loginUser,
    required String content,
    required ReplySourceModel? replySource,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    if (content == '') return 'メッセージは必須入力です';
    try {
      String id = _messageService.id();
      List<Map> readUsers = [];
      readUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': content,
        'image': '',
        'file': '',
        'fileExt': '',
        'readUsers': readUsers,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
        'replySource': replySource?.toMap(),
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
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}からのメッセージ',
            body: content,
          );
        }
      }
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }

  Future<String?> sendImage({
    required ChatModel? chat,
    required UserModel? loginUser,
    required FilePickerResult? result,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    if (result == null) return 'メッセージの送信に失敗しました';
    try {
      String id = _messageService.id();
      String content = '画像を送信しました';
      Uint8List? uploadFile = result.files.single.bytes;
      if (uploadFile == null) return 'メッセージの送信に失敗しました';
      String fileName = p.basename(result.files.single.name);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('chat/${chat.id}/$id/$fileName');
      UploadTask uploadTask = storageRef.putData(uploadFile);
      TaskSnapshot downloadUrl = await uploadTask;
      String url = (await downloadUrl.ref.getDownloadURL());
      List<Map> readUsers = [];
      readUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': content,
        'image': url,
        'file': '',
        'fileExt': '',
        'readUsers': readUsers,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
        'replySource': null,
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
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}からのメッセージ',
            body: content,
          );
        }
      }
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }

  Future<String?> sendFile({
    required ChatModel? chat,
    required UserModel? loginUser,
    required FilePickerResult? result,
  }) async {
    String? error;
    if (chat == null) return 'メッセージの送信に失敗しました';
    if (loginUser == null) return 'メッセージの送信に失敗しました';
    if (result == null) return 'メッセージの送信に失敗しました';
    try {
      String id = _messageService.id();
      String content = 'ファイルを送信しました';
      Uint8List? uploadFile = result.files.single.bytes;
      if (uploadFile == null) return 'メッセージの送信に失敗しました';
      String ext = p.extension(result.files.single.name);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('chat/${chat.id}/$id$ext');
      UploadTask uploadTask = storageRef.putData(uploadFile);
      TaskSnapshot downloadUrl = await uploadTask;
      String url = (await downloadUrl.ref.getDownloadURL());
      List<Map> readUsers = [];
      readUsers.add({
        'userId': loginUser.id,
        'userName': loginUser.name,
        'createdAt': DateTime.now(),
      });
      _messageService.create({
        'id': id,
        'organizationId': chat.organizationId,
        'groupId': chat.groupId,
        'chatId': chat.id,
        'content': content,
        'image': '',
        'file': url,
        'fileExt': ext,
        'readUsers': readUsers,
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
        'replySource': null,
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
          if (user.id == loginUser.id) continue;
          _fmService.send(
            token: user.token,
            title: '[${chat.name}]${loginUser.name}からのメッセージ',
            body: content,
          );
        }
      }
    } catch (e) {
      error = 'メッセージの送信に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required ChatMessageModel message,
  }) async {
    String? error;
    try {
      _messageService.delete({
        'id': message.id,
      });
    } catch (e) {
      error = 'メッセージの削除に失敗しました';
    }
    return error;
  }
}
