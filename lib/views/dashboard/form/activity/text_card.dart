import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class TextCard extends StatefulWidget {
  const TextCard({Key? key, this.actDetail = null, required this.delete})
      : super(key: key);

  final ActivityDetail? actDetail;
  final Widget delete;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleField(
                "Text + " + widget.key.toString(), _ctrl.text.isEmpty, 18),
            Space.space(),
            TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(500),
                ],
                maxLines: 2,
                onChanged: (val) => setState(() {}),
                controller: _ctrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                )),
            Space.space(),
            Container(
              alignment: Alignment.centerRight,
              child: Tooltip(message: "Delete Card", child: widget.delete),
            ),
          ]),
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
