// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/models/role.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_user_form_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
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

  ScrollController scrollbarController = ScrollController();

  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddUserFormProvider>(context, listen: false);
    _loadDropDownData();

    formProv.isSaveButtonDisabled = false;

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
      formProv.isFetchingData = false;
    } catch (e) {
      formProv.isFetchingData = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
          });
    }
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
      } catch (e) {
        formProv.isSaveButtonDisabled = false;
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
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
        var data = await dataProv.editUser(email, name, phone, gender, role_id,
            jobtitle_id, widget.user!.progress, widget.user!.birtdate);
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
                    "Add User",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Space.doubleSpace(),
                  // email
                  titleField("Email", formProv.isEmailFieldEmpty),
                  Space.halfSpace(),
                  TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(200),
                      ],
                      onChanged: (value) =>
                          formProv.isEmailFieldEmpty = _emailCtrl.text.isEmpty,
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                  Space.space(),

                  // password
                  Visibility(
                      visible: widget.user == null,
                      child: titleField("Password", formProv.isPwFieldEmpty)),
                  Visibility(
                      visible: widget.user == null, child: Space.halfSpace()),
                  Visibility(
                    visible: widget.user == null,
                    child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200),
                        ],
                        obscureText: true,
                        onChanged: (value) {
                          formProv.isPwFieldEmpty = _pwCtrl.text.isEmpty;
                          validatePw(value);
                        },
                        controller: _pwCtrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        )),
                  ),
                  Visibility(
                      visible: widget.user == null, child: Space.space()),
                  Visibility(
                      visible: widget.user == null,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formProv.pwValidation,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[400]),
                        ),
                      )),
                  Visibility(
                      visible: widget.user == null, child: Space.space()),

                  // name
                  titleField("Name", formProv.isNameFieldEmpty),
                  Space.halfSpace(),
                  TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100),
                      ],
                      onChanged: (value) =>
                          formProv.isNameFieldEmpty = _nameCtrl.text.isEmpty,
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                  Space.space(),

                  // phone number
                  titleField("Phone Number", formProv.isPhoneNumFieldEmpty),
                  Space.halfSpace(),
                  TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(15),
                      ],
                      onChanged: (value) => formProv.isPhoneNumFieldEmpty =
                          _phoneNumCtrl.text.isEmpty,
                      controller: _phoneNumCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                  Space.space(),

                  // Gender
                  titleField("Gender", formProv.isGenderFieldEmpty),
                  Space.halfSpace(),

                  _genderDropdown(widget.user == null),

                  Space.space(),
                  // Role
                  titleField("Role", formProv.isRoleFieldEmpty),
                  Space.halfSpace(),
                  (formProv.isFetchingData)
                      ? const CircularProgressIndicator()
                      : _roleDropdown(widget.user == null),

                  Space.space(),
                  // Jobtitle
                  titleField("Jobtitle", formProv.isJobtitleFieldEmpty),
                  Space.halfSpace(),
                  (formProv.isFetchingData)
                      ? const CircularProgressIndicator()
                      : _jobtitleDropdown(widget.user == null),

                  Space.doubleSpace(),

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
                                if (formProv.isPasswordValid &&
                                    _pwCtrl.text.isNotEmpty) {
                                  _addUser(
                                      _emailCtrl.text,
                                      _pwCtrl.text,
                                      _nameCtrl.text,
                                      _phoneNumCtrl.text,
                                      _selectedGenderVal,
                                      int.parse(_selectedRoleId),
                                      int.parse(_selectedJobtitleId));
                                }
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
      ),
    );
  }

  validatePw(String pw) {
    formProv.pwValidation = '';
    StringBuffer pwValidation = new StringBuffer();
    // RegExp regex =
    //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    RegExp regexpCapital = RegExp(r'^(?=.*?[A-Z])');
    RegExp regexpLower = RegExp(r'^(?=.*?[a-z])');
    RegExp regexpNumber = RegExp(r'(?=.*?[0-9])');
    if (pw.length < 8) {
      pwValidation.write('Min 8 chars* | ');
      formProv.pwValidation = pwValidation.toString();
    }
    if (!regexpCapital.hasMatch(pw)) {
      pwValidation.write('Min 1 uppercase char* | ');
      formProv.pwValidation = pwValidation.toString();
    }
    if (!regexpLower.hasMatch(pw)) {
      pwValidation.write('Min 1 lowercase char* | ');
      formProv.pwValidation = pwValidation.toString();
    }
    if (!regexpNumber.hasMatch(pw)) {
      pwValidation.write('Min 1 number* | ');
      formProv.pwValidation = pwValidation.toString();
    }

    if (pwValidation.isEmpty) {
      formProv.isPasswordValid = true;
    } else {
      formProv.isPasswordValid = false;
    }
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

  Widget _genderDropdown(bool bool) {
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

  Widget _roleDropdown(bool bool) {
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

  Widget _jobtitleDropdown(bool bool) {
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
