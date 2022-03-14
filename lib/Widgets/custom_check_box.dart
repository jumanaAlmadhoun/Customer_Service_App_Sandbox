import 'package:customer_service_app/Localization/localization_constants.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({this.onChanged, this.title, this.value});
  String? title;
  bool? value;
  final onChanged;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: widget.value, onChanged: widget.onChanged),
        Text(getTranselted(context, widget.title)!),
      ],
    );
  }
}
