import 'package:cloud_firestore/cloud_firestore.dart';

class Group  {
  String name;
  Timestamp addedOn;

  Group({
    this.name,
    this.addedOn,
  });

  Map toMap(Group contact) {
    var data = Map<String, dynamic>();
    data['name'] = contact.name;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Group.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.addedOn = mapData["added_on"];
  }
}