// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:webadmin_onboarding/providers/data_provider.dart';
// import 'package:webadmin_onboarding/providers/menu_provider.dart';
// import 'package:webadmin_onboarding/utils/column_name_parse.dart';
// import 'package:webadmin_onboarding/utils/PaginatedDataTableCustom.dart';
// import 'package:webadmin_onboarding/utils/constants.dart';
// import 'package:webadmin_onboarding/utils/custom_colors.dart';
// import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
// import 'package:webadmin_onboarding/widgets/space.dart';


// class MyTable extends StatelessWidget {
//   const MyTable(
//       {Key? key,
//       required this.datas,
//       required this.colnames,
//       required this.menuId})
//       : super(key: key);

//   final List<dynamic> datas;
//   final List<String> colnames;
//   final String menuId;

//   @override
//   Widget build(BuildContext context) {
//     DataProvider dataProv = context.watch<DataProvider>();
//     MenuProvider menuProv = context.watch<MenuProvider>();

//     final DataTableSource _dataTable = MyData(
//         datas: datas,
//         colnames: colnames,
//         menuId: menuId,
//         dataProv: dataProv,
//         menuProv: menuProv,
//         context: context);

//     return Column(
//       children: [
//         const Space.space(),
//         paginatedDataTable(_dataTable),
//       ],
//     );
//   }

//   List<DataColumn> getDataColumns() {
//     List<DataColumn> columns = [const DataColumn(label: Text("Action"))];
//     for (int i = 0; i < colnames.length; i++) {
//       columns.add(
//           DataColumn(label: Text(ColumnNameParse.parseColName(colnames[i]))));
//     }
//     return columns;
//   }

//   PaginatedDataTableCustom paginatedDataTable(DataTableSource _dataTable) {
//     return PaginatedDataTableCustom(
//       source: _dataTable,
//       columns: getDataColumns(),
//       columnSpacing: 50,
//       horizontalMargin: 10,
//       rowsPerPage: (datas.length > 2) ? 2 : datas.length,
//       showCheckboxColumn: false,
//     );
//   }
// }

// // The "soruce" of the table
// class MyData extends DataTableSource {
//   final List<dynamic> datas;
//   final List<String> colnames;
//   final String menuId;
//   final DataProvider dataProv;
//   final MenuProvider menuProv;
//   final BuildContext context;

//   MyData(
//       {required this.datas,
//       required this.colnames,
//       required this.menuId,
//       required this.dataProv,
//       required this.menuProv,
//       required this.context});

//   @override
//   bool get isRowCountApproximate => false;
//   @override
//   int get rowCount => datas.length;
//   @override
//   int get selectedRowCount => 0;
//   @override
//   DataRow getRow(int index) {
//     return DataRow(
//         color: MaterialStateProperty.resolveWith<Color?>(
//             (Set<MaterialState> states) {
//           // Even rows will have a grey color.
//           if (index.isEven) {
//             return TABLE_EVEN;
//           }
//           return TABLE_ODD; // Use default value for other states and odd rows.
//         }),
//         cells: [
//           DataCell(Row(
//             children: [
//               Tooltip(
//                   message: "Detail",
//                   child: IconButton(
//                       onPressed: (() {}), icon: const Icon(Icons.details))),
//               const SizedBox(
//                 width: 5,
//               ),
//               Tooltip(
//                   message: "Edit",
//                   child: IconButton(
//                     onPressed: () {
//                       _action(index, "edit");
//                     },
//                     icon: const Icon(Icons.edit),
//                   )),
//               const SizedBox(
//                 width: 5,
//               ),
//               Tooltip(
//                   message: "Delete",
//                   child: IconButton(
//                       onPressed: (() {
//                         _action(index, "delete");
//                       }),
//                       icon: const Icon(Icons.delete))),
//             ],
//           )),
//           for (int i = 0; i < colnames.length; i++)
//             DataCell(Text(datas[index].getData(colnames[i]).toString())),
//         ]);
//   }

//   void _action(int index, action) async {
//     if (action == "delete") {
//       try {
//         menuProv.isFetchingData = true;
//         var data = await dataProv.action(menuProv.menuId, "delete",
//             datas[index].getData(colnames[0]).toString());
//         menuProv.isFetchingData = false;

//         menuProv.setDashboardContent("table", data, colnames, menuProv.menuName,
//             menuProv.menuId, null, null);
//       } catch (e) {
//         menuProv.isFetchingData = false;
//         // return showDialog(
//         //     context: context,
//         //     builder: (context) {
//         //       return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
//         //     });
//       }
//     } else if (action == "edit") {
//       menuProv.setDashboardContent(
//           "form", null, null, null, menuProv.menuId, action, datas[index]);
//     }
//   }
// }
