import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/views/main/widgets/drawer_list_tile.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Onboarding", style: TextStyle(color: Colors.white, fontSize: 20),),
            Text("Admin",  style: TextStyle(color: Colors.white),),
          ],
        ),),
        DrawerListTile(title: "Manage User", icon: Icons.account_circle, press: (){})
        
      ]),
      
    );
  }
}