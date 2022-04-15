// ignore_for_file: non_constant_identifier_names

class Jobtitle {
  final int id;
  final String jobtitle_name, jobtitle_description;

  Jobtitle(
      {required this.id,
      required this.jobtitle_name,
      required this.jobtitle_description,});

  factory Jobtitle.fromJson(Map<String, dynamic> json) {
    return Jobtitle(
        id: json['id'],
        jobtitle_name: json['jobtitle_name'],
        jobtitle_description: json['jobtitle_description']);
  }

  dynamic getData(String identifier) {
    if (identifier == 'id') {
      return id;
    } else if (identifier == 'jobtitle_name') {
      return jobtitle_name;
    } else if (identifier == 'jobtitle_description') {
      return jobtitle_description;
    } else {
      return "not found";
    }
  }
}
