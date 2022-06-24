import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/constants.dart';

import 'dart:html' show window;

class BaseProvider extends ChangeNotifier {
  late Map<String, dynamic> _jwt;
  get jwt => _jwt;

  void receiveJWT(jwt) {
    _jwt = jwt;
    notifyListeners();
  }

  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
  }

  // API

  Future<bool> checkToken() async {
    var _token = jwt['token'];
    var _email = jwt['email'];
    String url = "$BASE_URL/api/checkToken/$_email?token=$_token";

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
          'Authorization': 'Bearer $_token',
        },
      );
      if (result.statusCode == 404) {
        throw "Not Found";
      }
      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }
      if (result.statusCode == 400) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    window.localStorage.remove("csrf");
    notifyListeners();
  }

  // =========

}
