import 'package:intl/intl.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/role.dart';

class User {
  int progress;

  String email, name, gender, phone_number;
  String birtdate;
  Role role;
  Jobtitle jobtitle;

  User(
      {required this.email,
      required this.name,
      required this.gender,
      required this.phone_number,
      required this.progress,
      required this.birtdate,
      required this.role,
      required this.jobtitle,});

  factory User.fromJson(Map<String, dynamic> json) {
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final DateTime birtDate = DateTime.parse(json['birthdate']);
    // final String dateFormatted = formatter.format(birtDate);

    return User(
        email: json['email'],
        name: json['name'],
        gender: json['gender'],
        phone_number: json['phone_number'],
        progress: json['progress'],
        role: Role.fromJson(json['role_']),
        jobtitle: Jobtitle.fromJson(json['jobtitle_']),
        birtdate: json['birthdate']);
  }

  dynamic getData(String identifier) {
    if (identifier == 'email')
      return email;
    else if (identifier == 'name')
      return name;
    else if (identifier == 'gender')
      return gender;
    else if (identifier == 'phone_number')
      return phone_number;
    else if (identifier == 'progress')
      return progress;
    else if (identifier == 'birthdate')
      return birtdate;
    else if (identifier == 'role_')
      return role.role_name;
    else if (identifier == 'jobtitle_')
      return jobtitle.jobtitle_name;
    else
      return "not found";
  }
}
