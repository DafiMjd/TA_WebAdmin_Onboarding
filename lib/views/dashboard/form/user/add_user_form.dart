import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';

class AddUserForm extends StatelessWidget {
  const AddUserForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MenuProvider menuProv = context.watch<MenuProvider>();

    return Card(
      elevation: 5,
      child: Container(
          padding: EdgeInsets.fromLTRB(DEFAULT_PADDING * 8, DEFAULT_PADDING * 3,
              DEFAULT_PADDING * 8, DEFAULT_PADDING * 3),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              Text(
                "Add User",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              SizedBox(
                height: DEFAULT_PADDING * 2,
              ),
              // email
              titleField("Email"),
              SizedBox(height: DEFAULT_PADDING / 2),
              textField(),
              SizedBox(height: DEFAULT_PADDING),

              // password
              titleField("Password"),
              SizedBox(height: DEFAULT_PADDING / 2),
              textField(),
              SizedBox(height: DEFAULT_PADDING),

              // password check
              titleField("Confirm Password"),
              SizedBox(height: DEFAULT_PADDING / 2),
              textField(),
              SizedBox(height: DEFAULT_PADDING),

              // name
              titleField("Name"),
              SizedBox(height: DEFAULT_PADDING / 2),
              textField(),
              SizedBox(height: DEFAULT_PADDING),

              // phone number
              titleField("Phone Number"),
              SizedBox(height: DEFAULT_PADDING / 2),
              textField(),
              SizedBox(height: DEFAULT_PADDING),

              // Job Title
              titleField("Job Title"),
              SizedBox(height: DEFAULT_PADDING / 2),
              textField(),

              SizedBox(
                height: DEFAULT_PADDING * 2,
              ),

              // save button
              ElevatedButton(
                  onPressed: () {
                    menuProv.closeForm();
                  },
                  child: Text("Save"))
            ],
          )),
    );
  }

  TextFormField textField() {
    return TextFormField(
        decoration: InputDecoration(
      border: OutlineInputBorder(),
    ));
  }

  Container titleField(title) => Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ));
}
