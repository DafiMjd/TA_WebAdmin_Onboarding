import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/menu.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu(
      {Key? key,
      // For selecting those three line once press "Command+D"
      required this.menu,
      required this.press})
      : super(key: key);

  final Menu menu;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: ORANGE_GARUDA,
      selected: false,
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        menu.icon!,
        size: 24,
        color: Colors.white,
      ),
      title: Text(
        menu.title,
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      trailing: Icon(
        (menu.selected)
            ? Icons.keyboard_arrow_down_sharp
            : Icons.keyboard_arrow_right_sharp,
        size: 24,
        color: Colors.white,
      ),
    );
  }
}
