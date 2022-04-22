
import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/models/file_data_model.dart';

class DroppedFileWidget extends StatelessWidget {
  final FileDataModel? file;
  const DroppedFileWidget({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (file == null)
        ? EmptyFile(
            text: "No Selected File",
          )
        : Column(
            children: [
              Expanded(child: checkMime(file)),
              buildFileDetail2(file!),
            ],
          );
  }

  Widget checkMime(file) {
    if (file.mime == 'application/pdf') {
      return Icon(
        Icons.picture_as_pdf_sharp,
        size: 80,
      );
    } else if (file.mime == 'image/jpeg' ||
        file.mime == 'image/png' ||
        file.mime == 'image/jpg') {
      return ImageView(file: file);
    } else if (file.mime == 'video/mp4') {
      return Icon(
        Icons.video_collection_outlined,
        size: 80,
      );
    }
    return ImageView(file: file);
  }


  Widget buildFileDetail2(FileDataModel file) {
    return Column(
      children: [
        Text(
          'Filename: ${file.name}',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text('Size: ${file.size}', style: TextStyle(fontSize: 16)),
        Text('Type: ${file.mime}', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildFileDetail(FileDataModel? file) {
    final style = TextStyle(fontSize: 20);
    return Container(
      margin: EdgeInsets.only(left: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Selected File Preview ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          Text(
            'Name: ${file?.name}',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('Type: ${file?.mime}', style: style),
          const SizedBox(
            height: 10,
          ),
          Text('Size: ${file?.size}', style: style),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    required this.file,
  }) : super(key: key);

  final FileDataModel file;

  @override
  Widget build(BuildContext context) {
    return Image.network(file.url,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, _) => EmptyFile(text: "No Preview"));
  }
}

class EmptyFile extends StatelessWidget {
  const EmptyFile({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      color: Colors.blue.shade300,
      child: Center(child: Text(text)),
    );
  }
}
