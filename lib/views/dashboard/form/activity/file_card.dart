import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/file_data_model.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropped_file_widget.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropzone_widget.dart';

class FileCard extends StatefulWidget {
  const FileCard({
    Key? key,
  }) : super(key: key);

  @override
  _FileCardState createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  FileDataModel? file;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(DEFAULT_PADDING),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Image",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "(ext: png/jpg | size: <200mb)",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: Visibility(
                      visible: file == null,
                      child: DropZoneWidget(
                        maxFiles: 1,
                        mimes: [
                          'image/jpeg',
                          'image/png',
                          'application/pdf',
                          'video/mp4'
                        ],
                        onDroppedFile: (file) =>
                            setState(() => this.file = file),
                      ),
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: Visibility(
                          visible: file != null,
                          child: DroppedFileWidget(file: file))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: file != null,
                    child: Tooltip(
                        message: "Clear File",
                        child: IconButton(
                            onPressed: (() {
                              file = null;
                              setState(() {});
                            }),
                            icon: const Icon(
                              Icons.clear_sharp,
                              size: 30,
                              color: Colors.black54,
                            ))),
                  ),
                  Tooltip(
                      message: "Delete Card",
                      child: IconButton(
                          onPressed: (() {}),
                          icon: const Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.black54,
                          ))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
