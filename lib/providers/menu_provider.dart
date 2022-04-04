import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/menu.dart';
import 'package:webadmin_onboarding/utils/column_name_parse.dart';

class MenuProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  final List<Menu> _listMenu = [
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
          Menu(id: "category_list", title: "Category List")
        ]),
  ];

  get listMenu => _listMenu;

  late Map<String, dynamic> _jwt;
  get jwt => _jwt;

  void receiveJWT(jwt) {
    _jwt = jwt;
    notifyListeners();
  }

  late List<dynamic> _data;
  get data => _data;
  set data(val) {
    _data = val;
  }

  late List<String> _colnames;
  get colnames => _colnames;
  set colnames(val) {
    _colnames = val;
  }

  bool _isTableShown = false;
  get isTableShown => _isTableShown;
  set isTableShown(val) {
    _isTableShown = val;
    notifyListeners();
  }

  bool _isFormShown = false;
  get isFormShown => _isFormShown;
  set isFormShown(val) {
    _isFormShown = val;
    notifyListeners();
  }

  String _menuName = "Selamat Datang";
  get menuName => _menuName;
  set menuName(val) {
    _menuName = val;
  }

  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
    notifyListeners();
  }

  void showTable(data, colnames, menuTitle, menuId) {
    menuName = menuTitle;
    this.menuId = menuId;
    this.data = data;
    this.colnames = colnames;
    isTableShown = true;

    notifyListeners();
  }

  late String _menuId;
  get menuId => _menuId;
  set menuId(val) {
    _menuId = val;
  }

  void showForm(actionId) {
    isTableShown = false;
    isFormShown = true;

  }

  void closeForm() {
    isTableShown = true;
    isFormShown = false;

  }

  void getAction(id) {
    if (id == 'add') {
      isTableShown = false;
      isFormShown = true;
    }
  }
}
