import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class ToDoCard extends StatefulWidget {
  const ToDoCard({
    Key? key,
    this.actDetail = null,
    required this.delete,
  }) : super(key: key);

  final ActivityDetail? actDetail;
  final Widget delete;

  @override
  State<ToDoCard> createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    if (widget.actDetail == null) {
      _ctrl = TextEditingController();
    } else {
      _ctrl = TextEditingController(text: widget.actDetail!.detail_desc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(DEFAULT_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              titleField("To Do", _ctrl.text.isEmpty, 18),
              Space.doubleSpace(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.check_box_outlined,
                    size: 30,
                  ),
                  const SizedBox(
                    width: DEFAULT_PADDING,
                  ),
                  Expanded(
                    // width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                        onChanged: (val) => setState(() {}),
                        controller: _ctrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        )),
                  ),
                ],
              ),
              Space.space(),
              Space.space(),
              Container(
                alignment: Alignment.centerRight,
                child: Tooltip(
                    message: "Delete Card",
                    child: widget.delete),
              ),
            ],
          ),
        ),
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
