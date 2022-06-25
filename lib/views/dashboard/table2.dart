// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/models/activity_owned.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/assign_activity_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/column_name_parse.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/activity_preview.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/assign_activity.dart';
import 'package:webadmin_onboarding/widgets/checkbox_action.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/custom_advanced_paginated_datatable.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class MyTable2 extends StatelessWidget {
  const MyTable2(
      {Key? key,
      required this.datas,
      required this.colnames,
      required this.menuId,
      this.maxRow})
      : super(key: key);

  final List<dynamic> datas;
  final List<String> colnames;
  final String menuId;
  final int? maxRow;

  @override
  Widget build(BuildContext context) {
    DataProvider dataProv = context.watch<DataProvider>();
    MenuProvider menuProv = context.watch<MenuProvider>();
    AssignActivityProvider assignProv = context.watch<AssignActivityProvider>();

    ScrollController scrollbarController = ScrollController();

    final AdvancedDataTableSource _dataTable = MyData(
        datas: datas,
        colnames: colnames,
        menuId: menuId,
        dataProv: dataProv,
        menuProv: menuProv,
        assignProv: assignProv,
        context: context);

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollbarController,
      child: SingleChildScrollView(
        controller: scrollbarController,
        child: Column(
          children: [
            Space.space(),
            paginatedDataTable(_dataTable),
          ],
        ),
      ),
    );
  }

  List<DataColumn> getDataColumns() {
    List<DataColumn> columns = [];
    for (int i = 0; i < colnames.length; i++) {
      columns.add(
          DataColumn(label: Text(ColumnNameParse.parseColName(colnames[i]))));
    }
    columns.add(DataColumn(label: Text("Action")));
    return columns;
  }

  CustomAdvancedPaginatedDataTable paginatedDataTable(
      AdvancedDataTableSource _dataTable) {
    return CustomAdvancedPaginatedDataTable(
      source: _dataTable,
      columns: getDataColumns(),
      columnSpacing: 50,
      horizontalMargin: 10,
      rowsPerPage: (maxRow != null)
          ? maxRow!
          : (datas.length > 8)
              ? 8
              : datas.length,
      showCheckboxColumn: false,
    );
  }
}

// The "soruce" of the table
class MyData extends AdvancedDataTableSource {
  final List<dynamic> datas;
  final List<String> colnames;
  String menuId;
  final DataProvider dataProv;
  final MenuProvider menuProv;
  final AssignActivityProvider assignProv;
  final BuildContext context;
  List<User>? selectedUsers = [];

  MyData(
      {required this.datas,
      required this.colnames,
      required this.menuId,
      required this.dataProv,
      required this.menuProv,
      required this.context,
      required this.assignProv,
      this.selectedUsers});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => datas.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    final currentRowData = lastDetails!.rows[index];

    getSelectActions() => [
          Tooltip(
            message: "Select",
            child: CheckboxAction(press: () {
              assignProv.selectedUsers.contains(currentRowData)
                  ? assignProv.selectedUsers.remove(currentRowData)
                  : assignProv.selectedUsers.add(currentRowData);
            }),
          ),
        ];

    getBasicActions() => [
          Tooltip(
              message: "Edit",
              child: IconButton(
                onPressed: () {
                  _action(index, "edit");
                },
                icon: const Icon(Icons.edit),
              )),
          const SizedBox(
            width: 5,
          ),
          Tooltip(
              message: "Delete",
              child: IconButton(
                  onPressed: (() {
                    // _action(index, "delete");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are You Sure?"),
                            content: Text("Press Okay To Delete"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("cancel")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    _action(index, "delete");
                                  },
                                  child: const Text("okay")),
                            ],
                          );
                        });
                  }),
                  icon: const Icon(Icons.delete))),
        ];

    getActivityOwnedActions() => [
          Tooltip(
              message: "Detail",
              child: IconButton(
                onPressed: () {
                  menuId = 'activity_owned_by_user_list';
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('List Activiy Owned By ' +
                              datas[index].getData('Name')),
                          content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              // height: MediaQuery.of(context).size.height * 0.7,
                              child: (datas[index].activities_owned.isEmpty)
                                  ? Text("No Assigned Activities in This User")
                                  : MyTable2(
                                      datas: datas[index].activities_owned,
                                      colnames: [
                                        'activity_name',
                                        'status',
                                        'start_date',
                                        'end_date'
                                      ],
                                      menuId: menuId)),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  menuId = 'activity_owned_list';
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: const Text("close")),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.details_sharp),
              )),
          const SizedBox(
            width: 5,
          ),
          // Tooltip(
          //     message: "Edit",
          //     child: IconButton(
          //       onPressed: () {
          //         _action(index, "edit");
          //       },
          //       icon: const Icon(Icons.edit),
          //     )),
          // const SizedBox(
          //   width: 5,
          // ),
        ];

    getActivityActions() => [
          // Tooltip(
          //     message: "Preview",
          //     child: IconButton(
          //         onPressed: (() {
          //           _action(index, "detail");
          //         }),
          //         icon: const Icon(Icons.remove_red_eye_sharp))),
          // const SizedBox(
          //   width: 5,
          // ),
          Tooltip(
              message: "Edit",
              child: IconButton(
                onPressed: () {
                  _action(index, "edit");
                },
                icon: const Icon(Icons.edit),
              )),
          const SizedBox(
            width: 5,
          ),
          Tooltip(
              message: "Delete",
              child: IconButton(
                  onPressed: (() {
                    // _action(index, "delete");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are You Sure?"),
                            content: Text("Press Okay To Delete"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("cancel")),
                              TextButton(
                                  onPressed: () {
                                    _action(index, "delete");
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("okay")),
                            ],
                          );
                        });
                  }),
                  icon: const Icon(Icons.delete))),
          const SizedBox(
            width: 5,
          ),
          Tooltip(
              message: "Assign",
              child: IconButton(
                onPressed: () async {
                  // menuProv.dashboardContent = CircularProgressIndicator();
                  try {
                    List<ActivityOwned> assignedUser =
                        await _getAssignedUser(currentRowData.id);

                    List<User> unassignedUser =
                        await _getUnassignedUser(assignedUser);

                    menuProv.isTableShown = false;
                    menuProv.isFormShown = true;
                    menuProv.menuName = 'Assign Activity ' +
                        currentRowData.getData('activity_name');

                    (menuProv.isFetchingData)
                        ? menuProv.dashboardContent =
                            CircularProgressIndicator()
                        : menuProv.dashboardContent = AssignActivity(
                            assignedUser: assignedUser,
                            unassignedUser: unassignedUser,
                            activity: currentRowData,
                          );
                    // : menuProv.dashboardContent = MyTable2(
                    //     datas: unassignedUser,
                    //     colnames: [
                    //       'email',
                    //       'name',
                    //     ],
                    //     menuId: 'unassigned_user',
                    //     maxRow: 4,
                    //   );

                    // : showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AssignActivity(
                    //           assignedUser: assignedUser,
                    //           unassignedUser: unassignedUser,
                    //           activity: datas[index]);
                    //     });
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorAlertDialog(
                              error: e.toString(), title: e.toString());
                        });
                  }
                },
                icon: const Icon(Icons.send_rounded),
              )),
        ];

    getHomeActivityActions() => [
          Tooltip(
              message: "Preview",
              child: IconButton(
                  onPressed: (() {
                    _action(index, "detail");
                  }),
                  icon: const Icon(Icons.remove_red_eye_sharp))),
          const SizedBox(
            width: 5,
          ),
          Tooltip(
              message: "Edit",
              child: IconButton(
                onPressed: () {
                  _action(index, "edit");
                },
                icon: const Icon(Icons.edit),
              )),
          const SizedBox(
            width: 5,
          ),
          Tooltip(
              message: "Delete",
              child: IconButton(
                  onPressed: (() {
                    // _action(index, "delete");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are You Sure?"),
                            content: Text("Press Okay To Delete"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("cancel")),
                              TextButton(
                                  onPressed: () {
                                    _action(index, "delete");
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("okay")),
                            ],
                          );
                        });
                  }),
                  icon: const Icon(Icons.delete))),
          const SizedBox(
            width: 5,
          ),
        ];

    getUserActions() => [
          Tooltip(
              message: "Is Active",
              child: IconButton(
                  onPressed: (() {
                    _editActiveUser(index);
                  }),
                  icon: Icon((currentRowData.getData('active'))
                      ? Icons.check_box
                      : Icons.check_box_outline_blank))),
          const SizedBox(
            width: 5,
          ),
          Tooltip(
              message: "Edit Password",
              child: IconButton(
                onPressed: () {
                  _action(index, "edit");
                },
                icon: const Icon(Icons.password),
              )),
          const SizedBox(
            width: 5,
          ),
          Tooltip(
              message: "Delete",
              child: IconButton(
                  onPressed: (() {
                    // _action(index, "delete");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Are You Sure?"),
                            content: Text("Press Okay To Delete"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("cancel")),
                              TextButton(
                                  onPressed: () {
                                    _action(index, "delete");
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: const Text("okay")),
                            ],
                          );
                        });
                  }),
                  icon: const Icon(Icons.delete))),
        ];

    getNoAction() => [Text("No Action")];

    getActions(menuId) {
      if (menuId == 'user_list' || menuId == 'admin_list') {
        return getUserActions();
      } else if (menuId == 'activity_list') {
        return getActivityActions();
      } else if (menuId == 'home_activity_list') {
        return getHomeActivityActions();
      } else if (menuId == 'activity_owned_list') {
        return getActivityOwnedActions();
      } else if (menuId == 'jobtitle_list' || menuId == 'category_list') {
        return getBasicActions();
      } else if (menuId == 'role_list') {
        return getNoAction();
      } else if (menuId == 'unassigned_user') {
        return getSelectActions();
      } else {
        return getNoAction();
      }
    }

    return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          // Even rows will have a grey color.
          if (index.isEven) {
            return TABLE_EVEN;
          }
          return TABLE_ODD; // Use default value for other states and odd rows.
        }),
        cells: [
          for (int i = 0; i < colnames.length; i++)
            DataCell(Text(currentRowData.getData(colnames[i]).toString())),
          DataCell(Row(
            children: getActions(menuId),
          )),
        ]);
  }

  Future<void> _editActiveUser(index) async {
    menuProv.isFetchingData = true;
    List<dynamic> data;
    try {
      data = await dataProv.action(menuProv.menuId, "edit_active",
          datas[index].getData(colnames[0]).toString());
      menuProv.isFetchingData = false;

      menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
          menuProv.menuId, null, null);
    } catch (e) {
      menuProv.isFetchingData = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
          });
    }
  }

  Future<dynamic> _delete(index) async {
    var err = null;
    menuProv.isFetchingData = true;
    List<dynamic> data;
    try {
      data = await dataProv.action(menuProv.menuId, "delete",
          datas[index].getData(colnames[0]).toString());

      menuProv.isFetchingData = false;

      menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
          menuProv.menuId, null, null);
    } catch (e) {
      menuProv.isFetchingData = false;

      menuProv.setDashboardContent("table", datas, colnames, menuProv.menuName,
          menuProv.menuId, null, null);
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
          });
    }
  }

  void showActOwnedDetails(index) async {
    List<ActivityDetail> details = [];

    try {
      details = await dataProv.fetchDetailByActivityId(datas[index]);

      dataProv.isFetchingData = false;
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
              title:
                  Text('Activities Owned By ' + datas[index].getData('Name')),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  return MyTable2(
                      datas: datas[index].activities_owned,
                      colnames: ['activity_name', 'status'],
                      menuId: menuId);
                },
              ),
              contentPadding: EdgeInsets.all(DEFAULT_PADDING),
            );
            // return ActivityPreview(actDetails: formProv.actDetails, activity: widget.activity!);
          });
    } catch (e) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(error: "HTTP Error", title: e.toString());
          });
    }
  }

  void showActDetails(index) async {
    List<ActivityDetail> details = [];

    try {
      details = await dataProv.fetchDetailByActivityId(datas[index]);

      dataProv.isFetchingData = false;
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
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  return SizedBox(
                    // height: height,
                    width: 390,
                    height: 840,
                    child: ActivityPreview(
                      actDetails: details,
                      activity: datas[index],
                    ),
                  );
                },
              ),
              contentPadding: EdgeInsets.all(DEFAULT_PADDING),
            );
            // return ActivityPreview(actDetails: formProv.actDetails, activity: widget.activity!);
          });
    } catch (e) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(error: "HTTP Error", title: e.toString());
          });
    }
  }

  void _action(int index, action) async {
    if (action == "delete") {
      _delete(index);
    } else if (action == "edit") {
      if (menuId == 'home_activity_list') {
        menuProv.setDashboardContent(
            "form", null, null, null, 'activity_list', action, datas[index]);
      } else if (menuId == 'user_list' || menuId == 'admin_list') {
        menuProv.setDashboardContent(
            "form", null, null, null, menuProv.menuId, action, datas[index]);
      } else {
        menuProv.setDashboardContent(
            "form", null, null, null, menuProv.menuId, action, datas[index]);
      }
    } else if (action == "detail") {
      if (menuId == 'activity_list' || menuId == 'home_activity_list') {
        showActDetails(index);
      } else if (menuId == 'activity_owned_list') {
        showActOwnedDetails(index);
      }
    }
  }

  Future<List<ActivityOwned>> _getAssignedUser(int id) async {
    menuProv.isFetchingData = true;
    try {
      var data = await dataProv.fetchActivityOwnedByActivity(id);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> _getUnassignedUser(
      List<ActivityOwned> assignedUser) async {
    menuProv.isFetchingData = true;
    try {
      var data = await dataProv.fetchUsersByRole(4);

      if (assignedUser.isEmpty) {
        menuProv.isFetchingData = false;
        return data;
      }

      data.forEach((element) {});

      for (int i = 0; i < assignedUser.length; i++) {
        for (int j = 0; j < data.length; j++) {
          if (assignedUser[i].user_email == data[j].email) {
            data.removeAt(j);
          }
        }
      }

      menuProv.isFetchingData = false;

      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RemoteDataSourceDetails> getNextPage(
      NextPageRequest pageRequest) async {
    var x = datas.skip(pageRequest.offset).take(pageRequest.pageSize).toList();
    if (assignProv.selectedUsers.isNotEmpty) {
      assignProv.selectedUsers.clear();
    }
    return RemoteDataSourceDetails(datas.length, x);
  }
}
