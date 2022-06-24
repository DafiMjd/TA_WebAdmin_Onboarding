// ignore_for_file: non_constant_identifier_names


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/category.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_category_form_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/space.dart';


class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({Key? key, this.category}) : super(key: key);

  final ActivityCategory? category;

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  late MenuProvider menuProv;
  late DataProvider dataProv;
  late AddCategoryFormProvider formProv;

  late final TextEditingController _catNameCtrl;
  late final TextEditingController _catDescCtrl;

  ScrollController scrollbarController = ScrollController();


  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddCategoryFormProvider>(context, listen: false);

    if (widget.category == null) {
      // means adding
      _catNameCtrl = TextEditingController();
      _catDescCtrl = TextEditingController();


      formProv.isCategoryNameEmpty = _catNameCtrl.text.isEmpty;
      formProv.isCategoryDescEmpty = _catDescCtrl.text.isEmpty;
    } else {
      // means editing
      _catNameCtrl =
          TextEditingController(text: widget.category!.category_name);
      formProv.isCategoryNameEmpty = _catNameCtrl.text.isEmpty;

      _catDescCtrl =
          TextEditingController(text: widget.category!.category_description);
      formProv.isCategoryDescEmpty = _catDescCtrl.text.isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    menuProv = context.watch<MenuProvider>();
    dataProv = context.watch<DataProvider>();
    formProv = context.watch<AddCategoryFormProvider>();

    void _addCategory(
        String category_name, String category_description) async {
      formProv.isSaveButtonDisabled = true;

      try {
        var data = await dataProv.createActivityCategory(
            category_name, category_description);
        List<String> colnames = dataProv.colnames;

        menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
            menuProv.menuId, null, null);

        formProv.isSaveButtonDisabled = true;
      } catch (e) {
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
            });
      }

      _catDescCtrl.text = "";
      _catNameCtrl.text = "";
      formProv.isCategoryNameEmpty = _catNameCtrl.text.isEmpty;
      formProv.isCategoryDescEmpty = _catDescCtrl.text.isEmpty;

      formProv.isSaveButtonDisabled = false;
    }

    void _editCategory(int id, String category_name,
        String category_description) async {
      formProv.isSaveButtonDisabled = true;

      try {
        var data = await dataProv.editActivityCategory(
            id, category_name, category_description);
        List<String> colnames = dataProv.colnames;

        menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
            menuProv.menuId, null, null);

        formProv.isSaveButtonDisabled = true;
      } catch (e) {
        return showDialog(
            context: context,
            builder: (context) {
              
              return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
            });
      }
      _catDescCtrl.text = "";
      _catNameCtrl.text = "";
      formProv.isCategoryNameEmpty = _catNameCtrl.text.isEmpty;
      formProv.isCategoryDescEmpty = _catDescCtrl.text.isEmpty;

      formProv.isSaveButtonDisabled = false;
    }

    return Scrollbar(

      controller: scrollbarController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Card(
          elevation: 5,
          child: Container(
              padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING * 8,
                  DEFAULT_PADDING * 3, DEFAULT_PADDING * 8, DEFAULT_PADDING * 3),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                  const Text(
                    "Add Activity Category",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Space.doubleSpace(),
                  // Category Name
                  titleField("Category Name", formProv.isCategoryNameEmpty),
                  Space.doubleSpace(),
                  TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                      onChanged: (value) =>
                          formProv.isCategoryNameEmpty = _catNameCtrl.text.isEmpty,
                      controller: _catNameCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                   Space.space(),
      
                  // Catgeory Description
                  titleField("Catgeory Description", formProv.isCategoryDescEmpty),
                  Space.doubleSpace(),
                  TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                      onChanged: (value) =>
                          formProv.isCategoryDescEmpty = _catDescCtrl.text.isEmpty,
                      controller: _catDescCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                   Space.space(),
                  // save button
                  ElevatedButton(
                    onPressed: (formProv.isSaveButtonDisabled)
                        ? () {}
                        : () {
                            if (_catNameCtrl.text.isNotEmpty &&
                                _catDescCtrl.text.isNotEmpty &&
                                !formProv.isCategoryNameEmpty &&
                                !formProv.isCategoryDescEmpty) {
                              if (widget.category == null) {
                                // means adding
                                _addCategory(
                                  _catNameCtrl.text,
                                  _catDescCtrl.text,
                                );
                              } else {
                                // means editing
                                _editCategory(
                                    widget.category!.id,
                                  _catNameCtrl.text,
                                  _catDescCtrl.text);
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



