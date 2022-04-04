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
  bool _isRoleFieldEmpty = true;

  bool get isEmailFieldEmpty => _isEmailFieldEmpty;
  bool get isPwFieldEmpty => _isPwFieldEmpty;
  bool get isNameFieldEmpty => _isNameFieldEmpty;
  bool get isRoleFieldEmpty => _isRoleFieldEmpty;

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

  set isRoleFieldEmpty(bool val) {
    _isRoleFieldEmpty = val;
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
