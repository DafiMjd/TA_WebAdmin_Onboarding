

// ignore_for_file: non_constant_identifier_names

class ActivityCategory {
  final int id, duration;
  String category_name, category_description;

  ActivityCategory({required this.id, required this.category_name, required this.category_description, required this.duration});

  factory ActivityCategory.fromJson(Map<String, dynamic> json) {
    return ActivityCategory(
      id: json['id'],
      category_name: json['category_name'],
      category_description: json['category_description'],
      duration: json['duration'],
    );
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'category_name') {
      return category_name;
    } else if (identifier == 'category_description') {
      return category_description;
    } else if (identifier == 'duration') {
      return duration;
    } else {
      return "not found";
    }
  }
}
