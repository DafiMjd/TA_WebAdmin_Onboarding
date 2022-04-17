// ignore_for_file: non_constant_identifier_names

import 'package:webadmin_onboarding/models/category.dart';

class Activity {
  final int id;
  final String activity_name, activity_description;
  final ActivityCategory category;

  Activity({required this.id, required this.activity_name, required this.activity_description, required this.category});

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
      return category.category_name;
    } else {
      return "not found";
    }
  }
}
