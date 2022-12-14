import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class GroupCheckWidget extends StatefulWidget {
  GroupCheckWidget(
      {this.title,
      this.keyJson,
      this.controllerG1,
      this.controllerG2,
      this.controllerG3,
      this.controllerG4,
      this.isPassG1 = false,
      this.isPassG2 = false,
      this.isPassG3 = false,
      this.isPassG4 = false,
      this.passG1 = '',
      this.passG2 = '',
      this.passG3 = '',
      this.passG4 = ''});
  TextEditingController? controllerG1;
  TextEditingController? controllerG2;
  TextEditingController? controllerG3;
  TextEditingController? controllerG4;
  bool? isPassG1;
  bool? isPassG2;
  bool? isPassG3;
  bool? isPassG4;
  String? passG1;
  String? passG2;
  String? passG3;
  String? passG4;
  String? title;
  String? keyJson;
  @override
  _GroupCheckWidgetState createState() => _GroupCheckWidgetState();
}

class _GroupCheckWidgetState extends State<GroupCheckWidget> {
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
              Text(widget.title!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: widget.controllerG1,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(label: Text('????????????')),
                      ),
                    ),
                  ),
                  RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: widget.passG1!,
                    onChanged: (value) {
                      setState(() {
                        widget.passG1 = value;
                        if (value == '????????') {
                          print(value);
                          widget.isPassG1 = true;
                        } else {
                          widget.isPassG1 = false;
                        }
                      });
                    },
                    items: const ['????????', '??????'].reversed.toList(),
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                  const Text('???????????? 1'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: widget.controllerG2,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(label: Text('????????????')),
                      ),
                    ),
                  ),
                  RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: widget.passG2!,
                    onChanged: (value) {
                      setState(() {
                        widget.passG2 = value;
                        if (value == '????????') {
                          print(widget.isPassG2);
                          widget.isPassG2 = true;
                          print(widget.isPassG2);
                        } else {
                          widget.isPassG2 = false;
                        }
                      });
                    },
                    items: const ['????????', '??????'].reversed.toList(),
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                  const Text('???????????? 2'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: widget.controllerG3,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(label: Text('????????????')),
                      ),
                    ),
                  ),
                  RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: widget.passG3!,
                    onChanged: (value) {
                      setState(() {
                        widget.passG3 = value;
                        if (value == '????????') {
                          widget.isPassG3 = true;
                        } else {
                          widget.isPassG3 = false;
                        }
                      });
                    },
                    items: const ['????????', '??????'].reversed.toList(),
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                  const Text('???????????? 3'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: widget.controllerG4,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(label: Text('????????????')),
                      ),
                    ),
                  ),
                  RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: widget.passG4!,
                    onChanged: (value) {
                      setState(() {
                        widget.passG4 = value;
                        if (value == '????????') {
                          widget.isPassG4 = true;
                        } else {
                          widget.isPassG4 = false;
                        }
                      });
                    },
                    items: const ['????????', '??????'].reversed.toList(),
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                  const Text('??????????'),
                ],
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
