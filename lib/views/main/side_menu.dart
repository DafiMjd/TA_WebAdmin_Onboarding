// ignore_for_file: prefer_const_constructors

import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity_owned_by_user.dart';
import 'package:webadmin_onboarding/models/menu.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/drawer_menu.dart';
import 'package:webadmin_onboarding/widgets/drawer_submenu.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key, required this.listMenu}) : super(key: key);

  final List<Menu> listMenu;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    DataProvider dataProv = context.watch<DataProvider>();
    MenuProvider menuProv = context.watch<MenuProvider>();

    Future<ActivityOwnedByUser> _getActivityOwnedData(User user) async {
      try {
        var data = await dataProv.fetchActivityOwnedByEmail(user.email);

        var newData = ActivityOwnedByUser(user: user, activities_owned: data);
        return newData;
      } catch (e) {
        rethrow;
      }
    }

    Future<List<ActivityOwnedByUser>> _getActivityOwnedByUserData(
        List<User> users) async {
      List<ActivityOwnedByUser> datas = [];

      menuProv.isFetchingData = true;

      for (final element in users) {
        try {
          ActivityOwnedByUser newData = await _getActivityOwnedData(element);
          datas.add(newData);
          // datas.forEach((element) {print(element.activities[0].activity_name);});
        } catch (e) {
          rethrow;
        }
      }

      return datas;
    }

    void _pressActivityOwnedMenu(Menu menu) async {
      List<ActivityOwnedByUser> datas = [];


      menuProv.isFetchingData = true;
      try {
        List<User> users = await dataProv.fetchUsersByRole(4); // 4 = id for role peserta_onboarding

        datas = await _getActivityOwnedByUserData(users);
        
        List<String> colnames = ['Email', 'Name', 'Activities Owned'];
        menuProv.isFetchingData = false;

        menuProv.setDashboardContent(
            "table", datas, colnames, menu.title, menu.id, null, null);
      } catch (e) {
        menuProv.isFetchingData = false;
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
            });
      }
    }

    void _pressSubMenu(Menu menu) async {
      if (menu.id == 'activity_owned_list') {
        _pressActivityOwnedMenu(menu);
        return;
      }
      menuProv.isFetchingData = true;
      List<dynamic> data;
      try {
        data = await dataProv.getDatatable(menu.id);
        // if (data.isEmpty) {
        //   menuProv.dashboardContent = Text('No Data');
        //   return;
        // }
        menuProv.isFetchingData = false;
        List<String> colnames = dataProv.colnames;

        menuProv.setDashboardContent(
            "table", data, colnames, menu.title, menu.id, null, null);
      } catch (e) {
        menuProv.isFetchingData = false;
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
            });
      }
    }

    Widget drawSubMenuItem(Menu menu, Menu submenu) {
      return Visibility(
        visible: menu.selected,
        child: DrawerSubmenu(
            title: submenu.title,
            icon: submenu.icon!,
            press: () {
              _pressSubMenu(submenu);
            }),
      );
    }

    Widget drawMenuItem(Menu menu) {
      return DrawerMenu(
          menu: menu,
          press: () {
            setState(() {
              menu.selected = !menu.selected;
            });
          });
    }

    ListView drawSubMenu(List<Menu> listMenu, int index) {
      return ListView(
        shrinkWrap: true,
        children: [
          drawMenuItem(listMenu[index]),
          ListView.builder(
            itemCount: listMenu[index].submenu!.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index2) => drawSubMenuItem(
                listMenu[index], listMenu[index].submenu![index2]),
          )
        ],
      );
    }

    ListView drawMenu(List<Menu> listMenu) {
      return ListView.builder(
          itemCount: listMenu.length,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return (!listMenu[index].hasSubMenu())
                ? drawMenuItem(listMenu[index])
                : drawSubMenu(listMenu, index);
          }));
    }

    List<Widget> drawSideBar(List<Menu> listMenu, String role) {
      return [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => menuProv.init(),
                child: Text(
                  "Onboarding",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Text(
                role,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        drawMenu(listMenu),
      ];
    }

    // String role = menuProv.role;
    return Drawer(
      child: ListView(children: drawSideBar(widget.listMenu, "Admin")),
    );
  }
}
