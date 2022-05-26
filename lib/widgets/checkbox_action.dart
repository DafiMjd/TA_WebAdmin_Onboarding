import 'package:flutter/material.dart';

class CheckboxAction extends StatefulWidget {
  const CheckboxAction({Key? key, required this.press}) : super(key: key);

  final Function press;

  @override
  State<CheckboxAction> createState() => _CheckboxActionState();
}

class _CheckboxActionState extends State<CheckboxAction> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        widget.press();
        setState(() {
          isChecked = value!;
        });
      },
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      // MaterialState.hovered,
      MaterialState.focused,
    };
    // hovered
    // if (states.any(interactiveStates.contains)) {
    //   return Colors.blue;
    // }
    return Colors.black;
  }
}
