import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/constants.dart';

class Space {
  
  
  static space() {
    return SizedBox(
      height: DEFAULT_PADDING,
    );
  }static doubleSpace() {
    return SizedBox(
      height: DEFAULT_PADDING * 2,
    );
  }
  static halfSpace() {
    return SizedBox(
      height: DEFAULT_PADDING / 2,
    );
  }
}
