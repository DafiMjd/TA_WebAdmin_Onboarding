// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/utils/constants.dart';

class DetailCard extends StatelessWidget {
  const DetailCard({
    Key? key,
    required this.actDetail,
    this.delete,
    required this.edit,
  }) : super(key: key);

  final ActivityDetail actDetail;
  final Widget? delete;
  final Widget edit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.all(DEFAULT_PADDING),
        leading: Icon(getLeadingIcon(actDetail.detail_type)),
        title: Text(getTitle(actDetail.detail_type)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(message: "Edit Card", child: edit),
            Tooltip(message: "Delete Card", child: delete),
          ],
        ));
  }

  String getTitle(String detail_type) {
    if (detail_type == 'text' ||
        detail_type == 'to_do' ||
        detail_type == 'header') {
      return actDetail.detail_desc;
    } else {
      return actDetail.detail_name;
    }
  }

  IconData getLeadingIcon(String detail_type) {
    if (detail_type == 'text') {
      return Icons.text_fields_sharp;
    } else if (detail_type == 'to_do') {
      return Icons.check_box_outlined;
    } else if (detail_type == 'image') {
      return Icons.image_sharp;
    } else if (detail_type == 'video' || detail_type == 'video_link') {
      return Icons.video_collection_outlined;
    } else if (detail_type == 'pdf') {
      return Icons.picture_as_pdf_sharp;
    } else if (detail_type == 'header') {
      return Icons.h_mobiledata_outlined;
    }
    return Icons.text_fields_sharp;
  }
}
