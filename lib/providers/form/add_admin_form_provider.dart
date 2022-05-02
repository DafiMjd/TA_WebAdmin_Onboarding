import 'package:flutter/material.dart';

class AddAdminFormProvider extends ChangeNotifier {
  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
    notifyListeners();
  }

  // form validation

  bool _isEmailFieldEmpty = true;
  bool _isPwFieldEmpty = true;
  bool _isNameFieldEmpty = true;
  bool _isPhoneNumFieldEmpty = true;
  bool _isGenderFieldEmpty = true;
  bool _isRoleFieldEmpty = true;
  bool _isJobtitleFieldEmpty = true;

  bool get isEmailFieldEmpty => _isEmailFieldEmpty;
  bool get isPwFieldEmpty => _isPwFieldEmpty;
  bool get isNameFieldEmpty => _isNameFieldEmpty;
  bool get isPhoneNumFieldEmpty => _isPhoneNumFieldEmpty;
  bool get isGenderFieldEmpty => _isGenderFieldEmpty;
  bool get isRoleFieldEmpty => _isRoleFieldEmpty;
  bool get isJobtitleFieldEmpty => _isJobtitleFieldEmpty;

  set isEmailFieldEmpty(bool val) {
    _isEmailFieldEmpty = val;
    notifyListeners();
  }
  set isPwFieldEmpty(bool val) {
    _isPwFieldEmpty = val;
    notifyListeners();
  }
  set isNameFieldEmpty(bool val) {
    _isNameFieldEmpty = val;
    notifyListeners();
  }
  set isPhoneNumFieldEmpty(bool val) {
    _isPhoneNumFieldEmpty = val;
    notifyListeners();
  }
  set isGenderFieldEmpty(bool val) {
    _isGenderFieldEmpty = val;
    notifyListeners();
  }
  set isRoleFieldEmpty(bool val) {
    _isRoleFieldEmpty = val;
    notifyListeners();
  }
  set isJobtitleFieldEmpty(bool val) {
    _isJobtitleFieldEmpty = val;
    notifyListeners();
  }
  // ==========================

  // button disable after save
  bool _isSaveButtonDisabled = false;

  bool get isSaveButtonDisabled => _isSaveButtonDisabled;
  set isSaveButtonDisabled(bool val) {
    _isSaveButtonDisabled = val;
    notifyListeners();
  }
  // ==========================
}
