import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class DrawerSubmenu extends StatelessWidget {
  const DrawerSubmenu(
      {Key? key,
      // For selecting those three line once press "Command+D"
      required this.title,
      required this.icon,
      required this.press})
      : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: ListTile(
        selectedColor: ORANGE_GARUDA,
        selected: true,
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 12, color: Colors.white,
        ),
        title: Text(
          title,
        style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
