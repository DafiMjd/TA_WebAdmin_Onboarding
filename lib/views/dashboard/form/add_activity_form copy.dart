// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity.dart';

import 'package:webadmin_onboarding/models/category.dart';

import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';

import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';

class AddActivityForm extends StatefulWidget {
  const AddActivityForm({Key? key, this.activity}) : super(key: key);

  final Activity? activity;

  @override
  State<AddActivityForm> createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  late MenuProvider menuProv;
  late DataProvider dataProv;
  late AddActivityFormProvider formProv;

  late String _selectedCategoryId;
  late List<ActivityCategory> categories;

  late final TextEditingController _actNameCtrl;
  late final TextEditingController _actDescCtrl;

  late bool isEditing;

  List<Widget> containers = [
    Center(
      child: Container(
        child: const Text("1"),
        color: Colors.red,
        height: 100,
        width: 100,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    dataProv = Provider.of<DataProvider>(context, listen: false);
    formProv = Provider.of<AddActivityFormProvider>(context, listen: false);

    if (widget.activity == null) {
      // means adding
      _actNameCtrl = TextEditingController();
      _actDescCtrl = TextEditingController();

      formProv.isActNameEmpty = _actNameCtrl.text.isEmpty;
      formProv.isActDescEmpty = _actDescCtrl.text.isEmpty;

      isEditing = false;
    } else {
      // means editing
      _actNameCtrl =
          TextEditingController(text: widget.activity!.activity_name);
      _actDescCtrl =
          TextEditingController(text: widget.activity!.activity_description);

      isEditing = true;
    }

    _loadDropDownData();
  }

  void _loadDropDownData() async {
    formProv.isFetchingData = true;
    try {
      categories = await dataProv.fetchActivityCategories();
    } catch (onError) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: onError.toString());
          });
    }

    formProv.isFetchingData = false;
  }

  @override
  Widget build(BuildContext context) {
    menuProv = context.watch<MenuProvider>();
    dataProv = context.watch<DataProvider>();
    formProv = context.watch<AddActivityFormProvider>();

    // void _addActivity(
    //     String title, String desc, int category_id) async {
    //   formProv.isSaveButtonDisabled = true;
    //   try {
    //     var data = await dataProv.registerAdmin(title, desc, category_id);
    //     List<String> colnames = dataProv.colnames;
    //     menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
    //         menuProv.menuId, null, null);
    //     formProv.isSaveButtonDisabled = false;
    //   } catch (onError) {
    //     formProv.isSaveButtonDisabled = false;
    //     return showDialog(
    //         context: context,
    //         builder: (context) {
    //           return ErrorAlertDialog(error: onError);
    //         });
    //   }
    //   formProv.isSaveButtonDisabled = false;
    // }

    Row topActionButton() {
      return Row(
        children: [
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: DEFAULT_PADDING * 1.5,
                vertical:
                    DEFAULT_PADDING / (Responsive.isMobile(context) ? 2 : 1),
              ),
            ),
            onPressed: () {
              containers.add(
                Container(
                  margin: const EdgeInsets.only(top: DEFAULT_PADDING, bottom: DEFAULT_PADDING),
                  child: const Text("1"),
                  color: Colors.red,
                  height: 100,
                  width: 100,
                ),
                
              );
              // containers.add(SizedBox(height: DEFAULT_PADDING,));
              setState(() {
                
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("1"),
          ),
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: DEFAULT_PADDING * 1.5,
                vertical:
                    DEFAULT_PADDING / (Responsive.isMobile(context) ? 2 : 1),
              ),
            ),
            onPressed: () {
              containers.add(
                Container(
                  margin: const EdgeInsets.only(top: DEFAULT_PADDING, bottom: DEFAULT_PADDING),
                  child: const Text("2"),
                  color: Colors.red,
                  height: 100,
                  width: 100,
                ),
              );
              setState(() {
                
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("2"),
          ),
        ],
      );
    }

    return Column(
      children: [
        topActionButton(),
        // Card(
        //   elevation: 5,
        //   child: Container(
        //       padding: const EdgeInsets.fromLTRB(
        //           DEFAULT_PADDING * 8,
        //           DEFAULT_PADDING * 3,
        //           DEFAULT_PADDING * 8,
        //           DEFAULT_PADDING * 3),
        //       width: MediaQuery.of(context).size.width * 0.6,
        //       child: Column(
        //         children: [
        //           const Text(
        //             "Add Activity",
        //             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        //           ),
        //           const SizedBox(
        //             height: DEFAULT_PADDING * 2,
        //           ),
        //           // Activity
        //           titleField("Activity Name", formProv.isActNameEmpty),
        //           const SizedBox(height: DEFAULT_PADDING / 2),
        //           TextFormField(
        //               onChanged: (value) =>
        //                   formProv.isActNameEmpty = _actNameCtrl.text.isEmpty,
        //               controller: _actNameCtrl,
        //               decoration: const InputDecoration(
        //                 border: OutlineInputBorder(),
        //               )),
        //           const SizedBox(height: DEFAULT_PADDING),

        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               SizedBox(
        //                 width: MediaQuery.of(context).size.width * 0.1,
        //                 child: Column(
        //                   children: [
        //                     titleField("Category", formProv.isCategoryEmpty),
        //                     const SizedBox(height: DEFAULT_PADDING / 2),
        //                     (formProv.isFetchingData)
        //                         ? const CircularProgressIndicator()
        //                         : DropdownButtonFormField(
        //                             dropdownColor: Colors.white,
        //                             items: categories.map((val) {
        //                               return DropdownMenuItem(
        //                                 value: val.id,
        //                                 child: Text(
        //                                   val.category_name,
        //                                 ),
        //                               );
        //                             }).toList(),
        //                             onChanged: (value) {
        //                               setState(() {
        //                                 formProv.isCategoryEmpty = false;

        //                                 _selectedCategoryId = value.toString();
        //                               });
        //                             },
        //                             decoration: const InputDecoration(
        //                               border: OutlineInputBorder(),
        //                             ),
        //                           ),
        //                   ],
        //                 ),
        //               ),
        //               Container(
        //                 width: MediaQuery.of(context).size.width * 0.3,
        //                 child: Column(
        //                   children: [
        //                     titleField("Activity Description",
        //                         formProv.isActDescEmpty),
        //                     const SizedBox(height: DEFAULT_PADDING / 2),
        //                     TextFormField(
        //                         maxLines: 2,
        //                         onChanged: (value) => formProv.isActDescEmpty =
        //                             _actDescCtrl.text.isEmpty,
        //                         controller: _actDescCtrl,
        //                         decoration: const InputDecoration(
        //                           border: OutlineInputBorder(),
        //                         )),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //           const SizedBox(height: DEFAULT_PADDING),

        //           // // Activity Description
        //           // titleField("Activity Description", formProv.isActDescEmpty),
        //           // const SizedBox(height: DEFAULT_PADDING / 2),
        //           // TextFormField(
        //           //   readOnly: isEditing,
        //           //     onChanged: (value) =>
        //           //         formProv.isActDescEmpty = _actDescCtrl.text.isEmpty,
        //           //     controller: _actDescCtrl,
        //           //     decoration: const InputDecoration(
        //           //       border: OutlineInputBorder(),
        //           //     )),
        //           // const SizedBox(height: DEFAULT_PADDING),

        //           // // Category
        //           // titleField("Category", formProv.isCategoryEmpty),
        //           // const SizedBox(height: DEFAULT_PADDING / 2),
        //           // (formProv.isFetchingData)
        //           //     ? const CircularProgressIndicator()
        //           //     : DropdownButtonFormField(
        //           //         dropdownColor: Colors.white,
        //           //         items: categories.map((val) {
        //           //           return DropdownMenuItem(
        //           //             value: val.id,
        //           //             child: Text(
        //           //               val.category_name,
        //           //             ),
        //           //           );
        //           //         }).toList(),
        //           //         onChanged: (value) {
        //           //           setState(() {
        //           //             formProv.isCategoryEmpty = false;

        //           //             _selectedCategoryId = value.toString();
        //           //           });
        //           //         },
        //           //         decoration: const InputDecoration(
        //           //           border: OutlineInputBorder(),
        //           //         ),
        //           //       ),

        //           const SizedBox(
        //             height: DEFAULT_PADDING * 2,
        //           ),

        //           // save button
        //           ElevatedButton(
        //             onPressed: (formProv.isSaveButtonDisabled)
        //                 ? () {}
        //                 : () {
        //                     // if (_actNameCtrl.text.isNotEmpty &&
        //                     //     _actDescCtrl.text.isNotEmpty &&
        //                     //     !formProv.isCategoryEmpty) {
        //                     //   _addActivity(_actNameCtrl.text, _actDescCtrl.text, int.parse(_selectedCategoryId));
        //                     // }
        //                   },
        //             child: formProv.isSaveButtonDisabled
        //                 ? const Text(
        //                     "Wait",
        //                   )
        //                 : const Text(
        //                     "Save",
        //                   ),
        //           )
        //         ],
        //       )),
        // ),
        const SizedBox(
          height: DEFAULT_PADDING,
        ),
        for (int i = 0; i < containers.length; i++) containers[i],
      ],
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
