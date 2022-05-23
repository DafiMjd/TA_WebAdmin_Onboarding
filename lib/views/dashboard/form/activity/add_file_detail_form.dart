import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/models/file_data_model.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropped_file_widget.dart';
import 'package:webadmin_onboarding/widgets/dropzone/dropzone_widget.dart';
import 'package:webadmin_onboarding/widgets/space.dart';
import 'dart:html';

class AddFileDetailForm extends StatefulWidget {
  const AddFileDetailForm({Key? key, this.detail, required this.type})
      : super(key: key);

  final ActivityDetail? detail;
  final String type;

  @override
  State<AddFileDetailForm> createState() => _AddFileDetailFormState();
}

class _AddFileDetailFormState extends State<AddFileDetailForm> {
  late final TextEditingController _ctrl;
  late AddActivityFormProvider formProv;

  Future<FilePickerResult?>? result;
  // FileDataModel? file;

  File? file;

  List<int>? _selectedFile;
  Uint8List? _bytesData;
  Uint8List? uploadedImage;

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

    return fileDialog();
  }

  fileDialog() {
    return AlertDialog(
      title: Row(
        children: [
          getTitleField(file == null, widget.type),
          SizedBox(
            width: 10,
          ),
          getExtField(widget.type),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height / 2;
          var width = MediaQuery.of(context).size.width / 2;

          return Container(
              width: width,
              padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING,
                  DEFAULT_PADDING, DEFAULT_PADDING, DEFAULT_PADDING),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Space.doubleSpace(),

                  // pick file
                  Visibility(
                    visible: file == null,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: ORANGE_GARUDA),
                        onPressed: () async {
                          // pickFiles(widget.type);
                          _startFilePicker();
                        },
                        child: Text('Pick File')),
                  ),

                  Space.doubleSpace(),

                  Visibility(
                      visible: file != null,
                      child: (file != null) ? Text(file!.name) : Container()),

                  // Stack(
                  //   children: [
                  //     Container(
                  //       height: MediaQuery.of(context).size.height * 0.4,
                  //       width: MediaQuery.of(context).size.width,
                  //       child: Visibility(
                  //         visible: file == null,
                  //         child: DropZoneWidget(
                  //             maxFiles: 1,
                  //             mimes: [
                  //               'application/pdf',
                  //             ],
                  //             onDroppedFile: (file) {
                  //               setState(() => this.file = file);
                  //               print(this.file);
                  //             }),
                  //       ),
                  //     ),
                  //     Container(
                  //         height: MediaQuery.of(context).size.height * 0.4,
                  //         width: MediaQuery.of(context).size.width,
                  //         child: Visibility(
                  //             visible: file != null,
                  //             child: DroppedFileWidget(file: file))),
                  //   ],
                  // ),
                  // Space.doubleSpace(),

                  // save button
                  Visibility(
                    visible: file != null,
                    child: ElevatedButton(
                        onPressed: () {
                          print('dafi');
                          if (widget.detail == null) {
                            print('dafi2');
                            addActivityDetail(file);
                            Navigator.pop(context);
                          } else {
                            print('dafi3');
                            editActivityDetail(file);
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
                  ),
                  Space.halfSpace(),
                  // cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black45),
                    onPressed: () {
                      print('d');
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  Space.halfSpace(),

                  Visibility(
                    visible: file != null,
                    child: Tooltip(
                        message: "Clear File",
                        child: IconButton(
                            onPressed: (() {
                              setState(() {
                                file = null;
                              });
                            }),
                            icon: const Icon(
                              Icons.clear_sharp,
                              size: 30,
                              color: Colors.black54,
                            ))),
                  ),
                ],
              ));
        },
      ),
    );
  }

  _startFilePicker() async {
    var uploadInput = FileUploadInputElement();
    uploadInput.accept = '.pdf';
    uploadInput.multiple = false;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      setState(() {
        file = uploadInput.files!.first;

        final files = uploadInput.files;
        if (files!.length == 1) {
          final file = files[0];
        }
      });

      // read file content as dataURL
      final files = uploadInput.files;
      if (files!.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            _bytesData = Base64Decoder().convert(result.toString().split(",").last);
          _selectedFile = _bytesData!.cast();
          });
        });

        reader.onError.listen((fileEvent) {
          // setState(() {
          //   option1Text = "Some Error occured while reading the file";
          // });
          print('error dafi');
        });

      }
    });
  }

  Future<void> pickFiles(String? filetype) async {
    switch (filetype) {
      // case 'image':
      //   result = await FilePicker.platform.pickFiles(
      //     type: FileType.image,
      //     allowedExtensions: ['png', 'jpg', 'jpeg'],
      //   );
      //   if (result == null) return;
      //   file = result!.files.first;
      //   setState(() {});
      //   break;
      // case 'video':
      //   result = await FilePicker.platform.pickFiles(
      //     type: FileType.video,
      //     allowedExtensions: ['mp4'],
      //   );
      //   if (result == null) return;
      //   file = result!.files.first;
      //   setState(() {});
      //   break;
      case 'document':
        result = FilePicker.platform.pickFiles(
          allowedExtensions: ['pdf'],
        );
        if (result == null) return;
        // file = result!.files.first;
        setState(() {});
        break;
    }
  }

  addActivityDetail(desc) {
    print(widget.type);
    final newIndex = formProv.actDetails.length;

    final item = ActivityDetail(
      detail_name: file!.name,
      detail_urutan: newIndex,
      detail_type: widget.type,
      detail_desc: file!.name,
      activity: formProv.activity,
      // file: file!.fileData,
      file: _bytesData,
    );

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

  getExtField(type) {
    if (type == 'pdf') {
      return Text(
        "(ext: pdf)",
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
      );
    } else if (type == 'image') {
      return Text(
        "(ext: jpg/png)",
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
      );
    } else if (type == 'video') {
      return Text(
        "(ext: png/jpg | size: <200mb)",
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
      );
    }
  }

  Container getTitleField(isEmpty, type) {
    if (type == 'pdf') {
      return titleField("Upload Document", isEmpty, 20);
    } else if (type == 'image') {
      return titleField("Upload Image", isEmpty, 20);
    } else if (type == 'video') {
      return titleField("Upload Video", isEmpty, 20);
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
