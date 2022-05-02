import 'package:flutter/material.dart';

class Menu {
  final String id;
  final String title;
  final IconData? icon;
  final List<Menu>? submenu;
  bool selected = true;

  Menu({required this.id, required this.title, this.icon = Icons.circle, this.submenu});

  bool hasSubMenu() => submenu != null;


}