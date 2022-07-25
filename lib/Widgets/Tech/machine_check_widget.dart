import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Widgets/Tech/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class MachineCheckWidget extends StatefulWidget {
  MachineCheckWidget({this.title, this.keyJson, this.validate, this.comments});
  TextEditingController? controller = TextEditingController();
  String? pass = '';
  bool? isPass = null;
  String? title;
  String? keyJson;
  List<CommentWidget>? comments;
  String? Function(String?)? validate;
  @override
  _MachineCheckWidgetState createState() => _MachineCheckWidgetState();
}

class _MachineCheckWidgetState extends State<MachineCheckWidget> {
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: widget.pass!,
                    onChanged: (value) {
                      setState(() {
                        widget.pass = value;
                        if (value == 'نجاح') {
                          widget.isPass = true;
                        } else {
                          widget.isPass = false;
                        }
                      });
                    },
                    items: const ['نجاح', 'فشل'].reversed.toList(),
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                  Text(widget.title!),
                ],
              ),
              widget.comments != null
                  ? Column(
                      children: widget.comments!,
                    )
                  : Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: widget.controller,
                        textAlign: TextAlign.right,
                        minLines: 1,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        decoration:
                            const InputDecoration(label: Text('ملاحظات')),
                        validator: widget.validate,
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
