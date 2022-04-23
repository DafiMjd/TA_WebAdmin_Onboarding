import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/utils/constants.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({
    Key? key,
    required this.actDetail,
    required this.delete,
    required this.edit,
  }) : super(key: key);

  final ActivityDetail actDetail;
  final Widget delete;
  final Widget edit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.all(DEFAULT_PADDING),
        leading: Icon(getLeadingIcon(actDetail.detail_type)),
        title: Text(actDetail.detail_desc),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(message: "Edit Card", child: edit),
            Tooltip(message: "Delete Card", child: delete),
          ],
        ));
  }

  IconData getLeadingIcon(String detail_type) {
    if (detail_type == 'text') {
      return Icons.text_fields_sharp;
    } else if (detail_type == 'to_do') {
      return Icons.check_box_outlined;
    } else if (detail_type == 'image') {
      return Icons.image_sharp;
    } else if (detail_type == 'video') {
      return Icons.video_collection_outlined;
    } else if (detail_type == 'pdf') {
      return Icons.picture_as_pdf_sharp;
    }
    return Icons.text_fields_sharp;
  }
}
