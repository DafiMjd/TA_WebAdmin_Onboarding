// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity.dart';

import 'package:webadmin_onboarding/models/category.dart';

import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';

import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
import 'package:webadmin_onboarding/widgets/half_space.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

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
            return ErrorAlertDialog(error: onError);
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

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width,
                  child: activityForm(context),
                ),
                TextCard(),
                ToDoCard(),
                DoubleSpace(),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: formBuilder(context),
          )
        ],
      ),
    );
  }

  Container formBuilder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            DEFAULT_PADDING,
            DEFAULT_PADDING * 2,
            DEFAULT_PADDING,
            DEFAULT_PADDING * 2,
          ),
          child: Column(children: const [
            Text(
              "Form Builder",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            DoubleSpace(),
            BuilderTile(
              icon: Icons.text_format_sharp,
              title: "Text",
            ),
            HalfSpace(),
            BuilderTile(
              icon: Icons.picture_as_pdf_sharp,
              title: "Document",
            ),
            HalfSpace(),
            BuilderTile(
              icon: Icons.image_sharp,
              title: "Image",
            ),
            HalfSpace(),
            BuilderTile(
              icon: Icons.video_collection_sharp,
              title: "Video",
            ),
            HalfSpace(),
            BuilderTile(
              icon: Icons.list_sharp,
              title: "To Do List",
            ),
            HalfSpace(),
          ]),
        ),
      ),
    );
  }

  Card activityForm(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING, DEFAULT_PADDING * 2,
            DEFAULT_PADDING, DEFAULT_PADDING * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Activity",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const DoubleSpace(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleField("Activity Name", formProv.isActNameEmpty),
                    const HalfSpace(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                          onChanged: (value) => formProv.isActNameEmpty =
                              _actNameCtrl.text.isEmpty,
                          controller: _actNameCtrl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  width: DEFAULT_PADDING,
                ),
                // Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleField("Category", formProv.isCategoryEmpty),
                    const HalfSpace(),
                    (formProv.isFetchingData)
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: DropdownButtonFormField(
                              dropdownColor: Colors.white,
                              items: categories.map((val) {
                                return DropdownMenuItem(
                                  value: val.id,
                                  child: Text(
                                    val.category_name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  formProv.isCategoryEmpty = false;

                                  _selectedCategoryId = value.toString();
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),

            const DoubleSpace(),

            titleField("Activity Description", formProv.isActDescEmpty),
            const HalfSpace(),
            TextFormField(
                maxLines: 2,
                onChanged: (value) =>
                    formProv.isActDescEmpty = _actDescCtrl.text.isEmpty,
                controller: _actDescCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                )),

            const DoubleSpace(),

            // save button
            ElevatedButton(
              onPressed: (formProv.isSaveButtonDisabled)
                  ? () {}
                  : () {
                      // if (_actNameCtrl.text.isNotEmpty &&
                      //     _actDescCtrl.text.isNotEmpty &&
                      //     !formProv.isCategoryEmpty) {
                      //   _addActivity(_actNameCtrl.text, _actDescCtrl.text, int.parse(_selectedCategoryId));
                      // }
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

class ToDoCard extends StatelessWidget {
  const ToDoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, bottom:10),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(DEFAULT_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "To Do",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const DoubleSpace(),
              Row(
                children: [
                  Icon(
                    Icons.check_box_outlined,
                    size: 30,
                  ),
                  const SizedBox(
                    width: DEFAULT_PADDING,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                        decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  const TextCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 10),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(DEFAULT_PADDING),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Text",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const Space(),
            TextFormField(
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                )),
            const Space(),
            Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.black54,
                ))
          ]),
        ),
      ),
    );
  }
}

class BuilderTile extends StatelessWidget {
  const BuilderTile({Key? key, required this.icon, required this.title})
      : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(title),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38, width: 1),
      ),
    );
  }
}
