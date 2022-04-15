import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/auth_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    MenuProvider menuProv = context.watch<MenuProvider>();

    return Container(
      decoration: const BoxDecoration(
          color: BROWN_GARUDA,
          border: Border(left: BorderSide(color: Colors.black12))),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Responsive.isDesktop(context)
          ? InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: BROWN_GARUDA,
                    padding: EdgeInsets.symmetric(
                      horizontal: DEFAULT_PADDING * 1.5,
                      vertical: DEFAULT_PADDING /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    menuProv.init();
                    authProvider.logout();
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: context.read<MenuProvider>().controlMenu,
                ),
                const Text(
                  "Onboarding",
                  style: TextStyle(color: Colors.white),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 15),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: BROWN_GARUDA,
                        padding: EdgeInsets.symmetric(
                          horizontal: DEFAULT_PADDING * 1.5,
                          vertical: DEFAULT_PADDING /
                              (Responsive.isMobile(context) ? 2 : 1),
                        ),
                      ),
                      onPressed: () {
                        authProvider.logout();
                      },
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: DEFAULT_PADDING),
      padding: const EdgeInsets.symmetric(
        horizontal: DEFAULT_PADDING,
        vertical: DEFAULT_PADDING / 2,
      ),
      decoration: BoxDecoration(
        color: BROWN_GARUDA,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 38,
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: DEFAULT_PADDING / 2),
              child: Text("Angelina Jolie"),
            ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: BROWN_GARUDA,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(DEFAULT_PADDING * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING / 2),
            decoration: const BoxDecoration(
              color: ORANGE_GARUDA,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
