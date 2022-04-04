import 'package:webadmin_onboarding/models/role.dart';

class Admin {
  final String email, admin_name;
  final Role role;

  Admin({required this.email, required this.admin_name, required this.role});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      email: json['email'],
      admin_name: json['admin_name'],
      role: Role.fromJson(json['role_']),
    );
  }

  dynamic getData(String identifier) {
    if (identifier == 'email')
      return email;
    else if (identifier == 'admin_name')
      return admin_name;
    else if (identifier == 'role_')
      return role.role_name;
    else
      return "not found";
  }
}
