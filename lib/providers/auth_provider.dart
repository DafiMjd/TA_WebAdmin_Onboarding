// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webadmin_onboarding/utils/constants.dart';

import 'dart:html' show window;

import 'package:webadmin_onboarding/views/main_page.dart';

class AuthProvider with ChangeNotifier {
  late Map<String, dynamic> jwtDecoded;

  late bool _isAuth = false;
  void _setIsAuth(bool val) {
    _isAuth = val;
    notifyListeners();
  }

  void logout() {
    window.localStorage.remove("csrf");
    notifyListeners();
  }


  Widget authenticated() {
    var jwt = window.localStorage["csrf"];
    jwtDecoded = jsonDecode(jwt!);


    String role = jwtDecoded['role'];

    return MainPage(role: role);
  }

  bool getIsAuth() {
    var csrfTokenOrEmpty = window.localStorage.containsKey("csrf")
        ? window.localStorage["csrf"]
        : "";
    
    if (csrfTokenOrEmpty != "") {
      var str = csrfTokenOrEmpty;
      var token = str!.split(".");

      Map<String, dynamic> data = jsonDecode(str);

      if (DateTime.now()
          .add(Duration(seconds: int.parse(data['expiresIn'])))
          .isAfter(DateTime.now())) {
        _setIsAuth(true);
        return _isAuth;
      } else {
        window.localStorage.remove("csrf");
        _setIsAuth(false);
        return _isAuth;
      }
    } else {
      window.localStorage.remove("csrf");
      _setIsAuth(false);
      return _isAuth;
    }
  }

  Future<void> auth(String email, String password) async {
    String apiURL = "$BASE_URL/api/Auth/loginAdmin";

    try {
      var apiResult = await http.post(Uri.parse(apiURL),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({"email": email, "password": password}));

      if (apiResult.statusCode == 200) {
        window.localStorage["csrf"] = apiResult.body;
        // notifyListeners();
      }

      if (apiResult.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(apiResult.body);
        throw responseData['errorMessage'];
      }


      if (apiResult.statusCode == 502 || apiResult.statusCode == 500) {
        throw "Server Down";
      }

      isLoginButtonDisabled = false;
    } catch (e) {
      isLoginButtonDisabled = false;
      rethrow;
    }
  }

  // button disable after login
  bool _isLoginButtonDisabled = false;

  bool get isLoginButtonDisabled => _isLoginButtonDisabled;
  set isLoginButtonDisabled(bool val) {
    _isLoginButtonDisabled = val;
    notifyListeners();
  }
  // ==========================

  // form validation
  bool _isEmailFieldEmpty = false;
  bool _isPasswordFieldEmpty = false;

  bool get isEmailFieldEmpty => _isEmailFieldEmpty;
  bool get isPasswordFieldEmpty => _isPasswordFieldEmpty;
  set isEmailFieldEmpty(bool val) {
    _isEmailFieldEmpty = val;
    notifyListeners();
  }

  set isPasswordFieldEmpty(bool val) {
    _isPasswordFieldEmpty = val;
    notifyListeners();
  }
  // ==========================

  // password hide
  bool _isPasswordHidden = true;

  bool get isPasswordHidden => _isPasswordHidden;
  void changePasswordHidden() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }
  // ==========================

  
}
