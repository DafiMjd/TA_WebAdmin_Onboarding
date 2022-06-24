// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/providers/auth_provider.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/change_password_user_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class ChangePasswordUserForm extends StatefulWidget {
  const ChangePasswordUserForm({Key? key, required this.user}) : super(key: key);

  final dynamic user;

  @override
  State<ChangePasswordUserForm> createState() => _ChangePasswordUserFormState();
}

class _ChangePasswordUserFormState extends State<ChangePasswordUserForm> {
  late DataProvider dataProv;

  ScrollController scrollbarController = ScrollController();

  late final TextEditingController _newPassCtrl;

  late ChangePasswordUserProvider formProv;
  late AuthProvider authProv;
  late MenuProvider menuProv;

  @override
  void initState() {
    super.initState();
    _newPassCtrl = TextEditingController();

    dataProv = Provider.of<DataProvider>(context, listen: false);
    menuProv = Provider.of<MenuProvider>(context, listen: false);
    authProv = Provider.of<AuthProvider>(context, listen: false);
    formProv = Provider.of<ChangePasswordUserProvider>(context, listen: false);

    formProv.isNewPassHidden = true;
    formProv.isNewPassFieldEmpty = true;


  }

  @override
  Widget build(BuildContext context) {
    formProv = context.watch<ChangePasswordUserProvider>();
    authProv = context.watch<AuthProvider>();

    return Scrollbar(
      controller: scrollbarController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollbarController,
        child: Card(
          elevation: 5,
          child: Container(
              padding: const EdgeInsets.fromLTRB(
                  DEFAULT_PADDING * 8,
                  DEFAULT_PADDING * 3,
                  DEFAULT_PADDING * 8,
                  DEFAULT_PADDING * 3),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                  const Text(
                    "Change Password",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Space.doubleSpace(),
                  // Jobtitle Name
                  // Current Password
                  titleField("Email", false),
                  Space.space(),
                  TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(200),
                      ],
                      enabled: false,
                      initialValue: widget.user.email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                  Space.space(),

                  // Password
                  titleField("New Password", formProv.isNewPassFieldEmpty),
                  Space.space(),
                  TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(200),
                      ],
                      onChanged: (value) => formProv.isNewPassFieldEmpty =
                          _newPassCtrl.text.isEmpty,
                      obscureText: formProv.isNewPassHidden,
                      controller: _newPassCtrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffix: InkWell(
                              onTap: () => formProv.changeNewPassHidden(),
                              child: Icon(formProv.isNewPassHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility)))),
                  Space.space(),

                  Space.doubleSpace(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: formProv.isSaveButtonDisabled
                            ? Colors.blue[300]
                            : Colors.blue),
                    onPressed: (formProv.isSaveButtonDisabled)
                        ? () {}
                        : () async {
                            if (_newPassCtrl.text.isNotEmpty) {
                              await _changePasswordUser(widget.user.email, _newPassCtrl.text, widget.user.role.role_platform);
                            }
                          },
                    child: formProv.isSaveButtonDisabled
                        ? Text(
                            "Wait",
                          )
                        : Text(
                            "Save Changes",
                          ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<void> _changePasswordUser(
      String email, String newPass, String platform) async {
    formProv.isSaveButtonDisabled = true;

    try {
      if (platform == 'Mobile') {
        await dataProv.changePasswordUser(email, newPass);
      }else if (platform == 'Website') {
        await dataProv.changePasswordAdmin(email, newPass);
      }
      // Navigator.pop(context);
      formProv.isSaveButtonDisabled = false;
    } catch (e) {
      formProv.isSaveButtonDisabled = false;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("HTTP Error"),
              content: Text("$e"),
              actions: [
                TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: Text("okay"))
              ],
            );
          });
    }
    formProv.isSaveButtonDisabled = false;
  }

  TextFormField textField(controller) {
    return TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ));
  }

  Container titleField(title, isEmpty) => Container(
      alignment: Alignment.centerLeft,
      child: (isEmpty)
          ? Text(
              title + "*",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            )
          : Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ));
}
