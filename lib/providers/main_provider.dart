import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier{
  bool _isDevicePreview = false;
  get isDevicePreview => _isDevicePreview;
  set isDevicePreview(val) {
    _isDevicePreview = val;
    notifyListeners();
  }
  
}