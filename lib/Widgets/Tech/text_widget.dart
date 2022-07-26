import 'package:flutter/material.dart';

import '../../Helpers/layout_constants.dart';

class TextWidget extends StatefulWidget {
  TextWidget(
      {this.jsonKey,
      this.title,
      this.direction = TextDirection.rtl,
      this.validate,
      this.controller});
  TextEditingController? controller;
  String? jsonKey;
  String? title;
  TextDirection direction;
  String? Function(String?)? validate;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: APP_BAR_COLOR),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: widget.direction,
            child: TextFormField(
              decoration: InputDecoration(label: Text(widget.title!)),
              controller: widget.controller,
              validator: widget.validate,
            ),
          ),
        ),
      ),
    );
  }
}
