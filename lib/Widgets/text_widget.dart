import 'package:flutter/material.dart';

import '../Helpers/layout_constants.dart';

class TextWidget extends StatefulWidget {
  TextWidget({this.jsonKey, this.title, this.validate});
  TextEditingController controller = TextEditingController();
  String? jsonKey;
  String? title;
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
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              validator: widget.validate,
              decoration: InputDecoration(label: Text(widget.title!)),
              controller: widget.controller,
            ),
          ),
        ),
      ),
    );
  }
}
