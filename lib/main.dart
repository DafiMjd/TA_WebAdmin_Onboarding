import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/auth_provider.dart';
import 'package:webadmin_onboarding/providers/base_provider.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_admin_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_category_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_jobtitle_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_user_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/assign_activity_provider.dart';
import 'package:webadmin_onboarding/providers/form/change_password_provider.dart';
import 'package:webadmin_onboarding/providers/form/change_password_user_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/views/main/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DataProvider>(
            create: (context) => DataProvider(),
            update: (context, authProv, dataProv) {
              if (dataProv != null) {
                return dataProv..receiveJWT(authProv.jwtDecoded);
              }
              return DataProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, BaseProvider>(
            create: (context) => BaseProvider(),
            update: (context, authProv, baseProv) {
              if (baseProv != null) {
                return baseProv..receiveJWT(authProv.jwtDecoded);
              }
              return BaseProvider();
            }),
        ChangeNotifierProvider(create: (context) => AddUserFormProvider()),
        ChangeNotifierProvider(create: (context) => AddAdminFormProvider()),
        ChangeNotifierProvider(create: (context) => AddCategoryFormProvider()),
        ChangeNotifierProvider(create: (context) => AddJobtitleFormProvider()),
        ChangeNotifierProvider(create: (context) => AddActivityFormProvider()),
        ChangeNotifierProvider(create: (context) => AssignActivityProvider()),
        ChangeNotifierProvider(create: (context) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (context) => ChangePasswordUserProvider()),
      ],
      builder: (context, child) => Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Web Admin Onboarding App",
                theme: ThemeData.light().copyWith(
                  scaffoldBackgroundColor: BG_COLOR,
                  canvasColor: BROWN_GARUDA,
                ),
                home:
                    auth.getIsAuth() ? auth.authenticated() : const LoginPage(),
                    // MainPage(),
              )),
    );
  }
}
