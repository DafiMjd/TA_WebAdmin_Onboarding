import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js.dart';
import 'package:webadmin_onboarding/providers/auth_provider.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_admin_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_category_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_jobtitle_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_user_form_provider.dart';
import 'package:webadmin_onboarding/providers/main_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/activity_preview.dart';
import 'package:webadmin_onboarding/views/login_page.dart';
import 'package:webadmin_onboarding/views/main_page.dart';

void main() {
  runApp(const MyApp());
  // runApp(
  //   ChangeNotifierProvider(
  //       create: ((context) => MainProvider()),
  //       child: Consumer<MainProvider>(builder: (context, mainProv, _) {
  //         return DevicePreview(
  //             enabled: mainProv.isDevicePreview,
  //             tools: [...DevicePreview.defaultTools],
  //             builder: (context) => MyApp());
  //       })),
  // );
}

// child: DevicePreview(
//     enabled: context.read,
//     tools: [...DevicePreview.defaultTools],
//     builder: (context) => MyApp()),

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MenuProvider>(
            create: (context) => MenuProvider(),
            update: (context, authProv, menuProv) {
              if (menuProv != null) {
                return menuProv..receiveJWT(authProv.jwtDecoded);
              }
              return MenuProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, DataProvider>(
            create: (context) => DataProvider(),
            update: (context, authProv, dataProv) {
              if (dataProv != null) {
                return dataProv..receiveJWT(authProv.jwtDecoded);
              }
              return DataProvider();
            }),
        ChangeNotifierProvider(create: (context) => AddUserFormProvider()),
        ChangeNotifierProvider(create: (context) => AddAdminFormProvider()),
        ChangeNotifierProvider(create: (context) => AddCategoryFormProvider()),
        ChangeNotifierProvider(create: (context) => AddJobtitleFormProvider()),
        ChangeNotifierProvider(create: (context) => AddActivityFormProvider()),
      ],
      builder: (context, child) => Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
            routes: {
              '/log':(context) => LoginPage()
            },
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
