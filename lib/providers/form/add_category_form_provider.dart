import 'package:flutter/material.dart';

class AddCategoryFormProvider extends ChangeNotifier {
  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
    notifyListeners();
  }

    // form validation

  bool _isCategoryNameEmpty = true;
  bool _isCategoryDescEmpty = true;

  bool get isCategoryNameEmpty => _isCategoryNameEmpty;
  bool get isCategoryDescEmpty => _isCategoryDescEmpty;

  set isCategoryNameEmpty(bool val) {
    _isCategoryNameEmpty = val;
    notifyListeners();
  }
  set isCategoryDescEmpty(bool val) {
    _isCategoryDescEmpty = val;
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