import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/activity.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';

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

  // form yang digunakan bergantian untuk setiap activity detail
  bool _isActDetailEmpty = true;
  bool get isActDetailEmpty => _isActDetailEmpty;
  set isActDetailEmpty(bool val) {
    _isActDetailEmpty = val;
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

  // Activity Details

  late Activity _activity;
  Activity get activity => _activity;
  set activity(val) {
    _activity = val;
    notifyListeners();
  }

  late List<ActivityDetail> _actDetails;
  List<ActivityDetail> get actDetails => _actDetails;
  set actDetails(val) {
    _actDetails = val;
    notifyListeners();
  }
  // ==========================
}
