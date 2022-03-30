import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/views/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Web Admin Onboarding App",
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: BG_COLOR,
        canvasColor: BROWN_GARUDA,
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => MenuProvider())
      ], child: MainPage(),),
    );
  }
}
