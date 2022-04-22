// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/role.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_user_form_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
import 'package:webadmin_onboarding/widgets/half_space.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddUserForm extends StatefulWidget {
  const AddUserForm({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  late MenuProvider menuProv;
  late DataProvider dataProv;
  late AddUserFormProvider formProv;

  late String _selectedRoleId;
  late String _selectedRoleTitle;
  late String _selectedJobtitleId;
  late String _selectedJobtitleTitle;
  late List<Role> roles;
  late List<Jobtitle> jobtitles;

  late String _selectedGenderVal;
  List<String> genders = ["Laki-Laki", "Perempuan"];

  late final TextEditingController _emailCtrl;
  late final TextEditingController _pwCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneNumCtrl;

  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddUserFormProvider>(context, listen: false);
    _loadDropDownData();

    if (widget.user == null) {
      // means adding

      _emailCtrl = TextEditingController();
      _pwCtrl = TextEditingController();
      _nameCtrl = TextEditingController();
      _phoneNumCtrl = TextEditingController();

      formProv.isEmailFieldEmpty = _emailCtrl.text.isEmpty;
      formProv.isPwFieldEmpty = _pwCtrl.text.isEmpty;
      formProv.isNameFieldEmpty = _nameCtrl.text.isEmpty;
      formProv.isPhoneNumFieldEmpty = _phoneNumCtrl.text.isEmpty;
      formProv.isGenderFieldEmpty = true;
      formProv.isJobtitleFieldEmpty = true;
      formProv.isRoleFieldEmpty = true;
    } else {
      // means editing
      _emailCtrl = TextEditingController(text: widget.user!.email);
      _pwCtrl = TextEditingController();
      _nameCtrl = TextEditingController(text: widget.user!.name);
      _phoneNumCtrl = TextEditingController(text: widget.user!.phone_number);
      _selectedGenderVal = widget.user!.gender;
      _selectedJobtitleId = widget.user!.jobtitle.id.toString();
      _selectedJobtitleTitle = widget.user!.jobtitle.jobtitle_name;
      _selectedRoleId = widget.user!.role.id.toString();
      _selectedRoleTitle = widget.user!.role.role_name;

      formProv.isEmailFieldEmpty = _emailCtrl.text.isEmpty;
      formProv.isNameFieldEmpty = _nameCtrl.text.isEmpty;
      formProv.isPhoneNumFieldEmpty = _phoneNumCtrl.text.isEmpty;
      formProv.isGenderFieldEmpty = _selectedGenderVal.isEmpty;
      formProv.isJobtitleFieldEmpty = _selectedJobtitleId.isEmpty;
      formProv.isRoleFieldEmpty = _selectedRoleId.isEmpty;
    }
  }

  void _loadDropDownData() async {
    formProv.isFetchingData = true;

    try {
      roles = await dataProv.fetchRolesByPlatform("Mobile");
      jobtitles = await dataProv.fetchJobtitles();
    } catch (onError) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: onError);
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

        menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
            menuProv.menuId, null, null);

        formProv.isSaveButtonDisabled = false;
      } catch (onError) {
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "HTTP Error", error: onError);
            });
      }
      _emailCtrl.text = "";
      _pwCtrl.text = "";
      _nameCtrl.text = "";
      _phoneNumCtrl.text = "";
      _selectedJobtitleId = "";
      _selectedGenderVal = "";
      _selectedRoleId = "";

      formProv.isEmailFieldEmpty = _emailCtrl.text.isEmpty;
      formProv.isPwFieldEmpty = _pwCtrl.text.isEmpty;
      formProv.isNameFieldEmpty = _nameCtrl.text.isEmpty;
      formProv.isPhoneNumFieldEmpty = _phoneNumCtrl.text.isEmpty;
      formProv.isGenderFieldEmpty = _selectedGenderVal.isEmpty;
      formProv.isRoleFieldEmpty = _selectedJobtitleId.isEmpty;

      formProv.isJobtitleFieldEmpty = _selectedRoleId.isEmpty;

      formProv.isSaveButtonDisabled = false;
    }

    void _editUser(String email, String name, String phone, String gender,
        int role_id, int jobtitle_id) async {
      formProv.isSaveButtonDisabled = true;

      try {
        print("dafi1");
        var data = await dataProv.editUser(email, name, phone, gender, role_id,
            jobtitle_id, widget.user!.progress, widget.user!.birtdate);
        print("dafi2");
        List<String> colnames = dataProv.colnames;

        menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
            menuProv.menuId, null, null);

        formProv.isSaveButtonDisabled = false;
      } catch (onError) {
        formProv.isSaveButtonDisabled = false;
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "HTTP Error", error: onError);
            });
      }
      _emailCtrl.text = "";
      // _pwCtrl.text = "";
      _nameCtrl.text = "";
      _phoneNumCtrl.text = "";
      _selectedJobtitleId = "";
      _selectedGenderVal = "";
      _selectedRoleId = "";

      formProv.isEmailFieldEmpty = _emailCtrl.text.isEmpty;
      // formProv.isPwFieldEmpty = _pwCtrl.text.isEmpty;
      formProv.isNameFieldEmpty = _nameCtrl.text.isEmpty;
      formProv.isPhoneNumFieldEmpty = _phoneNumCtrl.text.isEmpty;
      formProv.isGenderFieldEmpty = _selectedGenderVal.isEmpty;
      formProv.isRoleFieldEmpty = _selectedJobtitleId.isEmpty;

      formProv.isJobtitleFieldEmpty = _selectedRoleId.isEmpty;

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
                Visibility(
                    visible: widget.user == null,
                    child: titleField("Password", formProv.isPwFieldEmpty)),
                Visibility(
                    visible: widget.user == null, child: const HalfSpace()),
                Visibility(
                  visible: widget.user == null,
                  child: TextFormField(
                      obscureText: true,
                      onChanged: (value) =>
                          formProv.isPwFieldEmpty = _pwCtrl.text.isEmpty,
                      controller: _pwCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                ),
                Visibility(visible: widget.user == null, child: const Space()),
        
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
        
                genderDropdown(widget.user == null),
        
                const Space(),
                // Role
                titleField("Role", formProv.isRoleFieldEmpty),
                const HalfSpace(),
                (formProv.isFetchingData)
                    ? const CircularProgressIndicator()
                    : roleDropdown(widget.user == null),
        
                const Space(),
                // Jobtitle
                titleField("Jobtitle", formProv.isJobtitleFieldEmpty),
                const HalfSpace(),
                (formProv.isFetchingData)
                    ? const CircularProgressIndicator()
                    : jobtitleDropdown(widget.user == null),
        
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
                            if (widget.user == null) {
                              _addUser(
                                  _emailCtrl.text,
                                  _pwCtrl.text,
                                  _nameCtrl.text,
                                  _phoneNumCtrl.text,
                                  _selectedGenderVal,
                                  int.parse(_selectedRoleId),
                                  int.parse(_selectedJobtitleId));
                            } else {
                              _editUser(
                                  _emailCtrl.text,
                                  _nameCtrl.text,
                                  _phoneNumCtrl.text,
                                  _selectedGenderVal,
                                  int.parse(_selectedRoleId),
                                  int.parse(_selectedJobtitleId));
                            }
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

  Widget genderDropdown(bool bool) {
    if (bool) {
      // adding
      return DropdownButtonFormField(
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
      );
    }
    // editing
    return DropdownButtonFormField(
      value: _selectedGenderVal,
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
    );
  }

  Widget roleDropdown(bool bool) {
    if (bool) {
      return DropdownButtonFormField(
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
            _selectedRoleId = value.toString();
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
    }
    return DropdownButtonFormField(
      // value: _selectedRoleId,
      hint: Text(_selectedRoleTitle),
      dropdownColor: Colors.white,
      // items: null,
      items: roles.map((val) {
        return DropdownMenuItem(
          value: val.id,
          child: Text(
            val.role_name,
          ),
        );
      }).toList(),
      onChanged: (value) {
        print("dafi: $value");
        setState(() {
          formProv.isRoleFieldEmpty = false;
          _selectedRoleId = value.toString();
        });
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget jobtitleDropdown(bool bool) {
    if (bool) {
      return DropdownButtonFormField(
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
            _selectedJobtitleId = value.toString();
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
    }
    return DropdownButtonFormField(
      hint: Text(_selectedJobtitleTitle),
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
          _selectedJobtitleId = value.toString();
        });
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
