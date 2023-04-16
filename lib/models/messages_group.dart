import 'package:cloud_firestore/cloud_firestore.dart';

class MessageGroup {
  String groupName;
  String senderId;
  String senderName;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;

  MessageGroup(
      {this.senderId,this.senderName, this.groupName, this.type, this.message, this.timestamp});

  //Will be only called when you wish to send an image
  // named constructor
  MessageGroup.imageMessageGroup(
      {this.groupName,
      this.senderName,
      this.senderId,
      this.message,
      this.type,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['groupName'] = this.groupName;
    map['senderId'] = this.senderId;
    map['senderName'] = this.senderName;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['groupName'] = this.groupName;
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['senderName'] = this.senderName;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  // named constructor
  MessageGroup.fromMap(Map<String, dynamic> map) {
    this.groupName = map['groupName'];
    this.senderId = map['senderId'];
    this.senderName = map['senderName'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
  }
}
