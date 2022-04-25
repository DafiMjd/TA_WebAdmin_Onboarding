// ignore_for_file: non_constant_identifier_names


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/admin.dart';
import 'package:webadmin_onboarding/models/role.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_admin_form_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
import 'package:webadmin_onboarding/widgets/half_space.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddAdminForm extends StatefulWidget {
  const AddAdminForm({Key? key, this.admin}) : super(key: key);

  final Admin? admin;

  @override
  State<AddAdminForm> createState() => _AddAdminFormState();
}

class _AddAdminFormState extends State<AddAdminForm> {
  late MenuProvider menuProv;
  late DataProvider dataProv;
  late AddAdminFormProvider formProv;

  late String _selectedRoleVal;
  late List<Role> roles;

  late final TextEditingController _emailCtrl;
  late final TextEditingController _pwCtrl;
  late final TextEditingController _nameCtrl;

  late bool isEditing;

  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddAdminFormProvider>(context, listen: false);

    if (widget.admin == null) {
      // means adding
      _emailCtrl = TextEditingController();
      _pwCtrl = TextEditingController();
      _nameCtrl = TextEditingController();

      formProv.isEmailFieldEmpty = _emailCtrl.text.isEmpty;
      formProv.isPwFieldEmpty = _pwCtrl.text.isEmpty;
      formProv.isNameFieldEmpty = _nameCtrl.text.isEmpty;

      isEditing = false;
    } else {
      // means editing
      _emailCtrl = TextEditingController(text: widget.admin!.email);
      _pwCtrl = TextEditingController();
      _nameCtrl = TextEditingController(text: widget.admin!.admin_name);
      _selectedRoleVal = widget.admin!.role.role_name;

      isEditing = true;
    }

    _loadDropDownData();
  }

  void _loadDropDownData() async {
    formProv.isFetchingData = true;
    try {
      roles = await dataProv.fetchRolesByPlatform("Website");
    } catch (e) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
          });
    }

    formProv.isFetchingData = false;
  }

  @override
  Widget build(BuildContext context) {
    menuProv = context.watch<MenuProvider>();
    dataProv = context.watch<DataProvider>();
    formProv = context.watch<AddAdminFormProvider>();

    void _addUser(
        String email, String password, String name, int role_id) async {
      formProv.isSaveButtonDisabled = true;

      try {
        var data = await dataProv.registerAdmin(email, password, name, role_id);
        List<String> colnames = dataProv.colnames;

        menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
            menuProv.menuId, null, null);

        formProv.isSaveButtonDisabled = false;
      } catch (e) {
        formProv.isSaveButtonDisabled = false;
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
            });
      }

      formProv.isSaveButtonDisabled = false;
    }

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
            padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING * 8,
                DEFAULT_PADDING * 3, DEFAULT_PADDING * 8, DEFAULT_PADDING * 3),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                const Text(
                  "Add Admin",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const DoubleSpace(),
                // email
                titleField("Email", formProv.isEmailFieldEmpty),
                const HalfSpace(),
                TextFormField(
                    onChanged: (value) =>
                        formProv.isEmailFieldEmpty = _emailCtrl.text.isEmpty,
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    )),
                const Space(),
    
                // password
                titleField("Password", formProv.isPwFieldEmpty),
                const HalfSpace(),
                TextFormField(
                  obscureText: true,
                    readOnly: isEditing,
                    onChanged: (value) =>
                        formProv.isPwFieldEmpty = _pwCtrl.text.isEmpty,
                    controller: _pwCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    )),
                const Space(),
    
                // name
                titleField("Name", formProv.isNameFieldEmpty),
                const HalfSpace(),
                TextFormField(
                    onChanged: (value) =>
                        formProv.isNameFieldEmpty = _nameCtrl.text.isEmpty,
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    )),
    
                const Space(),
                // Role
                titleField("Role", formProv.isRoleFieldEmpty),
                const HalfSpace(),
                (formProv.isFetchingData)
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField(
                        dropdownColor: Colors.white,
                        items: roles.map((val) {
                          return DropdownMenuItem(
                            value: val.id,
                            child: Text(
                              val.role_name,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            formProv.isRoleFieldEmpty = false;
    
                            _selectedRoleVal = value.toString();
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
    
                const DoubleSpace(),
    
                // save button
                ElevatedButton(
                  onPressed: (formProv.isSaveButtonDisabled)
                      ? () {}
                      : () {
                          if (_emailCtrl.text.isNotEmpty &&
                              _nameCtrl.text.isNotEmpty &&
                              _pwCtrl.text.isNotEmpty &&
                              !formProv.isRoleFieldEmpty) {
                            _addUser(_emailCtrl.text, _pwCtrl.text,
                                _nameCtrl.text, int.parse(_selectedRoleVal));
                          }
                        },
                  child: formProv.isSaveButtonDisabled
                      ? const Text(
                          "Wait",
                        )
                      : const Text(
                          "Save",
                        ),
                )
              ],
            )),
      ),
    );
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
