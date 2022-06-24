// ignore_for_file: non_constant_identifier_names

class ActivityOwned {
  final int id, activity_id;
  final String user_email, status, activity_name, user_name;
  String start_date, end_date;
  String? mentor_email, activity_note;

  ActivityOwned(
      {required this.id,
      required this.activity_id,
      required this.activity_name,
      required this.user_email,
      required this.status,
      required this.start_date,
      required this.end_date,
      this.mentor_email,
      this.activity_note,
      required this.user_name});

  factory ActivityOwned.fromJson(Map<String, dynamic> json) {
    return ActivityOwned(
      id: json['id'],
      activity_id: json['activities_']['id'],
      activity_name: json['activities_']['activity_name'],
      user_email: json['user_']['email'],
      start_date: json['start_date'],
      end_date: json['end_date'],
      status: json['status'],
      mentor_email: json['mentor_email'],
      activity_note: json['activity_note'],
      user_name: json['user_']['name'],
    );
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'activity_id') {
      return activity_id;
    } else if (identifier == 'activity_name') {
      return activity_name;
    } else if (identifier == 'user_email') {
      return user_email;
    } else if (identifier == 'user_name') {
      return user_name;
    } else if (identifier == 'status') {
      return status;
    } else if (identifier == 'start_date') {
      return start_date;
    } else if (identifier == 'end_date') {
      return end_date;
    } else {
      return "not found";
    }
  }
}
