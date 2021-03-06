// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity.dart';
import 'package:webadmin_onboarding/models/activity_owned.dart';
import 'package:webadmin_onboarding/models/activity_owned_by_user.dart';
import 'package:webadmin_onboarding/models/user.dart';
import 'package:webadmin_onboarding/providers/data_provider.dart';
import 'package:webadmin_onboarding/providers/form/assign_activity_provider.dart';
import 'package:webadmin_onboarding/providers/menu_provider.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/utils/responsive.dart';
import 'package:webadmin_onboarding/views/dashboard/table2.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AssignActivity extends StatelessWidget {
  const AssignActivity({
    Key? key,
    required this.assignedUser,
    required this.unassignedUser,
    required this.activity,
  }) : super(key: key);

  final List<ActivityOwned> assignedUser;
  final List<User> unassignedUser;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    AssignActivityProvider assignProv = context.watch<AssignActivityProvider>();
    ScrollController scrollbarController = ScrollController();
    return Scrollbar(
      controller: scrollbarController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollbarController,
        child: Column(
          children: [
            MyTable2(
              datas: unassignedUser,
              colnames: [
                'email',
                'name',
              ],
              menuId: 'unassigned_user',
              maxRow: 4,
            ),
            Space.space(),
            ElevatedButton(
                onPressed: () {
                  (assignProv.selectedUsers.isEmpty)
                      ? selectedUsersEmptyError(context)
                      : pickDateAndTime(context, assignProv);
                },
                child: Text(
                  (assignProv.isAssignButtonDisabled)
                      ? "Wait"
                      : "Pick Date & Time",
                )),
          ],
        ),
      ),
    );
  }

  Future<dynamic> pickDateAndTime(
      BuildContext context, AssignActivityProvider assignProv) {
    return showDialog(
        context: context,
        builder: (context) {
          return DateTimePicker(
            selectedUsers: assignProv.selectedUsers,
            activity: activity,
          );
        });
  }

  Future<dynamic> selectedUsersEmptyError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please select at least 1 user"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
            ],
          );
        });
  }
}

class DateTimePicker extends StatefulWidget {
  const DateTimePicker(
      {Key? key, required this.selectedUsers, required this.activity})
      : super(key: key);

  final List<User> selectedUsers;
  final Activity activity;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  String _startDate = '';
  String _startTime = '';
  String _endDate = '';
  String _endTime = '';

  String _startDateAndTime = '';
  String _endDateAndTime = '';

  String error = '';

  ScrollController scrollbarController = ScrollController();

  late DataProvider dataProv;
  late MenuProvider menuProv;
  late AssignActivityProvider assignProv;

  @override
  void initState() {
    super.initState();

    dataProv = Provider.of<DataProvider>(context, listen: false);
    menuProv = Provider.of<MenuProvider>(context, listen: false);
    assignProv = Provider.of<AssignActivityProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollbarController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollbarController,
        child: AlertDialog(
            title: Text("Pick Date and Time"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black54),
                  )),
              TextButton(
                  onPressed: () {
                    if (_startDateAndTime.isEmpty || _endDateAndTime.isEmpty) {
                      if (error != 'Please Fill All The Dates') {
                        setState(() {
                          error = 'Please Fill All The Dates';
                        });
                      }
                    } else {
                      DateTime start = DateTime.parse(_startDateAndTime);
                      DateTime end = DateTime.parse(_endDateAndTime);
                      if (start.isBefore(end)) {
                        error = '';
                        if (!assignProv.isAssignButtonDisabled) {
                          _assignActivity();
                        }
                      } else {
                        if (error !=
                            'Start DateAndTime Must Be Before End Date And Time') {
                          setState(() {
                            error =
                                'Start Date And Time Must Be Before End Date And Time';
                          });
                        }
                      }
                    }
                  },
                  child: (assignProv.isAssignButtonDisabled)
                      ? Text('Wait')
                      : Text("Assign")),
            ],
            content: (Responsive.isMobile(context))
                ? Column(
                    children: [
                      textField("Start Date"),
                      Space.halfSpace(),
                      startDate(context),
                      Space.space(),
                      textField("Start Time"),
                      Space.halfSpace(),
                      startTime(context),
                      Space.space(),
                      textField("End Date"),
                      Space.halfSpace(),
                      endDate(context),
                      Space.space(),
                      textField("End Time"),
                      Space.halfSpace(),
                      endTime(context),
                      Space.space(),
                      Text(error,
                          style: TextStyle(
                            color: Colors.red,
                          )),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              textField("Start Date"),
                              Space.halfSpace(),
                              startDate(context),
                              Space.space(),
                              textField("Start Time"),
                              Space.halfSpace(),
                              startTime(context),
                            ],
                          ),
                          Column(
                            children: [
                              textField("End Date"),
                              Space.halfSpace(),
                              endDate(context),
                              Space.space(),
                              textField("End Time"),
                              Space.halfSpace(),
                              endTime(context),
                            ],
                          ),
                        ],
                      ),
                      Space.space(),
                      Text(error,
                          style: TextStyle(
                            color: Colors.red,
                          )),
                    ],
                  )),
      ),
    );
  }

  void _assignActivity() async {
    assignProv.isAssignButtonDisabled = true;
    for (final element in widget.selectedUsers) {
      try {
        await dataProv.assignActivity(element.email, widget.activity.id!,
            _startDateAndTime, _endDateAndTime, widget.activity.category!.id);

        _editUserAssignedAct(element.email, element.assignedActivities + 1);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorAlertDialog(error: e.toString(), title: e.toString());
            });
      }
    }
    _showActivityOwnedTable();
    Navigator.pop(context);

    assignProv.isAssignButtonDisabled = false;
  }

  void _editUserAssignedAct(String email, int finishedAct) async {
    dataProv.isFetchingData = true;

    try {
      await dataProv.editUserAssignedAct(email, finishedAct);
      dataProv.isFetchingData = false;
    } catch (e) {
      dataProv.isFetchingData = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(error: e.toString(), title: e.toString());
          });
    }
  }

  Future<ActivityOwnedByUser> _getActivityOwnedData(User user) async {
    try {
      var data = await dataProv.fetchActivityOwnedByEmail(user.email);

      var newData = ActivityOwnedByUser(user: user, activities_owned: data);
      return newData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityOwnedByUser>> _getActivityOwnedByUserData(
      List<User> users) async {
    List<ActivityOwnedByUser> datas = [];

    menuProv.isFetchingData = true;

    for (final element in users) {
      try {
        ActivityOwnedByUser newData = await _getActivityOwnedData(element);
        datas.add(newData);
      } catch (e) {
        rethrow;
      }
    }

    return datas;
  }

  void _showActivityOwnedTable() async {
    List<ActivityOwnedByUser> datas = [];
    List<User> users = [];

    menuProv.isFetchingData = true;
    try {
      List<User> users = await dataProv
          .fetchUsersByRole(4); // 4 = id for role peserta_onboarding

      datas = await _getActivityOwnedByUserData(users);

      List<String> colnames = ['Email', 'Name', 'Activities Owned'];
      menuProv.isFetchingData = false;

      menuProv.setDashboardContent("table", datas, colnames,
          'Activity Owned List', 'activity_owned_list', null, null);
    } catch (e) {
      menuProv.isFetchingData = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(title: "HTTP Error", error: e.toString());
          });
    }
  }

  InkWell startDate(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context, 'start');
      },
      child: Container(
        padding: EdgeInsets.only(left: 7),
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.black38, width: 1.0)),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              size: 30,
            ),
            VerticalDivider(width: 10, color: Colors.black38),
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                _startDate,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell endDate(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context, 'end');
      },
      child: Container(
        padding: EdgeInsets.only(left: 7),
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.black38, width: 1.0)),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              size: 30,
            ),
            VerticalDivider(width: 10, color: Colors.black38),
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                _endDate,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell startTime(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectTime(context, 'start');
      },
      child: Container(
        padding: EdgeInsets.only(left: 7),
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.black38, width: 1.0)),
        child: Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 30,
            ),
            VerticalDivider(width: 10, color: Colors.black38),
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                _startTime,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell endTime(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectTime(context, 'end');
      },
      child: Container(
        padding: EdgeInsets.only(left: 7),
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.black38, width: 1.0)),
        child: Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 30,
            ),
            VerticalDivider(width: 10, color: Colors.black38),
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                _endTime,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  getInitDate(id) {
    late String initDateString;
    (id == 'start') ? initDateString = _startDate : initDateString = _endDate;
    if (initDateString.isNotEmpty) {
      return DateTime.parse(initDateString);
    }
    return DateTime.now();
  }

  Future<void> _selectDate(
    BuildContext context,
    String id,
  ) async {
    var initDate = getInitDate(id);

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: ORANGE_GARUDA,
                colorScheme: ColorScheme.light(primary: ORANGE_GARUDA),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!);
        });

    if (picked != null && picked != initDate) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String dateFormatted = formatter.format(picked);
      setState(() {
        if (id == 'start') {
          _startDate = dateFormatted;
          if (_startTime.isNotEmpty) {
            DateTime datetime = DateTime.parse(_startDate + ' ' + _startTime);
            final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
            _startDateAndTime = formatter.format(datetime);
          }
        } else {
          _endDate = dateFormatted;
          if (_endTime.isNotEmpty) {
            DateTime datetime = DateTime.parse(_endDate + ' ' + _endTime);
            final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
            _endDateAndTime = formatter.format(datetime);
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, String id) async {
    // var initDate = getInitDate(id);

    final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: ORANGE_GARUDA,
                colorScheme: ColorScheme.light(primary: ORANGE_GARUDA),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!);
        });

    if (timePicked != null) {
      String hour = (timePicked.hour < 10)
          ? '0' + timePicked.hour.toString()
          : timePicked.hour.toString();
      String minute = (timePicked.minute < 10)
          ? '0' + timePicked.minute.toString()
          : timePicked.minute.toString();
      String time = hour + ':' + minute;
      setState(() {
        if (id == 'start') {
          _startTime = time;
          if (_startDate.isNotEmpty) {
            DateTime datetime = DateTime.parse(_startDate + ' ' + _startTime);
            final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
            _startDateAndTime = formatter.format(datetime);
          }
        } else {
          _endTime = time;
          if (_endDate.isNotEmpty) {
            DateTime datetime = DateTime.parse(_endDate + ' ' + _endTime);
            final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
            _endDateAndTime = formatter.format(datetime);
          }
        }
      });
    }
  }

  Container textField(title) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
