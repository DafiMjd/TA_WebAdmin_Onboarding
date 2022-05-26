// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/activity.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

class ActivityPreview extends StatelessWidget {
  const ActivityPreview(
      {Key? key, required this.actDetails, required this.activity})
      : super(key: key);

  final Activity activity;
  final List<ActivityDetail> actDetails;

  @override
  Widget build(BuildContext context) {
    ScrollController scrollbarController = ScrollController();

    

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ORANGE_GARUDA,
          foregroundColor: Colors.black,
          title: Text(activity.activity_name!)),
      body: Scrollbar(
      controller: scrollbarController,
      thumbVisibility: true,
        
        child: SingleChildScrollView(
      controller: scrollbarController,
            child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(10),
          child: Card(
            elevation: 3,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActivityDetailWidget(
                    type: 'header',
                    text: 'Deskripsi',
                  ),
                  ActivityDetailWidget(
                    type: 'text',
                    text: activity.activity_description,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: actDetails.length,
                      itemBuilder: (context, i) {
                        return ActivityDetailWidget(
                          detail: actDetails[i],
                        );
                      }),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class ActivityDetailWidget extends StatefulWidget {
  const ActivityDetailWidget({Key? key, this.detail, this.type, this.text})
      : super(key: key);

  final ActivityDetail? detail;
  final String? type;
  final String? text;

  @override
  State<ActivityDetailWidget> createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    if (widget.detail == null) {
      return _getDeskripsi();
    }
    return _getDetailContent();
  }

  Container _getDetailContent() {
    if (widget.detail!.detail_type == 'header') {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text(
          widget.detail!.detail_desc,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else if (widget.detail!.detail_type == 'text') {
      return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(widget.detail!.detail_desc));
    } else if (widget.detail!.detail_type == 'to_do') {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            Text(widget.detail!.detail_desc),
          ],
        ),
      );
    }
    return Container();
  }

  Container _getDeskripsi() {
    if (widget.type == 'header') {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text(
          widget.text!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else if (widget.type == 'text') {
      return Container(
          margin: EdgeInsets.only(bottom: 10), child: Text(widget.text!));
    } else {
      return Container();
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      // MaterialState.hovered,
      MaterialState.focused,
    };
    // hovered
    // if (states.any(interactiveStates.contains)) {
    //   return Colors.blue;
    // }
    return Colors.black;
  }
}
