import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/constants/strings.dart';
import 'package:gsm_chat/models/create.dart';
import 'package:gsm_chat/models/friend.dart';
import 'package:gsm_chat/models/group.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/models/user.dart';

class GroupMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _groupCollection =
      _firestore.collection(GROUPS_COLLECTION);

  final CollectionReference _groupUserCollection =
      _firestore.collection(GROUP_USERS_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  final CollectionReference _groupMessageCollection =
      _firestore.collection(GROUP_MESSAGES_COLLECTION);

  Future<void> addGroupToDb(Detail request, String admin, String member) async {
    var map = request.toMap();

    addToGroup(senderId: request.name, receiverId: member);

    await _groupCollection
      .document(request.name)
      .collection(member).add(map);

    return await _groupUserCollection
        .document(member)
        .collection(GROUPS_COLLECTION).document(request.name).setData(map);
  }

  DocumentReference getGroupsDocument({String of, String forGroup}) =>
      _userCollection
          .document(of)
          .collection(GROUPS_COLLECTION)
          .document(forGroup);

  addToGroup({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    // await addToSenderGroup(senderId, receiverId, currentTime);
    await addToReceiverGroup(senderId, receiverId, currentTime);
  }

  Future<Group> getGroupDetailsById(userId, id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _groupUserCollection
          .document(userId)
          .collection(GROUPS_COLLECTION)
          .document(id).get();
      return Group.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> addToSenderGroup(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getGroupsDocument(of: senderId, forGroup: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Group receiverGroup = Group(
        name: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverGroup.toMap(receiverGroup);

      await getGroupsDocument(of: senderId, forGroup: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverGroup(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getGroupsDocument(of: receiverId, forGroup: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Group senderGroup = Group(
        name: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderGroup.toMap(senderGroup);

      await getGroupsDocument(of: receiverId, forGroup: senderId)
          .setData(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchGroups({String userId}) =>
      _groupUserCollection
      .document(userId)
      .collection(GROUPS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String groupName,
    @required String senderId,
  }) =>
      _groupMessageCollection
          .document(groupName)
          .collection(senderId)
          .orderBy("timestamp")
          .snapshots();
}
