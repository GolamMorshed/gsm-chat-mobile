import 'package:cloud_firestore/cloud_firestore.dart';

class Detail {
  String name;
  // String adminId;
  // String memberId;
  Timestamp timestamp;

  Detail(
      {
        this.name,
      this.timestamp});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['name'] = this.name;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['name'] = this.name;
    map['timestamp'] = this.timestamp;
    return map;
  }

  // named constructor
  Detail.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.timestamp = map['timestamp'];
  }
}
