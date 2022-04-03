

class Admin {
  final String email, admin_name;
  

  Admin(
      {required this.email,
      required this.admin_name,});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        email: json['email'],
        admin_name: json['admin_name']);
  }

  dynamic getData(String identifier) {
    if (identifier == 'email')
      return email;
    else if (identifier == 'admin_name')
      return admin_name;
    else
      return "not found";
  }
}
