import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/responsive.dart';
import 'package:webadmin_onboarding/views/main/component/header.dart';
import 'package:webadmin_onboarding/views/dashboard/dashboard_page.dart';
import 'package:webadmin_onboarding/views/main/component/side_menu.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuProvider>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Column(
                children: [
                  Header(),
                  Expanded(child: DashboardPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
