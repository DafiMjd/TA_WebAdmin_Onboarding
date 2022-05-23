// ignore_for_file: non_constant_identifier_names

import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/role.dart';

class Admin {
  final String email, admin_name, gender, birthdate, phone_number;
  final Role role;
  final Jobtitle jobtitle;

  bool active;

  Admin(
      {required this.email,
      required this.admin_name,
      required this.role,
      required this.birthdate,
      required this.gender,
      required this.jobtitle,
      required this.phone_number,
      required this.active});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      email: json['email'],
      admin_name: json['admin_name'],
      role: Role.fromJson(json['role_']),
      jobtitle: Jobtitle.fromJson(json['jobtitle_']),
      gender: json['gender'],
      birthdate: json['birthdate'],
      phone_number: json['phone_number'],
      active: json['active']
    );
  }

  dynamic getData(String identifier) {
    if (identifier == 'email') {
      return email;
    } else if (identifier == 'admin_name') {
      return admin_name;
    } else if (identifier == 'role_') {
      return role.role_name;
    } else if (identifier == 'jobtitle_') {
      return jobtitle.jobtitle_name;
    } else if (identifier == 'gender') {
      return gender;
    } else if (identifier == 'birthdate') {
      return birthdate;
    } else if (identifier == 'phone_number') {
      return phone_number;
    } else if (identifier == 'active') {
      return active;
    } else {
      return "not found";
    }
  }
}
