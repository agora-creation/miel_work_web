import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/models/lost.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/services/fm.dart';
import 'package:miel_work_web/services/lost.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:path/path.dart' as p;
import 'package:signature/signature.dart';

class LostProvider with ChangeNotifier {
  final LostService _lostService = LostService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required OrganizationModel? organization,
    required DateTime discoveryAt,
    required String discoveryPlace,
    required String discoveryUser,
    required String itemName,
    required FilePickerResult? itemImageResult,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '落とし物の追加に失敗しました';
    if (discoveryPlace == '') return '発見場所は必須入力です';
    if (discoveryUser == '') return '発見者は必須入力です';
    if (itemName == '') return '品名は必須入力です';
    if (loginUser == null) return '落とし物の追加に失敗しました';
    try {
      String id = _lostService.id();
      String itemImage = '';
      if (itemImageResult != null) {
        Uint8List? uploadFile = itemImageResult.files.single.bytes;
        if (uploadFile == null) return '添付写真のアップロードに失敗しました';
        String fileName = p.basename(itemImageResult.files.single.name);
        Reference storageRef =
            FirebaseStorage.instance.ref().child('lost/$id/$fileName');
        uploadFile = await compressImage(uploadFile);
        UploadTask uploadTask = storageRef.putData(uploadFile);
        TaskSnapshot downloadUrl = await uploadTask;
        itemImage = (await downloadUrl.ref.getDownloadURL());
      }
      String itemNumber = await _lostService.getLastItemNumber(
        organizationId: organization.id,
      );
      _lostService.create({
        'id': id,
        'organizationId': organization.id,
        'discoveryAt': discoveryAt,
        'discoveryPlace': discoveryPlace,
        'discoveryUser': discoveryUser,
        'itemNumber': itemNumber,
        'itemName': itemName,
        'itemImage': itemImage,
        'remarks': remarks,
        'status': 0,
        'returnAt': DateTime.now(),
        'returnUser': '',
        'signImage': '',
        'readUserIds': [loginUser.id],
        'createdUserId': loginUser.id,
        'createdUserName': loginUser.name,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(days: 365)),
      });
      //通知
      List<UserModel> sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: '落とし物がありました',
              body: itemName,
            );
          }
        }
      }
    } catch (e) {
      error = '落とし物の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required OrganizationModel? organization,
    required LostModel lost,
    required DateTime discoveryAt,
    required String discoveryPlace,
    required String discoveryUser,
    required String itemName,
    required FilePickerResult? itemImageResult,
    required String remarks,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '落とし物情報の編集に失敗しました';
    if (discoveryPlace == '') return '発見場所は必須入力です';
    if (discoveryUser == '') return '発見者は必須入力です';
    if (itemName == '') return '品名は必須入力です';
    if (loginUser == null) return '落とし物の編集に失敗しました';
    try {
      String? itemImage;
      if (itemImageResult != null) {
        Uint8List? uploadFile = itemImageResult.files.single.bytes;
        if (uploadFile == null) return '添付写真のアップロードに失敗しました';
        String fileName = p.basename(itemImageResult.files.single.name);
        Reference storageRef =
            FirebaseStorage.instance.ref().child('lost/${lost.id}/$fileName');
        uploadFile = await compressImage(uploadFile);
        UploadTask uploadTask = storageRef.putData(uploadFile);
        TaskSnapshot downloadUrl = await uploadTask;
        itemImage = (await downloadUrl.ref.getDownloadURL());
      }
      if (itemImage != null) {
        _lostService.update({
          'id': lost.id,
          'discoveryAt': discoveryAt,
          'discoveryPlace': discoveryPlace,
          'discoveryUser': discoveryUser,
          'itemName': itemName,
          'itemImage': itemImage,
          'remarks': remarks,
        });
      } else {
        _lostService.update({
          'id': lost.id,
          'discoveryAt': discoveryAt,
          'discoveryPlace': discoveryPlace,
          'discoveryUser': discoveryUser,
          'itemName': itemName,
          'remarks': remarks,
        });
      }
    } catch (e) {
      error = '落とし物の編集に失敗しました';
    }
    return error;
  }

  Future<String?> updateReturn({
    required OrganizationModel? organization,
    required LostModel lost,
    required DateTime returnAt,
    required String returnUser,
    required String returnCustomer,
    required String returnCustomerAddress,
    required FilePickerResult? returnCustomerIDImageResult,
    required SignatureController signImageController,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '落とし物の返却に失敗しました';
    if (returnUser == '') return '返却スタッフは必須入力です';
    if (loginUser == null) return '落とし物の返却に失敗しました';
    try {
      String returnCustomerIDImage = '';
      if (returnCustomerIDImageResult != null) {
        Uint8List? uploadFile = returnCustomerIDImageResult.files.single.bytes;
        if (uploadFile == null) return '本人確認身分証明書写真のアップロードに失敗しました';
        String fileName =
            p.basename(returnCustomerIDImageResult.files.single.name);
        Reference storageRef =
            FirebaseStorage.instance.ref().child('lost/${lost.id}/$fileName');
        UploadTask uploadTask = storageRef.putData(uploadFile);
        TaskSnapshot downloadUrl = await uploadTask;
        returnCustomerIDImage = (await downloadUrl.ref.getDownloadURL());
      }
      Uint8List? uploadFile = await signImageController.toPngBytes();
      if (uploadFile == null) return '署名のアップロードに失敗しました';
      String fileName = 'sign.png';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('lost/${lost.id}/$fileName');
      uploadFile = await compressImage(uploadFile);
      UploadTask uploadTask = storageRef.putData(uploadFile);
      TaskSnapshot downloadUrl = await uploadTask;
      String signImage = (await downloadUrl.ref.getDownloadURL());
      _lostService.update({
        'id': lost.id,
        'status': 1,
        'returnAt': returnAt,
        'returnUser': returnUser,
        'returnCustomer': returnCustomer,
        'returnCustomerAddress': returnCustomerAddress,
        'returnCustomerIDImage': returnCustomerIDImage,
        'signImage': signImage,
      });
    } catch (e) {
      error = '落とし物の返却に失敗しました';
    }
    return error;
  }

  Future<String?> updateReject({
    required OrganizationModel? organization,
    required LostModel lost,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '落とし物の破棄に失敗しました';
    if (loginUser == null) return '落とし物の破棄に失敗しました';
    try {
      _lostService.update({
        'id': lost.id,
        'status': 9,
      });
    } catch (e) {
      error = '落とし物の破棄に失敗しました';
    }
    return error;
  }

  Future<String?> addComment({
    required OrganizationModel? organization,
    required LostModel lost,
    required String content,
    required UserModel? loginUser,
  }) async {
    String? error;
    if (organization == null) return '社内コメントの追記に失敗しました';
    if (content == '') return '社内コメントの追記に失敗しました';
    if (loginUser == null) return '社内コメントの追記に失敗しました';
    try {
      List<Map> comments = [];
      if (lost.comments.isNotEmpty) {
        for (final comment in lost.comments) {
          comments.add(comment.toMap());
        }
      }
      comments.add({
        'id': dateText('yyyyMMddHHmm', DateTime.now()),
        'userId': loginUser.id,
        'userName': loginUser.name,
        'content': content,
        'createdAt': DateTime.now(),
      });
      _lostService.update({
        'id': lost.id,
        'comments': comments,
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList(
        userIds: organization.userIds,
      );
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          if (user.id == loginUser.id) continue;
          for (final token in user.tokens) {
            _fmService.send(
              token: token,
              title: '『[落とし物]${lost.itemName}』に社内コメントが追記されました',
              body: content,
            );
          }
        }
      }
    } catch (e) {
      error = '社内コメントの追記に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required LostModel lost,
  }) async {
    String? error;
    try {
      _lostService.delete({
        'id': lost.id,
      });
    } catch (e) {
      error = '落とし物情報の削除に失敗しました';
    }
    return error;
  }
}
