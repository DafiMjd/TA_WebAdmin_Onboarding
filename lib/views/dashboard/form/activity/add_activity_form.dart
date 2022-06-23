// ignore_for_file: non_constant_identifier_names, unused_import, avoid_web_libraries_in_flutter, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';

import 'package:webadmin_onboarding/models/category.dart';

import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';

import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/activity_preview.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/add_text_detail_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/add_video_detail_form.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/widgets/detail_card.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/widgets/form_builder_tile.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/add_file_detail_form.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddActivityForm extends StatefulWidget {
  AddActivityForm({Key? key, this.activity, required this.type})
      : super(key: key);

  Activity? activity;
  String type;
  // List<ActivityDetail> activity_details;

  @override
  State<AddActivityForm> createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
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

  List<int> deletedActDetailIds = [];

  ScrollController scrollCtrlGeneral = ScrollController();
  ScrollController scrollCtrlActionAndBuilder = ScrollController();
  ScrollController scrollCtrlAction = ScrollController();
  ScrollController scrollCtrlBuilder = ScrollController();

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
      widget.activity = Activity(type: widget.type);
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

    _loadDropDownData();
  }

  void _loadActDetails() async {
    formProv.isFetchingData = true;
    try {
      details = await dataProv.fetchDetailByActivityId(widget.activity!);
      if (details.isNotEmpty) {
        details = reorderActivityDetailsAfterFetch(details);
      }
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
            child: Scrollbar(
              controller: scrollCtrlGeneral,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollCtrlGeneral,
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
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text("cancel")),
                                                TextButton(
                                                    onPressed: () {
                                                      _removeActivityDetail(
                                                          index);
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    child: const Text("okay")),
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                  edit: (formProv.actDetails[index]
                                                  .detail_type ==
                                              'pdf' ||
                                          formProv.actDetails[index]
                                                  .detail_type ==
                                              'video' ||
                                          formProv.actDetails[index]
                                                  .detail_type ==
                                              'image'||
                                          formProv.actDetails[index]
                                                  .detail_type ==
                                              'video_link')
                                      ? Container()
                                      : IconButton(
                                          onPressed: () async {
                                            return showDialog(
                                                context: context,
                                                builder: (context) {
                                                  var type = formProv
                                                      .actDetails[index]
                                                      .detail_type;
                                                  if (type == 'text' ||
                                                      type == 'to_do' ||
                                                      type == 'header') {
                                                    return AddTextDetailForm(
                                                        type: type,
                                                        detail: formProv
                                                            .actDetails[index]);
                                                  } else {
                                                    return AddFileDetailForm(
                                                        type: type,
                                                        detail: formProv
                                                            .actDetails[index]);
                                                  }
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
                    Space.doubleSpace(),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Scrollbar(
              controller: scrollCtrlActionAndBuilder,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollCtrlActionAndBuilder,
                child: Column(
                  children: [
                    actionBuilder(context),
                    formBuilder(context),
                  ],
                ),
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
                  controller: scrollCtrlAction,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                      controller: scrollCtrlAction,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // preview button
                          InkWell(
                            onTap: () async {
                              if (_actDescCtrl.text.isEmpty ||
                                  _actNameCtrl.text.isEmpty ||
                                  formProv.isCategoryEmpty) {
                                return formDisable(context,
                                    "Fill The Above Form To Perform This Action");
                              } else {
                                if (formProv.actDetails.isEmpty) {
                                  return activityDetailEmpty(context);
                                }
                                // mainProv.isDevicePreview = true;
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ActivityPreview(
                                //             actDetails: formProv.actDetails,
                                //             activity: widget.activity!)));
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("close"))
                                        ],
                                        title: Text("Preview"),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        content: Builder(
                                          builder: (context) {
                                            return SizedBox(
                                              // height: height,
                                              width: 390,
                                              height: 840,
                                              child: ActivityPreview(
                                                actDetails: formProv.actDetails,
                                                activity: widget.activity!,
                                              ),
                                            );
                                          },
                                        ),
                                        contentPadding:
                                            EdgeInsets.all(DEFAULT_PADDING),
                                      );
                                      // return ActivityPreview(actDetails: formProv.actDetails, activity: widget.activity!);
                                    });
                              }
                            },
                            child: FormBuilderTile(
                                icon: Icons.remove_red_eye_outlined,
                                title: "Preview",
                                subtitle: "Preview On Mobile"),
                          ),
                          Space.halfSpace(),
                          // save button
                          InkWell(
                            onTap: () async {
                              if (_actDescCtrl.text.isEmpty ||
                                  _actNameCtrl.text.isEmpty ||
                                  formProv.isCategoryEmpty) {
                                return formDisable(context,
                                    "Fill The Above Form To Perform This Action");
                              } else {
                                if (formProv.actDetails.isEmpty) {
                                  return activityDetailEmpty(context);
                                }

                                reorderActivityDetailsUrutan();
                                if (formProv.isFetchingData) {
                                  return formDisable(context, "Loading");
                                }

                                if (isEditing) {
                                  if (deletedActDetailIds.isNotEmpty) {
                                    for (int i = 0;
                                        i < deletedActDetailIds.length;
                                        i++) {
                                      _removeActivityDetailFromDb(
                                          deletedActDetailIds[i]);
                                    }
                                  }
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
              controller: scrollCtrlBuilder,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollCtrlBuilder,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "Form Builder",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Space.doubleSpace(),
                  // Header
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return formDisable(context,
                                "Fill The Above Form To Perform This Action");
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddTextDetailForm(type: 'header');
                                });
                          },
                    child: FormBuilderTile(
                      icon: Icons.h_mobiledata_outlined,
                      title: "Header",
                      subtitle: "header",
                    ),
                  ),
                  Space.halfSpace(),
                  // Text
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return formDisable(context,
                                "Fill The Above Form To Perform This Action");
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddTextDetailForm(type: 'text');
                                });
                          },
                    child: FormBuilderTile(
                      icon: Icons.text_format_sharp,
                      title: "Text",
                      subtitle: "Single line or mulitline text area",
                    ),
                  ),
                  Space.halfSpace(),
                  // To Do
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return formDisable(context,
                                "Fill The Above Form To Perform This Action");
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddTextDetailForm(
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
                  Space.halfSpace(),
                  // Document
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return formDisable(context,
                                "Fill The Above Form To Perform This Action");
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddFileDetailForm(
                                    type: 'pdf',
                                  );
                                });
                          },
                    child: FormBuilderTile(
                      icon: Icons.picture_as_pdf_sharp,
                      title: "Document",
                      subtitle: "Upload file",
                    ),
                  ),
                  Space.halfSpace(),
                  // Image
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return formDisable(context,
                                "Fill The Above Form To Perform This Action");
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddFileDetailForm(
                                    type: 'image',
                                  );
                                });
                          },
                    child: FormBuilderTile(
                      icon: Icons.image_sharp,
                      title: "Image",
                      subtitle: "Upload image",
                    ),
                  ),
                  Space.space(),
                  // Video
                  InkWell(
                    onTap: (_actDescCtrl.text.isEmpty ||
                            _actNameCtrl.text.isEmpty ||
                            formProv.isCategoryEmpty)
                        ? () async {
                            return formDisable(context,
                                "Fill The Above Form To Perform This Action");
                          }
                        : () async {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AddVideoDetailForm();
                                });
                          },
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
      _editActivityDetail(data, formProv.actDetails);
      // List<String> colnames = dataProv.colnames;
      // menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
      //     menuProv.menuId, null, null);
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
        if (details[i].id == null) {
          await dataProv.createActivityDetail(details[i], widget.activity!.id);
        } else {
          await dataProv.editActivityDetail(details[i]);
        }
        // menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
        //     menuProv.menuId, null, null);
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
        await dataProv.createActivityDetail(details[i], data.last.id);
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

  void _removeActivityDetail(int index) async {
    setState(() {
      // if editing && act detail already on DB delete actdetila from db
      if (isEditing && formProv.actDetails[index].id != null) {
        deletedActDetailIds.add(formProv.actDetails[index].id!);
      }
      formProv.actDetails.removeAt(index);

      reorderActivityDetailsUrutan();
    });
  }

  void _removeActivityDetailFromDb(int index) async {
    try {
      await dataProv.deleteActivityDetail(index);
    } catch (e) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "Http Error", error: e.toString());
          });
    }
  }

  List<ActivityDetail> reorderActivityDetailsAfterFetch(
      List<ActivityDetail> list) {
    list.sort((a, b) => a.detail_urutan.compareTo(b.detail_urutan));
    return list;
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

  Future<void> formDisable(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(title: "Disable", error: message);
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
            Space.doubleSpace(),
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
                      Space.halfSpace(),
                      SizedBox(
                        child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(200),
                            ],
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
                      Space.halfSpace(),
                      (formProv.isFetchingData)
                          ? const CircularProgressIndicator()
                          : categoryDropdown()
                    ],
                  ),
                ),
              ],
            ),
            Space.doubleSpace(),
            titleField("Activity Description", formProv.isActDescEmpty, 14),
            Space.halfSpace(),
            TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(200),
                ],
                maxLines: 2,
                onChanged: (value) {
                  formProv.isActDescEmpty = _actDescCtrl.text.isEmpty;

                  formProv.activity.activity_description = value;
                },
                controller: _actDescCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                )),
            Space.doubleSpace(),
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
