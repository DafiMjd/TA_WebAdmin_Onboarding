// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:webadmin_onboarding/models/activity.dart';

class ActivityDetail {
  int? id;
  int detail_urutan;
  String detail_name, detail_desc, detail_type;
  String? detail_link;
  Activity activity;
  Uint8List? file;

  ActivityDetail(
      {this.id,
      required this.detail_urutan,
      required this.detail_name,
      required this.detail_desc,
      this.detail_link,
      this.file,
      required this.detail_type,
      required this.activity});

  factory ActivityDetail.fromJson(Map<String, dynamic> json) {
    var newAct = ActivityDetail(
      id: json['id'],
      activity: json['activity_'],
      detail_name: json['detail_name'],
      detail_desc: json['detail_desc'],
      detail_link: json['detail_link'],
      detail_type: json['detail_type'],
      detail_urutan: json['detail_urutan'],
    );
    return newAct;
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'activity_') {
      return activity.activity_name;
    } else if (identifier == 'detail_name') {
      return detail_name;
    } else if (identifier == 'detail_desc') {
      return detail_desc;
    } else if (identifier == 'detail_link') {
      return detail_link;
    } else if (identifier == 'detail_type') {
      return detail_type;
    } else if (identifier == 'detail_urutan') {
      return detail_urutan;
    } else {
      return "not found";
    }
  }

  @override
  String toString() {
    return "id: " + id.toString() + 
    "\nact name: " + activity.id.toString() + 
    "\nact name: " + detail_name + 
    "\ndesc: " + detail_desc + 
    "\ntype: " + detail_type + 
    "\nurutan: " + detail_urutan.toString();
  }
}
