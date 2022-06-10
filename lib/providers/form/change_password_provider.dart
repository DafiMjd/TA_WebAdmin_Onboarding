import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webadmin_onboarding/utils/constants.dart';

class ChangePasswordProvider extends ChangeNotifier {
  bool _isCurPassFieldEmpty = true;
  bool _isNewPassFieldEmpty = true;
  bool _isConfPassFieldEmpty = true;

  bool get isCurPassFieldEmpty => _isCurPassFieldEmpty;
  bool get isNewPassFieldEmpty => _isNewPassFieldEmpty;
  bool get isConfPassFieldEmpty => _isConfPassFieldEmpty;

  set isCurPassFieldEmpty(bool val) {
    _isCurPassFieldEmpty = val;
    notifyListeners();
  }

  set isNewPassFieldEmpty(bool val) {
    _isNewPassFieldEmpty = val;
    notifyListeners();
  }

  set isConfPassFieldEmpty(bool val) {
    _isConfPassFieldEmpty = val;
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
  bool _isCurPassHidden = true;

  bool get isCurPassHidden => _isCurPassHidden;
  set isCurPassHidden(val) {
    _isCurPassHidden = true;
  }
  void changeCurPassHidden() {
    _isCurPassHidden = !_isCurPassHidden;
    notifyListeners();
  }

  bool _isNewPassHidden = true;

  bool get isNewPassHidden => _isNewPassHidden;
  set isNewPassHidden(val) {
    _isNewPassHidden = true;
  }
  void changeNewPassHidden() {
    _isNewPassHidden = !_isNewPassHidden;
    notifyListeners();
  }

  bool _isConfPassHidden = true;

  bool get isConfPassHidden => _isConfPassHidden;
  set isConfPassHidden(val) {
    _isConfPassHidden = true;
  }
  void changeConfPassHidden() {
    _isConfPassHidden = !_isConfPassHidden;
    notifyListeners();
  }
  // ==========================

  // validate new pass and conf pass
  bool _isPassDifferent = false;
  get isPassDifferent => _isPassDifferent;
  set isPassDifferent(val) {
    _isPassDifferent = val;
    notifyListeners();
  }


  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
  }

}
