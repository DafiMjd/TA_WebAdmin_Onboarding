import 'dart:typed_data';

class FileDataModel{
  final String name;
  final String mime;
  final int bytes;
  final String url;
  final Stream<List<int>> stream;
  final Uint8List fileData;

  FileDataModel({required this.name,required this.mime,required this.bytes, required this.url, required this.stream, required this.fileData});

  String get size{
    final kb = bytes / 1024;
    final mb = kb / 1024;

    return mb > 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
  }

}