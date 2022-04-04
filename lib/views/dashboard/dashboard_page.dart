import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_admin_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_user_form.dart';
import 'package:webadmin_onboarding/views/dashboard/table.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MenuProvider menuProv = context.watch<MenuProvider>();

    Row topActionButton() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: DEFAULT_PADDING * 1.5,
                vertical:
                    DEFAULT_PADDING / (Responsive.isMobile(context) ? 2 : 1),
              ),
            ),
            onPressed: () {
              menuProv.getAction("add");
            },
            icon: Icon(Icons.add),
            label: Text("Add New"),
          ),
        ],
      );
    }

    Widget _getForm(id) {
      if (id == "user_list") {
        return AddUserForm();
      } else if (id == "admin_list") {
        return AddAdminForm();
      }
      return Container();
    }

    Widget dashboardContent() {
      if (menuProv.isTableShown) {
        if (menuProv.isFetchingData) {
          return CircularProgressIndicator();
        }
        return MyTable(datas: menuProv.data, colnames: menuProv.colnames, menuId: menuProv.menuId);
      } else if (menuProv.isFormShown) {
        if (menuProv.isFetchingData) {
          return CircularProgressIndicator();
        }
        return _getForm(menuProv.menuId);
      }
      return Container();
    }

    return SafeArea(
      child: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(DEFAULT_PADDING),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              menuProv.menuName,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),

                        SizedBox(height: DEFAULT_PADDING),
                        (menuProv.isTableShown)
                            ? topActionButton()
                            : Container(),

                        dashboardContent(),

                        SizedBox(
                          height: DEFAULT_PADDING,
                        ),
                        if (Responsive.isMobile(context))
                          SizedBox(height: DEFAULT_PADDING),
                        // if (Responsive.isMobile(context)) StarageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: DEFAULT_PADDING),
                  // On Mobile means if the screen is less than 850 we dont want to show it
                  // if (!Responsive.isMobile(context))
                  //   Expanded(
                  //     flex: 2,
                  //     child: StarageDetails(),
                  //   ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
