import 'package:flutter/material.dart';

class FormBuilderTile extends StatelessWidget {
  const FormBuilderTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle})
      : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return (MediaQuery.of(context).size.width > 900)
        ? ListTile(
            leading: Icon(
              icon,
              size: 30,
            ),
            title: Text(title),
            // subtitle: Text(subtitle),
          )
        : Icon(
          icon,
          size: 30,
          color: Colors.black45,
        );
  }
}
