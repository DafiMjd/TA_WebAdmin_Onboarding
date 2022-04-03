import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/menu.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/widgets/drawer_menu.dart';
import 'package:webadmin_onboarding/widgets/drawer_submenu.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataProvider dataProv = context.watch<DataProvider>();
    MenuProvider menuProv = context.watch<MenuProvider>();
    List<Menu> listMenu = menuProv.listMenu;

    void _pressSubMenu(Menu menu) async {
      menuProv.isFetchingData = true;
      List<dynamic> data;
      try {
        data = await dataProv.getDatatable(menu.id);
      }
      catch(e) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("HTTP Error"),
                content: Text("$e"),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: Text("okay"))
                ],
              );
            });
      }
      menuProv.isFetchingData = false;
      List<String> colnames = dataProv.colnames;

      print("dafi data: " + data.toString());
      print("dafi col: " + colnames.toString());

      menuProv.showTable(data, colnames, menu);
    }

    Widget drawSubMenuItem(Menu menu) {
      return DrawerSubmenu(
          title: menu.title,
          icon: menu.icon!,
          press: () {
            _pressSubMenu(menu);
          });
    }

    Widget drawMenuItem(Menu menu) {
      return DrawerMenu(title: menu.title, icon: menu.icon!, press: () {});
    }

    ListView drawSubMenu(List<Menu> listMenu, int index) {
      return ListView(
        shrinkWrap: true,
        children: [
          drawMenuItem(listMenu[index]),
          ListView.builder(
            itemCount: listMenu[index].submenu!.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index2) =>
                drawSubMenuItem(listMenu[index].submenu![index2]),
          )
        ],
      );
    }

    ListView drawMenu(List<Menu> listMenu) {
      return ListView.builder(
          itemCount: listMenu.length,
          physics: ClampingScrollPhysics(),
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
              Text(
                "Onboarding",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                role,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        drawMenu(listMenu),
      ];
    }

    // String role = menuProv.role;
    return Drawer(
      child: ListView(children: drawSideBar(listMenu, "Admin")),
    );
  }
}
