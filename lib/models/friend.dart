import 'package:cloud_firestore/cloud_firestore.dart';

class Friend  {
  String uid;
  Timestamp addedOn;

  Friend({
    this.uid,
    this.addedOn,
  });

  Map toMap(Friend contact) {
    var data = Map<String, dynamic>();
    data['friend_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Friend.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['friend_id'];
    this.addedOn = mapData["added_on"];
  }
}