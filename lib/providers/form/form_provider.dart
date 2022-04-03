import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  bool _isFieldEmpty = true;
  get isFieldEmpty => _isFieldEmpty;
  set isFieldEmpty(val) {
    _isFieldEmpty = val;
    notifyListeners();
  }
}