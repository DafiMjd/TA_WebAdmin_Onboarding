// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/menu.dart';

const DEFAULT_PADDING = 16.0;

// caption in text theme is theme for text in menu
// bodytext2 in text theme is theme for text in dashboard

const BASE_URL = "https://cf9f-114-122-104-222.ngrok.io";

final List<Menu> MENU_SUPER_ADMIN = [
  Menu(
      id: "manage_user",
      title: "Manage User",
      icon: Icons.account_circle,
      submenu: [
        Menu(id: "user_list", title: "User List"),
        Menu(id: "admin_list", title: "Admin List"),
        Menu(id: "role_list", title: "Role List"),
        Menu(id: "jobtitle_list", title: "Jobtitle List"),
      ]),
  Menu(
      id: "manage_activity",
      title: "ManageActivity",
      icon: Icons.task,
      submenu: [
        Menu(id: "activity_list", title: "Activity List"),
        Menu(id: "home_activity_list", title: "Home Activity List"),
        Menu(id: "category_list", title: "Category List"),
        Menu(id: "activity_owned_list", title: "Activity Owned List"),
      ]),
];

final List<Menu> MENU_ADMIN = [
  Menu(
      id: "manage_user",
      title: "Manage User",
      icon: Icons.account_circle,
      submenu: [
        Menu(id: "user_list", title: "User List"),
        Menu(id: "role_list", title: "Role List"),
        Menu(id: "jobtitle_list", title: "Jobtitle List"),
      ]),
  Menu(
      id: "manage_activity",
      title: "ManageActivity",
      icon: Icons.task,
      submenu: [
        Menu(id: "activity_list", title: "Activity List"),
        Menu(id: "home_activity_list", title: "Home Activity List"),
        Menu(id: "category_list", title: "Category List"),
        Menu(id: "activity_owned_list", title: "Activity Owned List"),
      ]),
];
