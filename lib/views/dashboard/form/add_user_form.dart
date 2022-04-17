// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/role.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_user_form_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
import 'package:webadmin_onboarding/widgets/half_space.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddUserForm extends StatefulWidget {
  const AddUserForm({Key? key}) : super(key: key);

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  late MenuProvider menuProv;
  late DataProvider dataProv;
  late AddUserFormProvider formProv;

  late String _selectedRoleVal;
  late String _selectedJobtitleVal;
  late List<Role> roles;
  late List<Jobtitle> jobtitles;

  late String _selectedGenderVal;
  List<String> genders = ["Laki-Laki", "Perempuan"];

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneNumCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddUserFormProvider>(context, listen: false);
    _loadDropDownData();
  }

  void _loadDropDownData() async {
    formProv.isFetchingData = true;

    try {
      roles = await dataProv.fetchRolesByPlatform("Mobile");
    jobtitles = await dataProv.fetchJobtitles();

    } catch(onError) {
      return showDialog(
            context: context,
            builder: (context) {
              
              return ErrorAlertDialog(error: onError);
            });

    }

    formProv.isFetchingData = false;

  }

  

  @override
  Widget build(BuildContext context) {
    menuProv = context.watch<MenuProvider>();
    dataProv = context.watch<DataProvider>();
    formProv = context.watch<AddUserFormProvider>();

    void _addUser(String email, String password, String name, String phone,
        String gender, int role_id, int jobtitle_id) async {
      formProv.isSaveButtonDisabled = true;

      try {
        var data = await dataProv.registerUser(
            email, password, name, phone, gender, role_id, jobtitle_id);
        List<String> colnames = dataProv.colnames;

        menuProv.setDashboardContent("table", data, colnames, menuProv.menuName, menuProv.menuId, null, null);

        formProv.isSaveButtonDisabled = true;
      } catch (onError) {
        return showDialog(
            context: context,
            builder: (context) {
              
              return ErrorAlertDialog(error: onError);
            });
      }

      formProv.isSaveButtonDisabled = false;
    }

    return Card(
      elevation: 5,
      child: Container(
          padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING * 8, DEFAULT_PADDING * 3,
              DEFAULT_PADDING * 8, DEFAULT_PADDING * 3),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              const Text(
                "Add User",
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

              // phone number
              titleField("Phone Number", formProv.isPhoneNumFieldEmpty),
              const HalfSpace(),
              TextFormField(
                  onChanged: (value) => formProv.isPhoneNumFieldEmpty =
                      _phoneNumCtrl.text.isEmpty,
                  controller: _phoneNumCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  )),
              const Space(),

              // Gender
              titleField("Gender", formProv.isGenderFieldEmpty),
              const HalfSpace(),

              DropdownButtonFormField(
                dropdownColor: Colors.white,
                items: genders.map((val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    formProv.isGenderFieldEmpty = false;
                    _selectedGenderVal = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

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

              const Space(),
              // Jobtitle
              titleField("Jobtitle", formProv.isJobtitleFieldEmpty),
              const HalfSpace(),
              (formProv.isFetchingData)
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField(
                      dropdownColor: Colors.white,
                      items: jobtitles.map((val) {
                        return DropdownMenuItem(
                          value: val.id,
                          child: Text(
                            val.jobtitle_name,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          formProv.isJobtitleFieldEmpty = false;
                          _selectedJobtitleVal = value.toString();
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
                            _phoneNumCtrl.text.isNotEmpty &&
                            !formProv.isGenderFieldEmpty &&
                            !formProv.isRoleFieldEmpty &&
                            !formProv.isJobtitleFieldEmpty) {
                          _addUser(
                              _emailCtrl.text,
                              _pwCtrl.text,
                              _nameCtrl.text,
                              _phoneNumCtrl.text,
                              _selectedGenderVal,
                              int.parse(_selectedRoleVal),
                              int.parse(_selectedJobtitleVal));
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
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
            )
          : Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ));
}
