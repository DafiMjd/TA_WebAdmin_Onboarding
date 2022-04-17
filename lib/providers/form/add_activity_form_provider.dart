import 'package:flutter/material.dart';

class AddActivityFormProvider extends ChangeNotifier {
  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
    notifyListeners();
  }

  // form validation

  bool _isActNameEmpty = true;
  bool _isActDescEmpty = true;
  bool _isCategoryEmpty = true;

  bool get isActNameEmpty => _isActNameEmpty;
  bool get isActDescEmpty => _isActDescEmpty;
  bool get isCategoryEmpty => _isCategoryEmpty;

  set isActNameEmpty(bool val) {
    _isActNameEmpty = val;
    notifyListeners();
  }

  set isActDescEmpty(bool val) {
    _isActDescEmpty = val;
    notifyListeners();
  }

  set isCategoryEmpty(bool val) {
    _isCategoryEmpty = val;
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
