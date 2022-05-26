// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddFileDetailForm extends StatefulWidget {
  const AddFileDetailForm({Key? key, this.detail, required this.type}) : super(key: key);
  @override
  _AddFileDetailFormState createState() => _AddFileDetailFormState();

  final ActivityDetail? detail;
  final String type;
}

class _AddFileDetailFormState extends State<AddFileDetailForm> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  PlatformFile? _file;

  bool _isLoading = false;

  late AddActivityFormProvider formProv;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formProv = context.watch<AddActivityFormProvider>();
    return AlertDialog(
      title: Row(
        children: [
          getTitleField(widget.type),
          SizedBox(
            width: 10,
          ),
          getExtField(widget.type),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) => Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.fromLTRB(DEFAULT_PADDING, DEFAULT_PADDING,
              DEFAULT_PADDING, DEFAULT_PADDING),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: _file == null,
                child: ElevatedButton(
                  onPressed: () => _pickFiles(widget.type),
                  child: Text('Pick file'),
                ),
              ),
              Builder(
                  builder: (BuildContext context) => _isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const CircularProgressIndicator(),
                        )
                      : _file != null
                          ? Center(
                              child: Text(
                                _file!.name,
                              ),
                            )
                          : Container()),
              Visibility(
                visible: _file != null,
                child: Tooltip(
                    message: "Clear File",
                    child: IconButton(
                        onPressed: (() {
                          _clearFile();
                        }),
                        icon: const Icon(
                          Icons.clear_sharp,
                          size: 30,
                          color: Colors.black54,
                        ))),
              ),
              Space.space(),
              Visibility(
                visible: _file != null,
                child: ElevatedButton(
                  onPressed: () {
                    addActivityDetail();
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ),
              Space.space(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black45),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addActivityDetail() {

    final newIndex = formProv.actDetails.length;

    final item = ActivityDetail(
      detail_name: _file!.name,
      detail_urutan: newIndex,
      detail_type: widget.type,
      detail_desc: _file!.name,
      activity: formProv.activity,
      // file: _bytesData,
      file: _file!.bytes,
    );

    List<ActivityDetail> newList = formProv.actDetails;
    if (newList.isEmpty) {
      newList = [item];
    } else {
      newList.add(item);
    }

    formProv.actDetails = newList;
  }

  void _pickFiles(String type) async {
    late List<String> ext;
    switch (type) {
      case 'image':
        ext = ['png', 'jpg', 'jpeg'];
        break;
      case 'video':
        ext = ['mp4'];
        break;
      case 'document':
        ext = ['pdf'];
        break;
      default:
        ext = ['pdf'];

        break;
    }
    _resetState();
    try {
      var _res = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          // onFileLoading: (FilePickerStatus status) => print(status),
          allowedExtensions: ext);

      if (_res != null) {
        _file = _res.files.first;
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  _clearFile() {
    setState(() {
      _file = null;
    });
  }

  void _logException(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _file = null;
    });
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

  Container getTitleField(type) {
    if (type == 'pdf') {
      return titleField("Upload Document", 20);
    } else if (type == 'image') {
      return titleField("Upload Image", 20);
    } else if (type == 'video') {
      return titleField("Upload Video", 20);
    }

    return titleField("Add Text", 20);
  }

  Container titleField(title, textSize) => Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: textSize),
      ));
}
