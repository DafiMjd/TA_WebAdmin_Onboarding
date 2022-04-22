// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';

import 'package:webadmin_onboarding/models/category.dart';
import 'package:webadmin_onboarding/models/file_data_model.dart';

import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';

import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/builder_tile.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/text_card.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/todo_card.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropped_file_widget.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropzone_widget.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
import 'package:webadmin_onboarding/widgets/half_space.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddActivityForm extends StatefulWidget {
  AddActivityForm({Key? key, this.activity, this.activity_details})
      : super(key: key);

  Activity? activity;
  List<ActivityDetail>? activity_details;

  @override
  State<AddActivityForm> createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  final List<int> _items = List<int>.generate(5, (int index) => index);
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
      widget.activity = Activity();
      widget.activity_details = [];
    } else {
      // means editing
      _actNameCtrl =
          TextEditingController(text: widget.activity!.activity_name);
      _actDescCtrl =
          TextEditingController(text: widget.activity!.activity_description);

      isEditing = true;
    }

    // Activity act = Activity(
    //     id: 1,
    //     activity_name: "Belajar Flutter",
    //     activity_description: "Belajar Flutter",
    //     category: ActivityCategory(
    //         category_description: "ddd",
    //         category_name: "nn",
    //         duration: 1,
    //         id: 1));

    // ignore: prefer_conditional_assignment

    // if (widget.activity_details == null) {
    //   widget.activity_details = [
    //     ActivityDetail(
    //         id: 1,
    //         detail_urutan: 0,
    //         detail_name: "Text1",
    //         detail_desc: "Belajar Dart",
    //         detail_link: "detail_link",
    //         detail_type: "text",
    //         activity: act),
    //     ActivityDetail(
    //         id: 2,
    //         detail_urutan: 1,
    //         detail_name: "ToDo1",
    //         detail_desc: "Belajar MVVM",
    //         detail_link: "detail_link",
    //         detail_type: "to_do",
    //         activity: act),
    //     ActivityDetail(
    //         id: 3,
    //         detail_urutan: 2,
    //         detail_name: "Text2",
    //         detail_desc: "Belajar Provider",
    //         detail_link: "detail_link",
    //         detail_type: "text",
    //         activity: act),
    //   ];
    //   // widget.activity_details = [];
    // }

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
            return ErrorAlertDialog(title: "HTTP Error", error: onError);
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width,
                  child: activityForm(context),
                ),
                if (widget.activity_details != null)
                  Theme(
                    data: ThemeData(canvasColor: Colors.transparent),
                    child: ReorderableListView.builder(
                      itemCount: widget.activity_details!.length,
                      itemBuilder: (context, index) {
                        return getActivityDetailWidget(index);
                      },
                      shrinkWrap: true,
                      scrollController: ScrollController(),
                      header: ElevatedButton(
                        child: Text("cek"),
                        onPressed: () {
                          for (int i = 0;
                              i < widget.activity_details!.length;
                              i++) {
                            widget.activity_details![i].detail_urutan = i;
                            print(widget.activity_details![i].detail_name! +
                                " " +
                                widget.activity_details![i].detail_urutan!
                                    .toString());
                          }
                        },
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item =
                              widget.activity_details!.removeAt(oldIndex);
                          widget.activity_details!.insert(newIndex, item);
                        });
                      },
                    ),
                  ),
                const DoubleSpace(),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: formBuilder(context),
        )
      ],
    );
  }

  void reorderActivityDetails() {
    for (int i = 0; i < widget.activity_details!.length; i++) {
      widget.activity_details![i].detail_urutan = i;
    }
  }

  Widget getActivityDetailWidget(int index) {
    ActivityDetail actDetail = widget.activity_details![index];
    if (actDetail.detail_type == 'text') {
      return TextCard(
        actDetail: actDetail,
        key: Key('$index'),
        delete: IconButton(
            onPressed: (() {
              remove(index);
            }),
            icon: const Icon(
              Icons.delete,
              size: 30,
              color: Colors.black54,
            )),
      );
    } else if (actDetail.detail_type == 'to_do') {
      return ToDoCard(
        actDetail: actDetail,
        key: Key('$index'),
        delete: IconButton(
            onPressed: (() {
              remove(index);
            }),
            icon: const Icon(
              Icons.delete,
              size: 30,
              color: Colors.black54,
            )),
      );
    }
    return TextCard(
      key: Key('$index'),
      delete: IconButton(
          onPressed: (() {
            remove(index);
          }),
          icon: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.black54,
          )),
    );
  }

  Widget formBuilder(BuildContext context) {
    return Center(
      child: Container(
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
            child: Scrollbar(
              isAlwaysShown: true,
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "Form Builder",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  DoubleSpace(),
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return ErrorAlertDialog(
                                      title: "Disable",
                                      error:
                                          "Fill The Above Form To Perform This Action");
                                });
                          }
                        : () {
                            setState(() {
                              final newIndex = widget.activity_details!.length;

                              final item = ActivityDetail(
                                  detail_name: "Text" + newIndex.toString(),
                                  detail_urutan: newIndex,
                                  detail_type: "text",
                                  activity: widget.activity);
                              widget.activity_details!.insert(newIndex, item);
                            });
                          },
                    child: BuilderTile(
                      icon: Icons.text_format_sharp,
                      title: "Text",
                      subtitle: "Single line or mulitline text area",
                    ),
                  ),
                  HalfSpace(),
                  InkWell(
                    onTap: () {},
                    child: BuilderTile(
                      icon: Icons.picture_as_pdf_sharp,
                      title: "Document",
                      subtitle: "Upload files",
                    ),
                  ),
                  HalfSpace(),
                  InkWell(
                    onTap: () {},
                    child: BuilderTile(
                      icon: Icons.image_sharp,
                      title: "Image",
                      subtitle: "Upload image",
                    ),
                  ),
                  HalfSpace(),
                  InkWell(
                    onTap: () {},
                    child: BuilderTile(
                        icon: Icons.video_collection_sharp,
                        title: "Video",
                        subtitle: "Upload media"),
                  ),
                  HalfSpace(),
                  InkWell(
                    onTap: () {},
                    child: BuilderTile(
                      icon: Icons.list_sharp,
                      title: "To Do List",
                      subtitle: "Add to do",
                    ),
                  ),
                  HalfSpace(),
                ]),
              ),
            ),
          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleField("Activity Name", formProv.isActNameEmpty, 14),
                      const HalfSpace(),
                      SizedBox(
                        child: TextFormField(
                            onChanged: (value) {
                              formProv.isActNameEmpty =
                                  _actNameCtrl.text.isEmpty;
                              widget.activity!.activity_name = value;
                            },
                            controller: _actNameCtrl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: DEFAULT_PADDING,
                ),
                // Category
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleField("Category", formProv.isCategoryEmpty, 14),
                      const HalfSpace(),
                      (formProv.isFetchingData)
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.1,
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
                                    late final cat;
                                    for (int i = 0;
                                        i < categories.length;
                                        i++) {
                                      if (categories[i].id == value) {
                                        cat = categories[i];
                                      }
                                    }
                                    widget.activity!.category = cat;

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
                ),
              ],
            ),

            const DoubleSpace(),

            titleField("Activity Description", formProv.isActDescEmpty, 14),
            const HalfSpace(),
            TextFormField(
                maxLines: 2,
                onChanged: (value) {
                  formProv.isActDescEmpty = _actDescCtrl.text.isEmpty;

                  widget.activity!.activity_description = value;
                },
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

  remove(int index) {
    setState(() {
      widget.activity_details!.removeAt(index);
    });
  }
}

Container titleField(title, isEmpty, textSize) => Container(
    alignment: Alignment.centerLeft,
    child: (isEmpty)
        ? Text(
            title + "*",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
                fontSize: textSize),
          )
        : Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: textSize),
          ));
