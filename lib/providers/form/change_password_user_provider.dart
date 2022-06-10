import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webadmin_onboarding/utils/constants.dart';

class ChangePasswordUserProvider extends ChangeNotifier {
  bool _isNewPassFieldEmpty = true;

  bool get isNewPassFieldEmpty => _isNewPassFieldEmpty;


  set isNewPassFieldEmpty(bool val) {
    _isNewPassFieldEmpty = val;
    notifyListeners();
  }


  // button disable after save
  bool _isSaveButtonDisabled = false;

  bool get isSaveButtonDisabled => _isSaveButtonDisabled;
  set isSaveButtonDisabled(bool val) {
    _isSaveButtonDisabled = val;
    notifyListeners();
  }
  // ==========================

  // password hide

  bool _isNewPassHidden = true;

  bool get isNewPassHidden => _isNewPassHidden;
  set isNewPassHidden(val) {
    _isNewPassHidden = val;
  }
  void changeNewPassHidden() {
    _isNewPassHidden = !_isNewPassHidden;
    notifyListeners();
  }



  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
  }

}
