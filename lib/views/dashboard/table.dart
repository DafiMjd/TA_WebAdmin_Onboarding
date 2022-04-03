import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/column_name_parse.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:webadmin_onboarding/utils/PaginatedDataTableCustom.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class MyTable extends StatelessWidget {
  const MyTable({Key? key, required this.datas, required this.colnames})
      : super(key: key);

  final List<dynamic> datas;
  final List<String> colnames;

  @override
  Widget build(BuildContext context) {
    List<String> myList = ["dafi", "majid", "fadhlih"];

    final DataTableSource _dataTable = MyData(datas: datas, colnames: colnames);

    return Column(
      children: [

        SizedBox(height: DEFAULT_PADDING),
        paginatedDataTable(_dataTable),
      ],
    );
  }

  List<DataColumn> getDataColumns() {
    List<DataColumn> columns = [DataColumn(label: Text("Action"))];
    for (int i = 0; i < colnames.length; i++) {
      columns.add(
          DataColumn(label: Text(ColumnNameParse.parseColName(colnames[i]))));
    }
    return columns;
  }

  PaginatedDataTableCustom paginatedDataTable(DataTableSource _dataTable) {
    return PaginatedDataTableCustom(
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
class MyData extends DataTableSource {
  final List<dynamic> datas;
  final List<String> colnames;

  MyData({required this.datas, required this.colnames});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => datas.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    var identifier = colnames[index];
    print("dafi1: " + identifier);
    print("dafi2: " + datas[index].getData(identifier).toString());

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
                      onPressed: (() {}), icon: Icon(Icons.details))),
              SizedBox(
                width: 5,
              ),
              Tooltip(
                  message: "Edit",
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  )),
              SizedBox(
                width: 5,
              ),
              Tooltip(
                  message: "Delete",
                  child:
                      IconButton(onPressed: (() {}), icon: Icon(Icons.delete))),
            ],
          )),

          for (int i = 0; i < colnames.length; i++)
            DataCell(
              Text(datas[index].getData(colnames[i]).toString()),
            ),

        ]);
  }
}
