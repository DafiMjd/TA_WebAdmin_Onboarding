// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_jobtitle_form_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddJobtitleForm extends StatefulWidget {
  const AddJobtitleForm({Key? key, this.jobtitle}) : super(key: key);

  final Jobtitle? jobtitle;

  @override
  State<AddJobtitleForm> createState() => _AddJobtitleFormState();
}

class _AddJobtitleFormState extends State<AddJobtitleForm> {
  late MenuProvider menuProv;
  late DataProvider dataProv;
  late AddJobtitleFormProvider formProv;

  late final TextEditingController _jobtitleNameCtrl;
  late final TextEditingController _jobtitleDescCtrl;

  ScrollController scrollbarController = ScrollController();


  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddJobtitleFormProvider>(context, listen: false);
    formProv.isSaveButtonDisabled = false;

    if (widget.jobtitle == null) {
      // means adding
      _jobtitleNameCtrl = TextEditingController();
      _jobtitleDescCtrl = TextEditingController();

      formProv.isJobtitleNameEmpty = _jobtitleNameCtrl.text.isEmpty;
      formProv.isJobtitleDescEmpty = _jobtitleDescCtrl.text.isEmpty;
    } else {
      // means editing
      _jobtitleNameCtrl =
          TextEditingController(text: widget.jobtitle!.jobtitle_name);
      formProv.isJobtitleNameEmpty = _jobtitleNameCtrl.text.isEmpty;

      _jobtitleDescCtrl =
          TextEditingController(text: widget.jobtitle!.jobtitle_description);
      formProv.isJobtitleDescEmpty = _jobtitleDescCtrl.text.isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    menuProv = context.watch<MenuProvider>();
    dataProv = context.watch<DataProvider>();
    formProv = context.watch<AddJobtitleFormProvider>();

    void _addJobtitle(String jobtitle_name, String jobtitle_description) async {
      formProv.isSaveButtonDisabled = true;

      try {
        var data =
            await dataProv.createJobtitle(jobtitle_name, jobtitle_description);
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

      _jobtitleDescCtrl.text = "";
      _jobtitleNameCtrl.text = "";
      formProv.isJobtitleDescEmpty = _jobtitleNameCtrl.text.isEmpty;
      formProv.isJobtitleDescEmpty = _jobtitleDescCtrl.text.isEmpty;

      formProv.isSaveButtonDisabled = false;
    }

    void _editJobtitle(
        int id, String jobtitle_name, String jobtitle_description) async {
      formProv.isSaveButtonDisabled = true;

      try {
        var data = await dataProv.editJobtitle(
            id, jobtitle_name, jobtitle_description);
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
      _jobtitleDescCtrl.text = "";
      _jobtitleNameCtrl.text = "";
      formProv.isJobtitleNameEmpty = _jobtitleNameCtrl.text.isEmpty;
      formProv.isJobtitleDescEmpty = _jobtitleDescCtrl.text.isEmpty;

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
              padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING * 8,
                  DEFAULT_PADDING * 3, DEFAULT_PADDING * 8, DEFAULT_PADDING * 3),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                  const Text(
                    "Add Jobtitle",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Space.doubleSpace(),
                  // Jobtitle Name
                  titleField("Jobtitle Name", formProv.isJobtitleNameEmpty),
                  Space.halfSpace(),
                  TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                      onChanged: (value) => formProv.isJobtitleNameEmpty =
                          _jobtitleNameCtrl.text.isEmpty,
                      controller: _jobtitleNameCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                   Space.space(),
      
                  // Jobtitle Description
                  titleField("Jobtitle Description", formProv.isJobtitleDescEmpty),
                  Space.halfSpace(),
                  TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(200),
                  ],
                      onChanged: (value) => formProv.isJobtitleDescEmpty =
                          _jobtitleDescCtrl.text.isEmpty,
                      controller: _jobtitleDescCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                   Space.space(),
      
                  // save button
                  ElevatedButton(
                    onPressed: (formProv.isSaveButtonDisabled)
                        ? () {}
                        : () {
                            if (_jobtitleNameCtrl.text.isNotEmpty &&
                                _jobtitleDescCtrl.text.isNotEmpty &&
                                !formProv.isJobtitleDescEmpty &&
                                !formProv.isJobtitleDescEmpty) {
                              if (widget.jobtitle == null) {
                                // means adding
                                _addJobtitle(
                                  _jobtitleNameCtrl.text,
                                  _jobtitleDescCtrl.text,
                                );
                              } else {
                                // means editing
                                _editJobtitle(
                                  widget.jobtitle!.id,
                                  _jobtitleNameCtrl.text,
                                  _jobtitleDescCtrl.text,
                                );
                              }
                            }
                          },
                    child: (formProv.isSaveButtonDisabled)
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
