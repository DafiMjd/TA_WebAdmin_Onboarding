import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/admin.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/menu.dart';
import 'package:webadmin_onboarding/models/role.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_activity_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_admin_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_category_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_jobtitle_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_user_form.dart';
import 'package:webadmin_onboarding/views/dashboard/table.dart';

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

  late List<User> _users;
  late List<Admin> _admins;
  late List<Role> _roles;
  late List<Role> _rolesMobile;
  late List<Role> _rolesWebsite;
  late List<Jobtitle> _jobtitles;

  get users => _users;
  get admins => _admins;
  get roles => _roles;
  get rolesMobile => _rolesMobile;
  get rolesWebsite => _rolesWebsite;
  get jobtitles => _jobtitles;

  set users(val) {
    _users = val;
    notifyListeners();
  }

  set admins(val) {
    _admins = val;
    notifyListeners();
  }

  set roles(val) {
    _roles = val;
    notifyListeners();
  }

  set rolesWebsite(val) {
    _rolesWebsite = val;
    notifyListeners();
  }

  set rolesMobile(val) {
    _rolesMobile = val;
    notifyListeners();
  }

  set jobtitles(val) {
    _jobtitles = val;
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
    if (isFetchingData) {
      dashboardContent = const CircularProgressIndicator();
    } else {
      dashboardContent = Container();
    }
    notifyListeners();
  }

  late String _menuId;
  get menuId => _menuId;
  set menuId(val) {
    _menuId = val;
  }

  void showForm() {
    isTableShown = false;
    isFormShown = true;
  }

  void closeForm() {
    isTableShown = true;
    isFormShown = false;
  }

  Widget _dashboardContent = Container();
  get dashboardContent => _dashboardContent;
  set dashboardContent(val) {
    _dashboardContent = val;
    notifyListeners();
  }

  void setDashboardContent(
      type, dataTable, colnamesTable, menuTitle, menuId, actionForm, dataForm) {
    if (type == "table") {
      isTableShown = true;
      isFormShown = false;
      menuName = menuTitle;
      this.menuId = menuId;
      data = dataTable;
      colnames = colnamesTable;
      if (isFetchingData) {
        dashboardContent = const CircularProgressIndicator();
      } else {
        dashboardContent =
            MyTable(datas: dataTable, colnames: colnamesTable, menuId: menuId);
      }
    } else if (type == "form") {
      isTableShown = false;
      isFormShown = true;
      if (isFetchingData) {
        dashboardContent = const CircularProgressIndicator();
      } else {
        dashboardContent = getForm(menuId, actionForm, dataForm);
      }
    }
    // if (isTableShown) {
    // } else if (isFormShown) {
    //   if (isFetchingData) {
    //     return const CircularProgressIndicator();
    //   }
    //   return getForm(menuId, "add", null);
    // }
    // return Container();
  }

  void getAction(id) {
    if (id == 'add') {
      isTableShown = false;
      isFormShown = true;
    }
  }

  void init() {
    menuName = "Selamat Datang";
    isFormShown = false;
    isTableShown = false;
  }

  Widget getForm(id, action, dynamic data) {
    if (action == "add") {
      if (id == "user_list") {
        return const AddUserForm();
      } else if (id == "admin_list") {
        return const AddAdminForm();
      } else if (id == "category_list") {
        return const AddCategoryForm();
      } else if (id == "jobtitle_list") {
        return const AddJobtitleForm();
      }else if (id == "activity_list") {
        return const AddActivityForm();
      }
      return Container();
    } else if (action == "edit") {
      if (id == "user_list") {
        return const AddUserForm();
      } else if (id == "admin_list") {
        return AddAdminForm(admin: data);
      } else if (id == "category_list") {
        return AddCategoryForm(category: data);
      }else if (id == "jobtitle_list") {
        return AddJobtitleForm(jobtitle: data);
      }
      return Container();
    }
    return Container();
  }
}
