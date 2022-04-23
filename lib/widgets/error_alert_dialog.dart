import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  ErrorAlertDialog({
    Key? key,
    required this.error,
    required this.title
  }) : super(key: key);

  String error;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (error.toString() == "XMLHttpRequest error.") {
      error = "Could Not Make Request";
    }
    return AlertDialog(
      title: Text(title),
      content: Text("$error"),
      actions: [
        TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(),
            child: const Text("okay"))
      ],
    );
  }
}