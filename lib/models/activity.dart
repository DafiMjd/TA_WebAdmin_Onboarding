// ignore_for_file: non_constant_identifier_names

import 'package:webadmin_onboarding/models/category.dart';

class Activity {
  int? id;
  String? activity_name, activity_description;
  ActivityCategory? category;

  Activity({this.id, this.activity_name, this.activity_description, this.category});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activity_name: json['activity_name'],
      activity_description: json['activity_description'],
      category: ActivityCategory.fromJson(json['category_']),
    );
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'activity_name') {
      return activity_name;
    } else if (identifier == 'activity_description') {
      return activity_description;
    }
    else if (identifier == 'category_') {
      return category!.category_name;
    } else {
      return "not found";
    }
  }

  @override
  String toString() {
    return "id: " + id.toString() + 
    "\nact name: " + activity_name! + 
    "\ndesc: " + activity_description! + 
    "\ncat: " + category!.category_name;
  }
}
