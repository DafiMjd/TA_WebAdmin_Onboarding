// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/providers/auth_provider.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_jobtitle_form_provider.dart';
import 'package:webadmin_onboarding/providers/form/change_password_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  late DataProvider dataProv;

  ScrollController scrollbarController = ScrollController();

  late final TextEditingController _curPassCtrl;
  late final TextEditingController _newPassCtrl;
  late final TextEditingController _confirmPassCtrl;

  late ChangePasswordProvider formProv;
  late AuthProvider authProv;
  late MenuProvider menuProv;


  @override
  void initState() {
    super.initState();
    _curPassCtrl = TextEditingController();
    _newPassCtrl = TextEditingController();
    _confirmPassCtrl = TextEditingController();

    dataProv = Provider.of<DataProvider>(context, listen: false);
    menuProv = Provider.of<MenuProvider>(context, listen: false);
    authProv = Provider.of<AuthProvider>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    formProv = context.watch<ChangePasswordProvider>();
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
                    "Add Jobtitle",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Space.doubleSpace(),
                  // Jobtitle Name
                  // Current Password
                  titleField("Current Password", formProv.isCurPassFieldEmpty),
                  Space.space(),
                  TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(200),
                      ],
                      onChanged: (value) => formProv.isCurPassFieldEmpty =
                          _curPassCtrl.text.isEmpty,
                      obscureText: formProv.isCurPassHidden,
                      controller: _curPassCtrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffix: InkWell(
                              onTap: () => formProv.changeCurPassHidden(),
                              child: Icon(formProv.isCurPassHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility)))),
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

                  // Confirm Password
                  titleField("Confirm Password", formProv.isConfPassFieldEmpty),
                  Space.space(),
                  TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(200),
                      ],
                      onChanged: (value) => formProv.isConfPassFieldEmpty =
                          _confirmPassCtrl.text.isEmpty,
                      obscureText: formProv.isConfPassHidden,
                      controller: _confirmPassCtrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffix: InkWell(
                              onTap: () => formProv.changeConfPassHidden(),
                              child: Icon(formProv.isConfPassHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility)))),
                  Space.space(),
                  Visibility(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "* New passwords don't match",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    visible: formProv.isPassDifferent,
                  ),

                  Space.doubleSpace(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: formProv.isSaveButtonDisabled
                            ? Colors.blue[300]
                            : Colors.blue),
                    onPressed: (formProv.isSaveButtonDisabled)
                        ? () {}
                        : () async {
                            if (_curPassCtrl.text.isNotEmpty &&
                                _newPassCtrl.text.isNotEmpty &&
                                _confirmPassCtrl.text.isNotEmpty) {
                              // validate wheter new pass and conf pass same
                              formProv.isPassDifferent =
                                  _newPassCtrl.text != _confirmPassCtrl.text;
                              if (!formProv.isPassDifferent) {
                                await _changePassword(
                                    _curPassCtrl.text, _newPassCtrl.text);
                              }
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

  Future<void> _changePassword(String curPass, String newPass) async {
    formProv.isSaveButtonDisabled = true;

    try {
      await dataProv.changePassword(curPass, newPass);
      // Navigator.pop(context);
      formProv.isSaveButtonDisabled = false;

      menuProv.init();
      authProv.logout();

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
