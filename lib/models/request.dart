import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String uid;
  String senderId;
  String receiverId;
  String type;
  String message;
  Timestamp timestamp;

  Request(
      {
        this.uid,
        this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = this.uid;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['uid'] = this.uid;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  // named constructor
  Request.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
  }
}
