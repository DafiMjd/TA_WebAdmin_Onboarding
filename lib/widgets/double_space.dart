import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/constants.dart';

class DoubleSpace extends StatelessWidget {
  const DoubleSpace({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: DEFAULT_PADDING * 2,
    );
  }
}