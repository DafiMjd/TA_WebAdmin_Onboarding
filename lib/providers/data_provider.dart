
import 'package:flutter/foundation.dart';
import 'package:webadmin_onboarding/models/admin.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/role.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/utils/constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider extends ChangeNotifier {
  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
    notifyListeners();
  }

  late Map<String, dynamic> _jwt;
  get jwt => _jwt;

  void receiveJWT(jwt) {
    _jwt = jwt;
    notifyListeners();
  }

  late List<dynamic> _data;
  get data => _data;

  late List<String> _colenames;
  get colnames => _colenames;
  set colnames(val) {
    _colenames = val;
  }

  Future<List<dynamic>> getDatatable(id) async{
    switch(id) {
      case 'user_list': {
        return fetchUsers().then((value) => Future<List<dynamic>>.value(value));
      }
      case 'admin_list': {
        return fetchAdmins();
      }
      case 'role_list': {
        return fetchRoles();
      }

      default: {
        return fetchRoles();
      }
    }
  }


  Future<Role> fetchRoleByID(int id) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Roles/$id";

    try {
      var roleResult = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      return compute(parseRole, roleResult.body);
    } catch (e) {
      throw (e);
    }
  }

  Role parseRole(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return Role.fromJson(parsed);
  }

  Future<List<Role>> fetchRoles() async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Roles";

    try {
      var roleResult = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      return compute(parseRoles, roleResult.body);
    } catch (e) {
      throw (e);
    }
  }

  List<Role> parseRoles(String responseBody) {
    List<Map<String, dynamic>> parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = _getRoleColumnNames(parsed[0]);

    return parsed.map<Role>((json) => Role.fromJson(json)).toList();
  }

  List<String> _getRoleColumnNames(Map<String, dynamic> data) {
    return data.keys.toList();

  }

  Future<Jobtitle> fetchJobtitleByID(int id) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Jobtitle/$id";

    try {
      var jobtitleResult = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      return compute(parseJobtitle, jobtitleResult.body);
    } catch (e) {
      throw (e);
    }
  }

  Jobtitle parseJobtitle(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return Jobtitle.fromJson(parsed);
  }

  Future<List<Jobtitle>> fetchJobtitles() async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Jobtitle";

    try {
      var roleResult = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print("body : " +roleResult.body.toString());

      return compute(parseJobtitles, roleResult.body);
    } catch (e) {
      throw (e);
    }
  }

  List<Jobtitle> parseJobtitles(String responseBody) {
    List<Map<String, dynamic>> parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = _getRoleColumnNames(parsed[0]);
    print("parsed" + parsed.toString());

    return parsed.map<Jobtitle>((json) => Jobtitle.fromJson(json)).toList();
  }

  Future<User> fetchUserByEmail(int email) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/User/$email";

    try {
      var result = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      return compute(parseUser, result.body);
    } catch (e) {
      throw (e);
    }
  }

  User parseUser(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return User.fromJson(parsed);
  }

  Future<List<User>> fetchUsers() async {
    var token = jwt['token'];
    print("token: " + token);

    String url = "$BASE_URL/api/User";

    try {
      var result = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      return compute(parseUsers, result.body);
    } catch (e) {
      throw (e);
    }
  }

  List<User> parseUsers(String responseBody) {
    List<Map<String, dynamic>> parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = _getRoleColumnNames(parsed[0]);

    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<Admin> fetchAdminByEmail(int email) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Admin/$email";

    try {
      var result = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      return compute(parseAdmin, result.body);
    } catch (e) {
      throw (e);
    }
  }

  Admin parseAdmin(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return Admin.fromJson(parsed);
  }

  Future<List<Admin>> fetchAdmins() async {
    var token = jwt['token'];
    print("token: " + token);

    String url = "$BASE_URL/api/Admin";

    try {
      var result = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      return compute(parseAdmins, result.body);
    } catch (e) {
      throw (e);
    }
  }

  List<Admin> parseAdmins(String responseBody) {
    List<Map<String, dynamic>> parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = _getRoleColumnNames(parsed[0]);

    return parsed.map<Admin>((json) => Admin.fromJson(json)).toList();
  }



}
