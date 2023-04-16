import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/models/user.dart';
import 'package:gsm_chat/provider/image_upload_provider.dart';
import 'package:gsm_chat/resources/chat_group_methods.dart';
import 'package:gsm_chat/resources/chat_methods.dart';

class StorageGroupMethods {
  static final Firestore firestore = Firestore.instance;

  StorageReference _storageReference;

  //user class
  User user = User();

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    @required File image,
    @required String groupName,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatGroupMethods chatMethods = ChatGroupMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    // chatMethods.setImageMsg(url, receiverId, senderId);
  }
}