// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/jobtitle.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_jobtitle_form_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
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

  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddJobtitleFormProvider>(context, listen: false);

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
      formProv.isJobtitleDescEmpty = _jobtitleNameCtrl.text.isEmpty;

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

        formProv.isSaveButtonDisabled = true;
      } catch (onError) {
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(error: onError);
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

        formProv.isSaveButtonDisabled = true;
      } catch (onError) {
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(error: onError);
            });
      }
      _jobtitleDescCtrl.text = "";
      _jobtitleNameCtrl.text = "";
      formProv.isJobtitleDescEmpty = _jobtitleNameCtrl.text.isEmpty;
      formProv.isJobtitleDescEmpty = _jobtitleDescCtrl.text.isEmpty;

      formProv.isSaveButtonDisabled = false;
    }

    return Card(
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
              const DoubleSpace(),
              // Jobtitle Name
              titleField("Jobtitle Name", formProv.isJobtitleDescEmpty),
              const DoubleSpace(),
              TextFormField(
                  onChanged: (value) => formProv.isJobtitleDescEmpty =
                      _jobtitleNameCtrl.text.isEmpty,
                  controller: _jobtitleNameCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  )),
              const Space(),

              // Jobtitle Description
              titleField("Jobtitle Description", formProv.isJobtitleDescEmpty),
              const DoubleSpace(),
              TextFormField(
                  onChanged: (value) => formProv.isJobtitleDescEmpty =
                      _jobtitleDescCtrl.text.isEmpty,
                  controller: _jobtitleDescCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  )),
              const Space(),

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
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.red),
            )
          : Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ));
}
