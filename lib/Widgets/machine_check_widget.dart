import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class MachineChekWidget extends StatefulWidget {
  MachineChekWidget({this.title, this.keyJson, this.validate});
  TextEditingController? controller = TextEditingController();
  String? pass = '';
  bool? isPass = false;
  String? title;
  String? keyJson;
  String? Function(String?)? validate;
  @override
  _MachineChekWidgetState createState() => _MachineChekWidgetState();
}

class _MachineChekWidgetState extends State<MachineChekWidget> {
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
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: widget.controller,
                  textAlign: TextAlign.right,
                  minLines: 1,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(label: Text('ملاحظات')),
                  validator: widget.validate,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
