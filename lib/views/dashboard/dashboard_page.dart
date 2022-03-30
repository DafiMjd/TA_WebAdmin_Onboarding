import 'package:webadmin_onboarding/responsive.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/dashboard/components/table.dart';
import 'package:webadmin_onboarding/views/table/component/table2.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                              "Selamat Datang",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                        SizedBox(height: DEFAULT_PADDING),
                        MyTable(),
                        SizedBox(height: DEFAULT_PADDING,),
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
