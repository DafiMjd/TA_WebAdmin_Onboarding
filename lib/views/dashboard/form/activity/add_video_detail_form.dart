// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webadmin_onboarding/models/activity_detail.dart';
import 'package:webadmin_onboarding/providers/form/add_activity_form_provider.dart';
import 'package:webadmin_onboarding/utils/constants.dart';
import 'package:webadmin_onboarding/widgets/space.dart';

class AddVideoDetailForm extends StatefulWidget {
  const AddVideoDetailForm({Key? key, this.detail}) : super(key: key);
  @override
  _AddVideoDetailFormState createState() => _AddVideoDetailFormState();

  final ActivityDetail? detail;
}

class _AddVideoDetailFormState extends State<AddVideoDetailForm> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  PlatformFile? _file;

  bool _isLoading = false;

  String error = '';

  late AddActivityFormProvider formProv;

  var _linkCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    formProv = Provider.of<AddActivityFormProvider>(context, listen:  false);
    formProv.isVideoLinkEmpty = true;
  }

  @override
  Widget build(BuildContext context) {
    formProv = context.watch<AddActivityFormProvider>();
    return AlertDialog(
      title: Row(
        children: [
          titleField("Upload Video", 20),
          SizedBox(
            width: 10,
          ),
          Text(
            "(ext: mp4 | size: <= 20mb)",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          ),
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
                  child: titleField('Link video from youtube', 16)),
              Visibility(visible: _file == null, child: Space.space()),
              Visibility(
                visible: _file == null,
                child: TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    onChanged: (value) =>
                        formProv.isVideoLinkEmpty = _linkCtrl.text.isEmpty,
                    controller: _linkCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    )),
              ),
              Space.space(),
              Visibility(
                visible: (_file == null && formProv.isVideoLinkEmpty),
                child: ElevatedButton(
                  onPressed: () => _pickFiles(),
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
                visible: (_file != null || !formProv.isVideoLinkEmpty),
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
              Space.space(),
              Text(error,
                  style: TextStyle(
                    color: Colors.red,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  addActivityDetail() {
    final newIndex = formProv.actDetails.length;

    late var item;
    if (_file == null) {
      item = ActivityDetail(
          detail_name: _linkCtrl.text,
          detail_urutan: newIndex,
          detail_type: 'video_link',
          detail_desc: _linkCtrl.text,
          activity: formProv.activity);
    } else {
      item = ActivityDetail(
        detail_name: _file!.name,
        detail_urutan: newIndex,
        detail_type: 'video',
        detail_desc: _file!.name,
        activity: formProv.activity,
        // file: _bytesData,
        file: _file!.bytes,
      );
    }

    List<ActivityDetail> newList = formProv.actDetails;
    if (newList.isEmpty) {
      newList = [item];
    } else {
      newList.add(item);
    }

    formProv.actDetails = newList;
  }

  void _pickFiles() async {
    double maxSize = 20;
    _resetState();
    try {
      var _res = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowMultiple: false,
              // onFileLoading: (FilePickerStatus status) => print(status),
              allowedExtensions: ['mp4']);

      if (_res != null) {
        double sizeInMb = _res.files.first.size / (1024 * 1024);
        if (sizeInMb > maxSize) {
          error = 'Invalid Size';
        } else {
          error = '';
          _file = _res.files.first;
        }
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
    error = '';
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _file = null;
    });
  }

  Container titleField(title, textSize) => Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: textSize),
      ));
}
