import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu(
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
    return ListTile(
      selectedColor: ORANGE_GARUDA,
      selected: false,
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        size: 24, color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      trailing: Icon(Icons.keyboard_arrow_down_sharp, size: 24, color: Colors.white,),
    );
  }
}
