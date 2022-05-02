import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/activity.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/column_name_parse.dart';
import 'package:webadmin_onboarding/utils/PaginatedDataTableCustom.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/views/dashboard/form/activity/activity_preview.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/custom_advanced_paginated_datatable.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class MyTable2 extends StatelessWidget {
  const MyTable2(
      {Key? key,
      required this.datas,
      required this.colnames,
      required this.menuId})
      : super(key: key);

  final List<dynamic> datas;
  final List<String> colnames;
  final String menuId;

  @override
  Widget build(BuildContext context) {
    DataProvider dataProv = context.watch<DataProvider>();
    MenuProvider menuProv = context.watch<MenuProvider>();

    final AdvancedDataTableSource _dataTable = MyData(
        datas: datas,
        colnames: colnames,
        menuId: menuId,
        dataProv: dataProv,
        menuProv: menuProv,
        context: context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Space.space(),
          paginatedDataTable(_dataTable),
        ],
      ),
    );
  }

  List<DataColumn> getDataColumns() {
    List<DataColumn> columns = [const DataColumn(label: Text("Action"))];
    for (int i = 0; i < colnames.length; i++) {
      columns.add(
          DataColumn(label: Text(ColumnNameParse.parseColName(colnames[i]))));
    }
    return columns;
  }

  CustomAdvancedPaginatedDataTable paginatedDataTable(
      AdvancedDataTableSource _dataTable) {
    return CustomAdvancedPaginatedDataTable(
      source: _dataTable,
      columns: getDataColumns(),
      columnSpacing: 50,
      horizontalMargin: 10,
      rowsPerPage: (datas.length > 8) ? 8 : datas.length,
      showCheckboxColumn: false,
    );
  }
}

// The "soruce" of the table
class MyData extends AdvancedDataTableSource {
  final List<dynamic> datas;
  final List<String> colnames;
  final String menuId;
  final DataProvider dataProv;
  final MenuProvider menuProv;
  final BuildContext context;

  MyData(
      {required this.datas,
      required this.colnames,
      required this.menuId,
      required this.dataProv,
      required this.menuProv,
      required this.context});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => datas.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
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
          DataCell(Row(
            children: [
              Tooltip(
                  message: "Detail",
                  child: IconButton(
                      onPressed: (() {
                        _action(index, "detail");
                      }),
                      icon: const Icon(Icons.details))),
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
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: const Text("cancel")),
                                  TextButton(
                                      onPressed: () {
                                        _action(index, "delete");
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: const Text("okay")),
                                ],
                              );
                            });
                      }),
                      icon: const Icon(Icons.delete))),
            ],
          )),
          for (int i = 0; i < colnames.length; i++)
            DataCell(Text(datas[index].getData(colnames[i]).toString())),
        ]);
  }

  Future<void> _delete(index) async {
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
      err = e.toString();
      menuProv.isFetchingData = false;
      // return showDialog(
      //       context: context,
      //       builder: (context) {
      //         return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
      //       });
    }

    if (err != null) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: err);
          });
    }
  }

  // Future<List<ActivityDetail>> _loadActDetails(Activity data) async {
  //   dataProv.isFetchingData = true;
  //   List<ActivityDetail> details;
  //   try {
  //     details = await dataProv.fetchDetailByActivityId(data);

  //     dataProv.isFetchingData = false;
  //   } catch (e) {
  //     dataProv.isFetchingData = false;
  //     return showDialog(
  //         context: context,
  //         builder: (context) {
  //           return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
  //         });
  //   }

  //   return details;

  //   // print("dafi detail: " + details.isEmpty.toString());
  // }

  void _action(int index, action) async {
    if (action == "delete") {
      _delete(index);
    } else if (action == "edit") {
      menuProv.setDashboardContent(
          "form", null, null, null, menuProv.menuId, action, datas[index]);
    } else if (action == "detail") {
      if (menuId == 'activity_list') {
        dataProv.isFetchingData = true;
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
                      return Container(
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
                return ErrorAlertDialog(
                    error: "HTTP Error", title: e.toString());
              });
        }
      }
    }
  }

  @override
  Future<RemoteDataSourceDetails> getNextPage(
      NextPageRequest pageRequest) async {
    return RemoteDataSourceDetails(
      datas.length,
      datas
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(), //again in a real world example you would only get the right amount of rows
    );
  }
}
