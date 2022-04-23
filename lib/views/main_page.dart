import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/add_activity_form.dart';
import 'package:webadmin_onboarding/views/main/header.dart';
import 'package:webadmin_onboarding/views/dashboard/dashboard_page.dart';
import 'package:webadmin_onboarding/views/main/side_menu.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuProvider>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Expanded(
                  // It takes 5/6 part of the screen
                  flex: 5,
                  child: Column(
                    children: [
                      Header(),
                      Expanded(child: DashboardPage()),
                      // Expanded(child: AddActivityForm(),)
                    ],
                  ),
                ),
              ),
              if (Responsive.isDesktop(context))
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: const Expanded(
                    // default flex = 1
                    // and it takes 1/6 part of the screen
                    child: SideMenu(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
