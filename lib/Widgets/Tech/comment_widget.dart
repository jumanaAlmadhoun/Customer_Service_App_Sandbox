import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  CommentWidget({this.title, this.isSelected = false});
  final String? title;
  bool isSelected;
  bool moveToWorkshop = false;
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: APP_BAR_COLOR),
            borderRadius: BorderRadius.circular(10),
            color: widget.isSelected ? CONTACTED_COLOR : Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  widget.title!.trim(),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.visible,
                ),
              ),
              Checkbox(
                  value: widget.isSelected,
                  onChanged: (value) {
                    setState(() {
                      widget.isSelected = value!;
                      if (widget.isSelected &&
                          widget.title!
                              .trim()
                              .contains('نوصي بنقل المكينة لمركز الصيانة')) {
                        widget.moveToWorkshop = true;
                      } else {
                        widget.moveToWorkshop = false;
                      }
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
