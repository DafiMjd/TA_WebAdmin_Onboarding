// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:webadmin_onboarding/models/activity.dart';
import 'package:webadmin_onboarding/models/admin.dart';
import 'package:webadmin_onboarding/models/category.dart';
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
      case 'activity_list':
        {
          return fetchActivities();
        }
      case 'category_list':
        {
          return fetchActivityCategories();
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

  Future<List<dynamic>> _jobtitleAction(method, dataid) async {
    if (method == 'delete') return deleteJobtitle(int.parse(dataid));
    return fetchJobtitles();
  }

  Future<List<dynamic>> _categoryAction(method, dataid) async {
    if (method == 'delete') return deleteActivityCategory(int.parse(dataid));
    return fetchJobtitles();
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
      case 'jobtitle_list':
        {
          return _jobtitleAction(method, dataid);
        }
      case 'category_list':
        {
          return _categoryAction(method, dataid);
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
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  List<Jobtitle> parseJobtitles(String responseBody) {
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

    return parsed.map<Jobtitle>((json) => Jobtitle.fromJson(json)).toList();
  }

  Future<List<Jobtitle>> deleteJobtitle(int id) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Jobtitle/$id";

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

      return compute(parseJobtitles, result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Jobtitle>> createJobtitle(
      String jobtitle_name, String jobtitle_description) async {
    var token = jwt['token'];
    String apiURL = "$BASE_URL/api/Jobtitle";

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
            "jobtitle_name": jobtitle_name,
            "jobtitle_description": jobtitle_description,
          }));

      if (apiResult.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(apiResult.body);
        throw responseData['errorMessage'];
      }

      return compute(parseJobtitles, apiResult.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Jobtitle>> editJobtitle(int id,
      String jobtitle_name, String jobtitle_description) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Jobtitle";

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
            "id": id,
            "jobtitle_name": jobtitle_name,
            "jobtitle_description": jobtitle_description,
          }));

      return compute(parseJobtitles, result.body);
    } catch (e) {
      rethrow;
    }
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
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  Future<List<User>> editUser(String email, String name,
      String phone, String gender, int role_id, int jobtitle_id, double progres, String birthdate) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/User";

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
            "name": name,
            "gender": gender,
            "phone_number": phone,
            "role_id": role_id,
            "jobtitle_id": jobtitle_id,
            "progress": progres,
            "birthdate": birthdate,
          }));


      return compute(parseUsers, result.body);
    } catch (e) {
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  List<Admin> parseAdmins(String responseBody) {
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  // =================

  // ActivityCategory request
  Future<ActivityCategory> fetchActivityCategoryById(int id) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/ActivityCategory/$id";

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

      return compute(parseActivityCategory, result.body);
    } catch (e) {
      rethrow;
    }
  }

  ActivityCategory parseActivityCategory(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return ActivityCategory.fromJson(parsed);
  }

  Future<List<ActivityCategory>> fetchActivityCategories() async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/ActivityCategory";

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

      return compute(parseActivityCategories, result.body);
    } catch (e) {
      rethrow;
    }
  }

  List<ActivityCategory> parseActivityCategories(String responseBody) {
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

    return parsed
        .map<ActivityCategory>((json) => ActivityCategory.fromJson(json))
        .toList();
  }

  Future<List<ActivityCategory>> createActivityCategory(
      String category_name, String category_description, int duration) async {
    var token = jwt['token'];
    String apiURL = "$BASE_URL/api/ActivityCategory";

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
            "category_name": category_name,
            "category_description": category_description,
            "duration": duration,
          }));

      if (apiResult.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(apiResult.body);
        throw responseData['errorMessage'];
      }

      return compute(parseActivityCategories, apiResult.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityCategory>> deleteActivityCategory(int id) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/ActivityCategory/$id";

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

      return compute(parseActivityCategories, result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityCategory>> editActivityCategory(int id,
      String category_name, String category_description, int duration) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/ActivityCategory";

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
            "id": id,
            "category_name": category_name,
            "category_description": category_description,
            "duration": duration,
          }));

      return compute(parseActivityCategories, result.body);
    } catch (e) {
      rethrow;
    }
  }

  // =================

  // Activity request
  Future<Activity> fetchActivityById(String id) async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Activities/$id";

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

      return compute(parseActivity, result.body);
    } catch (e) {
      rethrow;
    }
  }

  Activity parseActivity(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return Activity.fromJson(parsed);
  }

  Future<List<Activity>> fetchActivities() async {
    var token = jwt['token'];

    String url = "$BASE_URL/api/Activities";

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

      return compute(parseActivities, result.body);
    } catch (e) {
      rethrow;
    }
  }

  List<Activity> parseActivities(String responseBody) {
    List<Map<String, dynamic>> parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
    colnames = getColumnNames(parsed[0]);

    return parsed.map<Activity>((json) => Activity.fromJson(json)).toList();
  }
  //===========

}
