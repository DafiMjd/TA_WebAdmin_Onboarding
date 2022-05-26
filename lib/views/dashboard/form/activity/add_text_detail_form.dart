// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddTextDetailForm extends StatefulWidget {
  const AddTextDetailForm({Key? key, this.detail, required this.type})
      : super(key: key);

  final ActivityDetail? detail;
  final String type;

  @override
  State<AddTextDetailForm> createState() => _AddTextDetailFormState();
}

class _AddTextDetailFormState extends State<AddTextDetailForm> {
  late final TextEditingController _ctrl;
  late AddActivityFormProvider formProv;

  @override
  void initState() {
    super.initState();

    AddActivityFormProvider formProv =
        Provider.of<AddActivityFormProvider>(context, listen: false);

    if (widget.detail == null) {
      // means adding
      formProv.isActDetailEmpty = true;
      _ctrl = TextEditingController();
    } else {
      formProv.isActDetailEmpty = false;
      // means editing
      _ctrl = TextEditingController(text: widget.detail!.detail_desc);
    }
  }

  @override
  Widget build(BuildContext context) {
    formProv = context.watch<AddActivityFormProvider>();

    return textDialog();
  }

  textDialog() {
    return AlertDialog(
      title: getTitleField(formProv.isActDetailEmpty, widget.type),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.

          return Container(
            // height: height,
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING, DEFAULT_PADDING,
                DEFAULT_PADDING, DEFAULT_PADDING),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Space.halfSpace(),
                TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(500),
                    ],
                    maxLines: 7,
                    onChanged: (value) {
                      formProv.isActDetailEmpty = _ctrl.text.isEmpty;
                    },
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    )),

                Space.doubleSpace(),

                // save button
                ElevatedButton(
                    onPressed: (_ctrl.text.isEmpty)
                        ? () {}
                        : () {
                            if (widget.detail == null) {
                              addActivityDetail(_ctrl.text);
                              Navigator.pop(context);
                            } else {
                              editActivityDetail(_ctrl.text);
                              Navigator.pop(context);
                            }
                          },
                    child: (widget.detail == null)
                        ? const Text(
                            "Save",
                          )
                        : const Text(
                            "Save Changes",
                          )),
                Space.halfSpace(),
                // cancel button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black45),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                  ),
                )
              ],
            ),
          );
        },
      ),
      contentPadding: EdgeInsets.all(DEFAULT_PADDING),
    );
  }

  addActivityDetail(desc) {
    final newIndex = formProv.actDetails.length;

    final item = ActivityDetail(
        detail_name: widget.type + newIndex.toString(),
        detail_urutan: newIndex,
        detail_type: widget.type,
        detail_desc: desc,
        activity: formProv.activity);

    List<ActivityDetail> newList = formProv.actDetails;
    if (newList.isEmpty) {
      newList = [item];
    } else {
      newList.add(item);
    }

    formProv.actDetails = newList;
  }

  editActivityDetail(desc) {
    List<ActivityDetail> newList = formProv.actDetails;
    newList[widget.detail!.detail_urutan].detail_desc = desc;

    formProv.actDetails = newList;
  }

  Container getTitleField(isEmpty, type) {
    if (type == 'text') {
      return titleField("Add Text", isEmpty, 20);
    } else if (type == 'to_do') {
      return titleField("Add To Do List", isEmpty, 20);
    } else if (type == 'header') {
      return titleField("Add Header", isEmpty, 20);
    }

    return titleField("Add Text", isEmpty, 20);
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
