import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/auth_provider.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/views/login_page.dart';

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
      ],
      builder: (context, child) => Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Web Admin Onboarding App",
                theme: ThemeData.light().copyWith(
                  scaffoldBackgroundColor: BG_COLOR,
                  canvasColor: BROWN_GARUDA,
                ),
                home: auth.getIsAuth() ? auth.authenticated() : LoginPage(),
              )),
    );
  }
}
