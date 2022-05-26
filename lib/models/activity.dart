// ignore_for_file: non_constant_identifier_names

import 'package:webadmin_onboarding/models/category.dart';

class Activity {
  int? id;
  String? activity_name, activity_description, cover_link;
  ActivityCategory? category;
  String type;

  Activity(
      {this.id,
      this.activity_name,
      this.activity_description,
      this.category,
      this.cover_link,
      required this.type});

  factory Activity.fromJson(Map<String, dynamic> json) {
    var cover = (json['cover'] == null) ? '' : json['cover'];
    return Activity(
      id: json['id'],
      activity_name: json['activity_name'],
      activity_description: json['activity_description'],
      category: ActivityCategory.fromJson(json['category_']),
      type: json['type'],
      cover_link: cover,
    );
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'activity_name') {
      return activity_name;
    } else if (identifier == 'activity_description') {
      return activity_description;
    } else if (identifier == 'category_') {
      return category!.category_name;
    }else if (identifier == 'cover') {
      return cover_link;
    }else if (identifier == 'type') {
      return type;
    } else {
      return "not found";
    }
  }

  @override
  String toString() {
    return "id: " +
        id.toString() +
        "\nact name: " +
        activity_name! +
        "\ndesc: " +
        activity_description! +
        "\ncat: " +
        category!.category_name;
  }
}
