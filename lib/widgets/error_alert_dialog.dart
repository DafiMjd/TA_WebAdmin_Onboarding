import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  const ErrorAlertDialog({
    Key? key,
    required this.error,
    required this.title
  }) : super(key: key);

  final Object error;
  final String title;

  @override
  Widget build(BuildContext context) {
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