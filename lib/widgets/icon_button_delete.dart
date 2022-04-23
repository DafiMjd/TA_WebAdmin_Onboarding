import 'package:flutter/material.dart';

class IconButtonDelete extends StatelessWidget {
   const IconButtonDelete({
    Key? key, this.size = 24, this.message = "Delete"
  }) : super(key: key);

  final double? size;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: message,
        child: IconButton(
            onPressed: (() {
            }),
            icon: Icon(Icons.delete,
          size: size,
          color: Colors.black54,)));
  }
}