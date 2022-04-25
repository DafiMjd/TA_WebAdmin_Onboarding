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
import 'package:webadmin_onboarding/views/dashboard/form/activity/add_activity_detail_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/detail_card.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/form_builder_tile.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/text_card.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/todo_card.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropped_file_widget.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropzone_widget.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/double_space.dart';
import 'package:webadmin_onboarding/widgets/half_space.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddActivityForm extends StatefulWidget {
  AddActivityForm({Key? key, this.activity}) : super(key: key);

  Activity? activity;
  // List<ActivityDetail> activity_details;

  @override
  State<AddActivityForm> createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  // final List<int> _items = List<int>.generate(5, (int index) => index);
  late MenuProvider menuProv;
  late DataProvider dataProv;
  late AddActivityFormProvider formProv;

  late String _selectedCategoryId;
  late String _selectedCategoryTitle;
  late List<ActivityCategory> categories;

  late final TextEditingController _actNameCtrl;
  late final TextEditingController _actDescCtrl;

  late List<ActivityDetail> details;

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
      formProv.isCategoryEmpty = true;

      isEditing = false;
      widget.activity = Activity();
      formProv.activity = widget.activity;
      List<ActivityDetail> init = [];
      formProv.actDetails = init;
    } else {
      formProv.activity = widget.activity;
      _loadActDetails();
      // means editing
      _actNameCtrl =
          TextEditingController(text: widget.activity!.activity_name);
      _actDescCtrl =
          TextEditingController(text: widget.activity!.activity_description);
      _selectedCategoryId = widget.activity!.id.toString();
      _selectedCategoryTitle = widget.activity!.category!.category_name;

      formProv.isActNameEmpty = _actNameCtrl.text.isEmpty;
      formProv.isActDescEmpty = _actDescCtrl.text.isEmpty;
      formProv.isCategoryEmpty = _selectedCategoryId.isEmpty;

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

    // formProv.actDetails = [
    //   ActivityDetail(
    //       id: 1,
    //       detail_urutan: 0,
    //       detail_name: "Text1",
    //       detail_desc: "Belajar Dart",
    //       detail_link: "detail_link",
    //       detail_type: "text",
    //       activity: act),
    //   ActivityDetail(
    //       id: 2,
    //       detail_urutan: 1,
    //       detail_name: "ToDo1",
    //       detail_desc: "Belajar MVVM",
    //       detail_link: "detail_link",
    //       detail_type: "to_do",
    //       activity: act),
    //   ActivityDetail(
    //       id: 3,
    //       detail_urutan: 2,
    //       detail_name: "Text2",
    //       detail_desc: "Belajar Provider",
    //       detail_link: "detail_link",
    //       detail_type: "text",
    //       activity: act),
    // ];

    _loadDropDownData();
  }

  void _loadActDetails() async {
    formProv.isFetchingData = true;
    try {
      details = await dataProv.fetchDetailByActivityId(widget.activity!);
      formProv.isFetchingData = false;
    } catch (e) {
      formProv.isFetchingData = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
          });
    }
    formProv.actDetails = details;

    // print("dafi detail: " + details.isEmpty.toString());
  }

  void _loadDropDownData() async {
    formProv.isFetchingData = true;
    try {
      categories = await dataProv.fetchActivityCategories();
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
    formProv = context.watch<AddActivityFormProvider>();

    if ((formProv.isFetchingData)) {
      return const SizedBox(
          height: 100,
          width: 100,
          child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator())));
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Activity General Form
                  Container(
                    margin: const EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width,
                    child: activityForm(context),
                  ),
                  if (formProv.actDetails.isNotEmpty)
                    Theme(
                      data: ThemeData(canvasColor: Colors.transparent),
                      child: ReorderableListView.builder(
                        itemCount: formProv.actDetails.length,
                        itemBuilder: (context, index) {
                          // return getActivityDetailWidget(index);
                          return Container(
                            key: Key('$index'),
                            margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 5,
                              child: DetailCard(
                                actDetail: formProv.actDetails[index],
                                delete: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Are You Sure?"),
                                            content:
                                                Text("Press Okay To Delete"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                  child: const Text("cancel")),
                                              TextButton(
                                                  onPressed: () {
                                                    removeActivityDetail(index);
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                  child: const Text("okay")),
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                                edit: IconButton(
                                    onPressed: () async {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AddActivityDetailForm(
                                                type: formProv.actDetails[index]
                                                    .detail_type,
                                                detail:
                                                    formProv.actDetails[index]);
                                          });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                    )),
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        scrollController: ScrollController(),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            reorderActivityDetails(oldIndex, newIndex);
                            reorderActivityDetailsUrutan();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  actionBuilder(context),
                  formBuilder(context),
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  Widget actionBuilder(BuildContext context) {
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
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: FormBuilderTile(
                            icon: Icons.remove_red_eye_outlined,
                            title: "Preview",
                            subtitle: "Preview On Mobile"),
                      ),
                      HalfSpace(),
                      InkWell(
                        onTap: () async {
                          if (_actDescCtrl.text.isEmpty ||
                              _actNameCtrl.text.isEmpty ||
                              formProv.isCategoryEmpty) {
                            return formNotFilledDisable(context);
                          } else {
                            if (formProv.actDetails.isEmpty) {
                              return activityDetailEmpty(context);
                            }
                            if (isEditing) {
                              print("dafi");
                              _editActivity(formProv.activity);
                            } else {
                              _addActivity(formProv.activity);
                            }
                          }
                        },
                        child: FormBuilderTile(
                            icon: Icons.save_alt_rounded,
                            title: "Save",
                            subtitle: "Save New Activity"),
                      ),
                    ],
                  )),
                )),
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
                            return formNotFilledDisable(context);
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddActivityDetailForm(type: 'text');
                                });
                          },
                    child: FormBuilderTile(
                      icon: Icons.text_format_sharp,
                      title: "Text",
                      subtitle: "Single line or mulitline text area",
                    ),
                  ),
                  HalfSpace(),
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return formNotFilledDisable(context);
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddActivityDetailForm(
                                    type: 'to_do',
                                  );
                                });
                          },
                    child: FormBuilderTile(
                      icon: Icons.list_sharp,
                      title: "To Do List",
                      subtitle: "Add to do",
                    ),
                  ),
                  HalfSpace(),
                  InkWell(
                    onTap: () {},
                    child: FormBuilderTile(
                      icon: Icons.picture_as_pdf_sharp,
                      title: "Document",
                      subtitle: "Upload files",
                    ),
                  ),
                  HalfSpace(),
                  InkWell(
                    onTap: () {},
                    child: FormBuilderTile(
                      icon: Icons.image_sharp,
                      title: "Image",
                      subtitle: "Upload image",
                    ),
                  ),
                  Space(),
                  InkWell(
                    onTap: () {},
                    child: FormBuilderTile(
                        icon: Icons.video_collection_sharp,
                        title: "Video",
                        subtitle: "Upload media"),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editActivity(Activity activity) async {
    formProv.isSaveButtonDisabled = true;
    try {
      List<Activity> data = await dataProv.editActivity(activity);
      // _addActivityDetail(data, formProv.actDetails);
      List<String> colnames = dataProv.colnames;
      menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
          menuProv.menuId, null, null);
      formProv.isSaveButtonDisabled = false;
    } catch (e) {
      formProv.isSaveButtonDisabled = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "Http Error", error: e.toString());
          });
    }
    formProv.isSaveButtonDisabled = false;
  }

  void _editActivityDetail(
      List<Activity> data, List<ActivityDetail> details) async {
    List<String> colnames = dataProv.colnames;

    for (int i = 0; i < details.length; i++) {
      try {
        dataProv.editActivityDetail(details[i]);
        // print(details[i].toString());
      } catch (e) {
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "Http Error", error: e.toString());
            });
      }
    }

    menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
        menuProv.menuId, null, null);
  }

  void _addActivity(Activity activity) async {
    formProv.isSaveButtonDisabled = true;
    try {
      List<Activity> data = await dataProv.createActivity(activity);
      _addActivityDetail(data, formProv.actDetails);
      formProv.isSaveButtonDisabled = false;
    } catch (e) {
      formProv.isSaveButtonDisabled = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "Http Error", error: e.toString());
          });
    }
    formProv.isSaveButtonDisabled = false;
  }

  void _addActivityDetail(
      List<Activity> data, List<ActivityDetail> details) async {
    List<String> colnames = dataProv.colnames;

    for (int i = 0; i < details.length; i++) {
      try {
        dataProv.createActivityDetail(details[i], data.last.id);
        // print(details[i].toString());
      } catch (e) {
        return showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(title: "Http Error", error: e.toString());
            });
      }
    }

    menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
        menuProv.menuId, null, null);
  }

  removeActivityDetail(int index) {
    setState(() {
      formProv.actDetails.removeAt(index);
      reorderActivityDetailsUrutan();
    });
  }

  void reorderActivityDetails(oldIndex, newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ActivityDetail item = formProv.actDetails.removeAt(oldIndex);
    formProv.actDetails.insert(newIndex, item);
  }

  // reorder field urutan activity details
  void reorderActivityDetailsUrutan() {
    for (int i = 0; i < formProv.actDetails.length; i++) {
      formProv.actDetails[i].detail_urutan = i;
    }
  }

  Future<void> formNotFilledDisable(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
              title: "Disable",
              error: "Fill The Above Form To Perform This Action");
        });
  }

  Future<void> activityDetailEmpty(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
              title: "Disable",
              error:
                  "Provide The Content Of The Activity\nUse The Form Builder");
        });
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
                              formProv.activity.activity_name = value;
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
                          : categoryDropdown()
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

                  formProv.activity.activity_description = value;
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
                      // for (int i = 0; i < formProv.actDetails.length; i++) {
                      //   print(formProv.actDetails[i].toString());
                      // }
                      print("dafi: " +
                          formProv.actDetails[0].toString() +
                          "\n\n" +
                          formProv.actDetails[1].toString());
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

  categoryDropdown() {
    if (!isEditing) {
      return DropdownButtonFormField(
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
            for (int i = 0; i < categories.length; i++) {
              if (categories[i].id == value) {
                cat = categories[i];
              }
            }
            formProv.activity.category = cat;

            _selectedCategoryId = value.toString();
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
    } else {
      return DropdownButtonFormField(
        hint: Text(_selectedCategoryTitle),
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
            for (int i = 0; i < categories.length; i++) {
              if (categories[i].id == value) {
                cat = categories[i];
              }
            }
            formProv.activity.category = cat;

            _selectedCategoryId = value.toString();
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
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
}
