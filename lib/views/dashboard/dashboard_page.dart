import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_admin_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_category_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/add_user_form.dart';
import 'package:webadmin_onboarding/views/dashboard/table.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // late List<User> users;
  // late List<Admin> admins;
  // late List<Role> roles;
  // late List<Role> rolesMobile;
  // late List<Role> rolesWebsite;
  // late List<Jobtitle> jobtitles;

  late MenuProvider menuProvInit;
  late DataProvider dataProvInit;

  // void fetchDatas() async {
  //   menuProvInit.isFetchingData = true;
  //   try {
  //     menuProvInit.admins = await dataProvInit.fetchAdmins();
  //     menuProvInit.users = await dataProvInit.fetchUsers();
  //     menuProvInit.roles = await dataProvInit.fetchRoles();
  //     menuProvInit.rolesMobile =
  //         await dataProvInit.fetchRolesByPlatform("Mobile");
  //     menuProvInit.rolesWebsite =
  //         await dataProvInit.fetchRolesByPlatform("Website");
  //     menuProvInit.jobtitles = await dataProvInit.fetchJobtitles();
  //   } catch (e) {
  //     return showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text("HTTP Error"),
  //             content: Text("$e"),
  //             actions: [
  //               TextButton(
  //                   onPressed: () =>
  //                       Navigator.of(context, rootNavigator: true).pop(),
  //                   child: const Text("okay"))
  //             ],
  //           );
  //         });
  //   }
  //   menuProvInit.isFetchingData = false;
  // }

  @override
  void initState() {
    super.initState();
    menuProvInit = Provider.of<MenuProvider>(context, listen: false);
    dataProvInit = Provider.of<DataProvider>(context, listen: false);
    // fetchDatas();
  }

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
              menuProv.showForm();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add New"),
          ),
        ],
      );
    }

    Widget dashboardContent() {
      if (menuProv.isTableShown) {
        if (menuProv.isFetchingData) {
          return const CircularProgressIndicator();
        }
        return MyTable(
            datas: menuProv.data,
            colnames: menuProv.colnames,
            menuId: menuProv.menuId);
      } else if (menuProv.isFormShown) {
        if (menuProv.isFetchingData) {
          return const CircularProgressIndicator();
        }
        return menuProv.getForm(menuProv.menuId, "add", null);
      }
      return Container();
    }

    return SafeArea(
      child: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DEFAULT_PADDING),
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
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(
                              menuProv.menuName,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),

                        const SizedBox(height: DEFAULT_PADDING),
                        (menuProv.isTableShown)
                            ? topActionButton()
                            : Container(),

                        dashboardContent(),

                        const SizedBox(
                          height: DEFAULT_PADDING,
                        ),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: DEFAULT_PADDING),
                        // if (Responsive.isMobile(context)) StarageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(width: DEFAULT_PADDING),
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
