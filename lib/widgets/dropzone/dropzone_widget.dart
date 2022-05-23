
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:universal_io/io.dart';

import 'package:webadmin_onboarding/models/file_data_model.dart';
import 'package:webadmin_onboarding/widgets/error_alert_dialog.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<FileDataModel> onDroppedFile;
  final List<String> mimes;
  final int maxFiles;

  const DropZoneWidget(
      {Key? key,
      required this.onDroppedFile,
      required this.mimes,
      required this.maxFiles})
      : super(key: key);

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  late DropzoneViewController ctrl;
  bool highlight = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: buildDecoration(
          child: Stack(
        children: [
          DropzoneView(
              onError: (value) => throw fileInvalid(value.toString(), context),
              onDropMultiple: (value) {
                (value!.length > widget.maxFiles)
                    ? fileInvalid("Unable To Drop Multiple Files", context)
                    :
                    // UploadedFile(value.first,
                    //     ctrl); // upload without checking the ext and size
                    checkFile(value.first, ctrl, context);
              },
              onCreated: (controller) => ctrl = controller,
              onHover: () => setState(() => highlight = true),
              onLeave: () => setState(() => highlight = false)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 80,
                  color: Colors.black,
                ),
                Text(
                  'Drop Files Here',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final events = await ctrl.pickFiles(
                        mime: widget.mimes, multiple: false);
                    if (events.isEmpty) return;
                    checkFile(events.first, ctrl, context);
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Choose File',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      primary: highlight
                          ? Colors.grey.shade200
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder()),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future checkFile(dynamic event, DropzoneViewController ctrl, context) async {
    final mime = await ctrl.getFileMIME(event);
    final byte = await ctrl.getFileSize(event);

    var sizeInMB = byte / (1024 * 1024);

    if (widget.mimes.contains(mime)) {
      if (sizeInMB < 200) {
        UploadedFile(event, ctrl);
      } else {
        fileInvalid("Invalid File Size", context);
      }
    } else {
      fileInvalid("Invalid File Extension", context);
    }
  }

  Future<dynamic> fileInvalid(String message, context) {
    setState(() {
      highlight = false;
    });
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
            title: "Error",
            error: message,
          );
        });
  }

  Future UploadedFile(dynamic event, DropzoneViewController ctrl) async {
    final name = event.name;
    var x = ctrl;

    final mime = await ctrl.getFileMIME(event);
    final byte = await ctrl.getFileSize(event);
    final url = await ctrl.createFileUrl(event);
    final stream = await ctrl.getFileStream(event);
    Uint8List fileData = await ctrl.getFileData(event);

    // File file = File.fromRawPath(fileData);
    // print('path' + file.path);

    // File file = File.fromRawPath(fileData);

    print('Name : $name');
    print('Mime: $mime');

    print('Size : ${byte / (1024 * 1024)}');
    print('URL: $url');

    final droppedFile = FileDataModel(
        name: name, mime: mime, bytes: byte, url: url, stream: stream, fileData: fileData);

    widget.onDroppedFile(droppedFile);
    setState(() {
      highlight = false;
    });
  }

  Widget buildDecoration({required Widget child}) {
    final colorBackground = highlight ? Colors.grey.shade200 : Colors.white;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10),
        child: DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.black,
            strokeWidth: 3,
            dashPattern: [8, 4],
            radius: Radius.circular(10),
            padding: EdgeInsets.zero,
            child: child),
        color: colorBackground,
      ),
    );
  }
}
