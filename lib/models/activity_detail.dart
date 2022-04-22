// ignore_for_file: non_constant_identifier_names

import 'package:webadmin_onboarding/models/activity.dart';

class ActivityDetail {
  int? id;
  int? detail_urutan;
  String? detail_name, detail_desc, detail_link, detail_type;
  Activity? activity;

  ActivityDetail(
      {this.id,
      this.detail_urutan,
      this.detail_name,
      this.detail_desc,
      this.detail_link,
      this.detail_type,
      this.activity});

  factory ActivityDetail.fromJson(Map<String, dynamic> json) {
    return ActivityDetail(
      id: json['id'],
      activity: Activity.fromJson(json['activity_']),
      detail_name: json['detail_name'],
      detail_desc: json['detail_desc'],
      detail_link: json['detail_link'],
      detail_type: json['detail_type'],
      detail_urutan: json['detail_urutan'],
    );
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'activity_') {
      return activity!.activity_name;
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
}
