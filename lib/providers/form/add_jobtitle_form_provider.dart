import 'package:flutter/material.dart';

class AddJobtitleFormProvider extends ChangeNotifier {
  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
    notifyListeners();
  }

    // form validation

  bool _isJobtitleNameEmpty = true;
  bool _isJobtitleDescEmpty = true;

  bool get isJobtitleNameEmpty => _isJobtitleNameEmpty;
  bool get isJobtitleDescEmpty => _isJobtitleDescEmpty;

  set isJobtitleNameEmpty(bool val) {
    _isJobtitleNameEmpty = val;
    notifyListeners();
  }
  set isJobtitleDescEmpty(bool val) {
    _isJobtitleDescEmpty = val;
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