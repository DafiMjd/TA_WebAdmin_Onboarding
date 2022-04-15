

// ignore_for_file: non_constant_identifier_names

class Role {
  final int id;
  final String role_name, role_description, role_platform;
  

  Role(
      {required this.id,
      required this.role_name,
      required this.role_description,
      required this.role_platform});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
        id: json['id'],
        role_name: json['role_name'],
        role_description: json['role_description'],
        role_platform: json['role_platform']);
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'role_name') {
      return role_name;
    } else if (identifier == 'role_description') {
      return role_description;
    } else if (identifier == 'role_platform') {
      return role_platform;
    } else {
      return "not found";
    }
  }
}
