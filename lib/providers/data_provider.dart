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

  late List<String> _colnames;
  get colnames => _colnames;
  set colnames(val) {
    _colnames = val;
  }

  Future<List<dynamic>> getDatatable(id) async {
    switch (id) {
      case 'user_list':
        {
          return fetchUsers();
        }
      case 'admin_list':
        {
          return fetchAdmins();
        }
      case 'role_list':
        {
          return fetchRoles();
        }
      case 'jobtitle_list':
        {
          return fetchJobtitles();
        }

      default:
        {
          return fetchUsers();
        }
    }
  }

  // method to do update and delete
  Future<List<dynamic>> _userAction(method, dataid) async {
    if (method == 'delete') return deleteUser(dataid);
    return fetchUsers();
  }

  Future<List<dynamic>> _adminAction(method, dataid) async {
    if (method == 'delete') return deleteAdmin(dataid);
    return fetchAdmins();
  }

  Future<List<dynamic>> action(id, method, dataid) async {
    switch (id) {
      case 'user_list':
        {
          return _userAction(method, dataid);
        }
      case 'admin_list':
        {
          return _adminAction(method, dataid);
        }

      default:
        {
          return fetchUsers();
        }
    }
  }

  List<String> getColumnNames(Map<String, dynamic> data) {
    return data.keys.toList();
  }

  // Roles request
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
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

    return parsed.map<Role>((json) => Role.fromJson(json)).toList();
  }

  Future<List<Role>> fetchRolesByPlatform(String platform) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Roles/$platform";

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
  // =================

  // Jobtitles request
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

      return compute(parseJobtitles, roleResult.body);
    } catch (e) {
      throw (e);
    }
  }

  List<Jobtitle> parseJobtitles(String responseBody) {
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

    return parsed.map<Jobtitle>((json) => Jobtitle.fromJson(json)).toList();
  }
  // =================

  // Users request
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
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<List<User>> registerUser(String email, String password, String name,
      String phone, String gender, int role_id, int jobtitle_id) async {
    var token = jwt['token'];
    String apiURL = "$BASE_URL/api/Auth/register-user";

    try {
      var apiResult = await http.post(Uri.parse(apiURL),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "email": email,
            "password": password,
            "name": name,
            "gender": gender,
            "phone_number": phone,
            "role_id": role_id,
            "jobtitle_id": jobtitle_id,
            "progress": 0,
            "birthdate": "2000-12-05"
          }));

      if (apiResult.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(apiResult.body);
        throw responseData['errorMessage'];
      }

      return compute(parseUsers, apiResult.body);
    } catch (e) {
      throw e;
    }
  }

  Future<List<User>> deleteUser(String email) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/User/$email";

    try {
      var result = await http.delete(
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

  Future<List<User>> editUser(String email, String password, String name,
      String phone, String gender, int role_id, double progres) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Admin";

    try {
      var result = await http.put(Uri.parse(url),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "email": email,
            "password": password,
            "name": name,
            "gender": gender,
            "phone_number": phone,
            "role_id": role_id,
            "progress": progres
          }));

      return compute(parseUsers, result.body);
    } catch (e) {
      throw (e);
    }
  }

  // =================

  // Admin request
  Future<Admin> fetchAdminByEmail(String email) async {
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
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

    var role = parsed[0]['role_'];

    return parsed.map<Admin>((json) => Admin.fromJson(json)).toList();
  }

  Future<List<Admin>> registerAdmin(
      String email, String password, String name, int role_id) async {
    var token = jwt['token'];
    String apiURL = "$BASE_URL/api/Auth/register-admin";

    try {
      var apiResult = await http.post(Uri.parse(apiURL),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "email": email,
            "password": password,
            "admin_name": name,
            "role_id": role_id,
          }));

      if (apiResult.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(apiResult.body);
        throw responseData['errorMessage'];
      }

      return compute(parseAdmins, apiResult.body);
    } catch (e) {
      throw e;
    }
  }

  Future<List<Admin>> deleteAdmin(String email) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Admin/$email";

    try {
      var result = await http.delete(
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

  Future<List<Admin>> editAdmin(
      String email, String password, String name, int role_id) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Admin";

    try {
      var result = await http.put(Uri.parse(url),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "email": email,
            "password": password,
            "admin_name": name,
            "role_id": role_id,
          }));

      return compute(parseAdmins, result.body);
    } catch (e) {
      throw (e);
    }
  }

  // =================

}
