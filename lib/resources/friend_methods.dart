import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsm_chat/constants/strings.dart';
import 'package:gsm_chat/models/friend.dart';
import 'package:gsm_chat/models/request.dart';
import 'package:gsm_chat/models/user.dart';

class FriendMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _requestCollection =
      _firestore.collection(FRIENDS_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addFriendToDb(
      Request request, User sender, User receiver) async {
    var map = request.toMap();

    await _requestCollection
        .document(request.senderId)
        .collection(request.receiverId)
        .add(map);

    addToFriend(senderId: request.senderId, receiverId: request.receiverId);

    return await _requestCollection
        .document(request.receiverId)
        .collection(request.senderId)
        .add(map);
  }

  Future<void> updateFriendToDb(
      Request request, User sender, User receiver) async {
    var map = request.toMap();

    await _requestCollection
        .document(request.senderId)
        .collection(request.receiverId)
        .add(map);

    return await _requestCollection
        .document(request.receiverId)
        .collection(request.senderId)
        .add(map);
  }

  Future<void> deleteFriendToDb(String sender, String receiver) async {
    _userCollection
          .document(sender)
          .collection(FRIENDS_COLLECTION)
          .document(receiver).delete();

    _userCollection
          .document(receiver)
          .collection(FRIENDS_COLLECTION)
          .document(sender).delete();      

    await _requestCollection
        .document(sender)
        .collection(receiver)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });

    return await _requestCollection
        .document(receiver)
        .collection(sender)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }

  DocumentReference getFriendsDocument({String of, String forFriend}) =>
      _userCollection
          .document(of)
          .collection(FRIENDS_COLLECTION)
          .document(forFriend);

  addToFriend({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderFriend(senderId, receiverId, currentTime);
    await addToReceiverFriend(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderFriend(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getFriendsDocument(of: senderId, forFriend: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Friend receiverFriend = Friend(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverFriend.toMap(receiverFriend);

      await getFriendsDocument(of: senderId, forFriend: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverFriend(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getFriendsDocument(of: receiverId, forFriend: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Friend senderFriend = Friend(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderFriend.toMap(senderFriend);

      await getFriendsDocument(of: receiverId, forFriend: senderId)
          .setData(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchFriends({String userId}) => _userCollection
      .document(userId)
      .collection(FRIENDS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _requestCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
