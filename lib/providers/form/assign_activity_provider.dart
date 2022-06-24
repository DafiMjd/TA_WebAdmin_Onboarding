import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/user.dart';

class AssignActivityProvider extends ChangeNotifier {

  List<User> _selectedUsers = [];
  List<User> get selectedUsers => _selectedUsers;
  set selectedUsers(val) {
    _selectedUsers = val;
    notifyListeners();
  }

  bool _isAssignButtonDisabled = false;
  get isAssignButtonDisabled => _isAssignButtonDisabled;
  set isAssignButtonDisabled(val) {
    _isAssignButtonDisabled = val;
  }

  // String _startDate = '';
  // get startDate => _startDate;
  // set startDate(val) {
  //   _startDate = val;
  //   notifyListeners();
  // }
  // String _startTime = '';
  // get startTime => _startTime;
  // set startTime(val) {
  //   _startTime = val;
  //   notifyListeners();
  // }
  // String _endDate = '';
  // get endDate => _endDate;
  // set endDate(val) {
  //   _endDate = val;
  //   notifyListeners();
  // }
  // String _endTime = '';
  // get endTime => _endTime;
  // set endTime(val) {
  //   _endTime = val;
  //   notifyListeners();
  // }
  // String _startDateAndTime = '';
  // get startDateAndTime => _startDateAndTime;
  // set startDateAndTime(val) {
  //   _startDateAndTime = val;
  //   notifyListeners();
  // }
  // String _endDateAndTime = '';
  // get endDateAndTime => _endDateAndTime;
  // set endDateAndTime(val) {
  //   _endDateAndTime = val;
  //   notifyListeners();
  // }
  

  
  
}