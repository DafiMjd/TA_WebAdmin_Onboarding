// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/admin.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/role.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/providers/form/change_password_provider.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/add_activity_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_admin_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_category_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_jobtitle_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_user_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/change_password_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/change_pw_user_form.dart';
import 'package:webadmin_onboarding/views/dashboard/table2.dart';

class MenuProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

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
      dashboardContent = SizedBox(
          width: 100, height: 100, child: const CircularProgressIndicator());
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
        dashboardContent = SizedBox(
            width: 100, height: 100, child: const CircularProgressIndicator());
      } else {
        dashboardContent =
            MyTable2(datas: dataTable, colnames: colnamesTable, menuId: menuId);
      }
    } else if (type == "form") {
      isTableShown = false;
      isFormShown = true;
      if (isFetchingData) {
        dashboardContent = SizedBox(
            width: 100, height: 100, child: const CircularProgressIndicator());
      } else {
        print('sini1');
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
    dashboardContent = Container();
    isFormShown = false;
    isTableShown = false;
    notifyListeners();
  }

  Widget getForm(id, action, dynamic data) {
    print('sini3');
    if (action == "add") {
      if (id == "user_list") {
        return const AddUserForm();
      } else if (id == "admin_list") {
        return const AddAdminForm();
      } else if (id == "category_list") {
        return const AddCategoryForm();
      } else if (id == "jobtitle_list") {
        return const AddJobtitleForm();
      } else if (id == "activity_list") {
        return AddActivityForm(type: 'activity');
      } else if (id == "home_activity_list") {
        return AddActivityForm(type: 'home');
      }else if (id == "change_password") {
        return ChangePasswordForm();
      }
      return Container();
    } else if (action == "edit") {
      if (id == "user_list") {
        return ChangePasswordUserForm(user: data);
      } else if (id == "admin_list") {
        return ChangePasswordUserForm(user: data);
      } else if (id == "category_list") {
        return AddCategoryForm(category: data);
      } else if (id == "jobtitle_list") {
        return AddJobtitleForm(jobtitle: data);
      } else if (id == "activity_list") {
        return AddActivityForm(type: 'activity', activity: data,);
      } else if (id == "home_activity_list") {
        return AddActivityForm(type: 'home', activity: data,);
      }
      return Container();
    }
    return Container();
  }
}
