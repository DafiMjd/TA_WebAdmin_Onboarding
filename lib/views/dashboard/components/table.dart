import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/responsive.dart';
import 'package:webadmin_onboarding/PaginatedDataTableCustom.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class MyTable extends StatelessWidget {
  const MyTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> myList = ["dafi", "majid", "fadhlih"];

    final DataTableSource _data = MyData();

    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                
                padding: EdgeInsets.symmetric(
                  horizontal: DEFAULT_PADDING * 1.5,
                  vertical:
                      DEFAULT_PADDING / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: DEFAULT_PADDING),
        paginatedDataTable(_data),
      ],
    );
  }


// kinara
  PaginatedDataTableCustom paginatedDataTable(DataTableSource _data) {
    return PaginatedDataTableCustom(
      header: Text("Dafi"),
      source: _data,
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Action')),
        DataColumn(
            label: Text(
          'Name',
          textAlign: TextAlign.center,
        )),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Price')),
      ],
      columnSpacing: 50,
      horizontalMargin: 10,
      rowsPerPage: 2,
      showCheckboxColumn: false,
    );
  }

}

// The "soruce" of the table
class MyData extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            "id": index,
            "title": "Dafi majid Fadhlih 199929sdafkljsadkfjsdlafjksld29292",
            "price": Random().nextInt(10000)
          });

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
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
          DataCell(Text(
            _data[index]['id'].toString(),
          )),
          DataCell(Row(
            children: [
              Tooltip(message: "Detail", child: IconButton(onPressed: (() {
                
              }), icon: Icon(Icons.details))),
              SizedBox(
                width: 5,
              ),
              Tooltip(message: "Edit", child: IconButton(onPressed: () {
                
              }, icon: Icon(Icons.edit),)),
              SizedBox(
                width: 5,
              ),
              Tooltip(message: "Delete", child: IconButton(onPressed: (() {
                
              }), icon: Icon(Icons.delete))),
            ],
          )),
          DataCell(
            Text(
              _data[index]["title"],
            ),
          ),
          DataCell(Text(
            _data[index]["title"],
          )),
          DataCell(Text(_data[index]["title"])),
          DataCell(Text(_data[index]["title"])),
          // Action Cell
          
        ]);
  }
}
