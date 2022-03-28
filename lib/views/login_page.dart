import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BROWN_GARUDA,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          width: MediaQuery.of(context).size.height * 0.7,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Text(
                "Login Administrator",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
