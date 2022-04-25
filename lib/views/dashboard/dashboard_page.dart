import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late MenuProvider menuProvInit;
  late DataProvider dataProvInit;

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
              menuProv.setDashboardContent(
                  "form", null, null, null, menuProv.menuId, "add", null);
            },
            icon: const Icon(Icons.add),
            label: const Text("Add New"),
          ),
        ],
      );
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
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

            const Space(),
            (menuProv.isTableShown) ? topActionButton() : Container(),

            menuProv.isFetchingData ? const SizedBox(width: 100, height: 100, child: CircularProgressIndicator()) :
            Expanded(
              child: menuProv.dashboardContent,
            ),

            const Space(),
            if (Responsive.isMobile(context)) const Space(),
            // if (Responsive.isMobile(context)) StarageDetails(),
          ],
        ),
      ),
    );
  }
}
